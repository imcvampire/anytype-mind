#!/bin/bash
set -euo pipefail

# Anytype Mind Bootstrap Script
# Creates the complete type/property/tag/collection schema in Anytype
#
# Prerequisites:
#   - Anytype desktop app running
#   - API key created (Anytype Settings > API Keys)
#   - Set ANYTYPE_API_KEY environment variable
#
# Usage:
#   ANYTYPE_API_KEY="your-key-here" bash setup/bootstrap.sh
#   ANYTYPE_API_KEY="your-key-here" bash setup/bootstrap.sh --switch-space
#
# Optional:
#   ANYTYPE_API_DISABLE_RATE_LIMIT=1 to disable rate limiting during setup

SPACE_FILE=".space.md"
SWITCH_SPACE=false
if [ "${1:-}" = "--switch-space" ]; then
  SWITCH_SPACE=true
fi

API_BASE="http://localhost:31009/v1"
API_KEY="${ANYTYPE_API_KEY:?Set ANYTYPE_API_KEY environment variable}"
API_VERSION="2025-11-08"

auth_header="Authorization: Bearer $API_KEY"
version_header="Anytype-Version: $API_VERSION"
content_type="Content-Type: application/json"

call_api() {
  local method="$1"
  local endpoint="$2"
  local data="${3:-}"

  if [ -n "$data" ]; then
    curl -s -X "$method" "${API_BASE}${endpoint}" \
      -H "$auth_header" -H "$version_header" -H "$content_type" \
      -d "$data"
  else
    curl -s -X "$method" "${API_BASE}${endpoint}" \
      -H "$auth_header" -H "$version_header"
  fi
}

# Read saved space from .space.md
read_saved_space() {
  if [ -f "$SPACE_FILE" ]; then
    grep '^space_id:' "$SPACE_FILE" | head -1 | sed 's/^space_id: *//'
  fi
}

read_saved_space_name() {
  if [ -f "$SPACE_FILE" ]; then
    grep '^space_name:' "$SPACE_FILE" | head -1 | sed 's/^space_name: *//'
  fi
}

# Write selected space to .space.md
save_space() {
  local id="$1" name="$2"
  cat > "$SPACE_FILE" <<EOF
---
space_id: $id
space_name: $name
updated: $(date +%Y-%m-%d)
---

# Default Anytype Space

This file stores your selected Anytype space for AI tools to use.
It is gitignored — each machine keeps its own.

To change: \`bash setup/bootstrap.sh --switch-space\`
EOF
  echo "   Saved to $SPACE_FILE"
}

# Prompt user to pick a space from a list
pick_space() {
  local spaces_json="$1"
  local space_count="$2"

  echo "$spaces_json" | python3 -c "
import sys, json
spaces = json.load(sys.stdin).get('data', [])
for i, s in enumerate(spaces, 1):
    print(f\"    {i}) {s['name']}  ({s['id']})\")
" 2>/dev/null
  echo ""
  printf "   Select a space [1-%s] or 'new' to create one: " "$space_count"
  read -r CHOICE

  if [ "$CHOICE" = "new" ]; then
    printf "   Space name [Mind]: "
    read -r NEW_NAME
    NEW_NAME="${NEW_NAME:-Mind}"
    echo ">> Creating '$NEW_NAME' space..."
    RESULT=$(call_api POST "/spaces" "{\"name\":\"$NEW_NAME\",\"description\":\"Personal knowledge base\"}")
    SPACE_ID=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
    SPACE_NAME="$NEW_NAME"
    echo "   Created space: $SPACE_ID"
  elif echo "$CHOICE" | grep -qE '^[0-9]+$' && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "$space_count" ]; then
    SPACE_ID=$(echo "$spaces_json" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][$CHOICE-1]['id'])" 2>/dev/null)
    SPACE_NAME=$(echo "$spaces_json" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][$CHOICE-1]['name'])" 2>/dev/null)
    echo "   Using space: $SPACE_NAME ($SPACE_ID)"
  else
    echo "   Invalid choice. Aborting."
    exit 1
  fi
}

echo "=== Anytype Mind Bootstrap ==="
echo ""

# 1. Resolve space — saved, prompted, or created
SAVED_ID=$(read_saved_space)
SAVED_NAME=$(read_saved_space_name)

if [ -n "$SAVED_ID" ] && [ "$SWITCH_SPACE" = false ]; then
  echo ">> Using saved space: ${SAVED_NAME:-$SAVED_ID}"
  echo "   (from $SPACE_FILE — run with --switch-space to change)"
  SPACE_ID="$SAVED_ID"
  SPACE_NAME="${SAVED_NAME:-}"
else
  if [ "$SWITCH_SPACE" = true ]; then
    echo ">> Switching space..."
  else
    echo ">> Checking spaces..."
  fi

  SPACES_JSON=$(call_api GET "/spaces")
  SPACE_COUNT=$(echo "$SPACES_JSON" | python3 -c "import sys,json; print(len(json.load(sys.stdin).get('data',[])))" 2>/dev/null || echo "0")

  if [ "$SPACE_COUNT" -eq 0 ]; then
    echo "   No spaces found."
    echo ">> Creating 'Mind' space..."
    RESULT=$(call_api POST "/spaces" '{"name":"Mind","description":"Personal knowledge base"}')
    SPACE_ID=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
    SPACE_NAME="Mind"
    echo "   Created space: $SPACE_ID"
  elif [ "$SPACE_COUNT" -eq 1 ] && [ "$SWITCH_SPACE" = false ]; then
    SPACE_ID=$(echo "$SPACES_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['id'])" 2>/dev/null)
    SPACE_NAME=$(echo "$SPACES_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'][0]['name'])" 2>/dev/null)
    echo "   Using space: $SPACE_NAME ($SPACE_ID)"
  else
    echo "   Found $SPACE_COUNT spaces:"
    echo ""
    pick_space "$SPACES_JSON" "$SPACE_COUNT"
  fi

  save_space "$SPACE_ID" "${SPACE_NAME:-}"
fi

if [ -z "${SPACE_ID:-}" ]; then
  echo "Error: Failed to determine space ID."
  exit 1
fi

# If only switching space, stop here
if [ "$SWITCH_SPACE" = true ]; then
  echo ""
  echo "Space updated. Run without --switch-space to bootstrap types/properties."
  exit 0
fi

echo ""

# 2. Create properties
echo ">> Creating properties..."

get_prop_id() { eval echo "\${PROP_ID_$1:-}"; }

create_property() {
  local key="$1" name="$2" format="$3"
  echo "   Creating property: $name ($format)"
  RESULT=$(call_api POST "/spaces/$SPACE_ID/properties" \
    "{\"name\":\"$name\",\"key\":\"$key\",\"format\":\"$format\"}")
  PROP_ID=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null || echo "")
  eval "PROP_ID_${key}=\$PROP_ID"
  sleep 1
}

create_property "vault_tags" "Tags" "multi_select"
create_property "status" "Status" "select"
create_property "quarter" "Quarter" "select"
create_property "ticket" "Ticket" "text"
create_property "severity" "Severity" "select"
create_property "incident_role" "Incident Role" "select"
create_property "review_cycle" "Review Cycle" "select"
create_property "related_person" "Related Person" "object"
create_property "related_team" "Related Team" "object"
create_property "project_name" "Project" "text"
create_property "title" "Title" "text"

echo ""

# 3. Create tags for select/multi_select properties
echo ">> Creating tags for select properties..."

create_tag() {
  local prop_id="$1" tag_name="$2"
  call_api POST "/spaces/$SPACE_ID/properties/$prop_id/tags" \
    "{\"name\":\"$tag_name\"}" > /dev/null 2>&1
  sleep 0.5
}

# Status tags
PROP=$(get_prop_id status)
if [ -n "$PROP" ]; then
  echo "   Status tags..."
  for tag in active completed archived proposed accepted deprecated; do
    create_tag "$PROP" "$tag"
  done
fi

# Quarter tags
PROP=$(get_prop_id quarter)
if [ -n "$PROP" ]; then
  echo "   Quarter tags..."
  for year in 2025 2026 2027; do
    for q in Q1 Q2 Q3 Q4; do
      create_tag "$PROP" "${q}-${year}"
    done
  done
fi

# Severity tags
PROP=$(get_prop_id severity)
if [ -n "$PROP" ]; then
  echo "   Severity tags..."
  for tag in low medium high critical; do
    create_tag "$PROP" "$tag"
  done
fi

# Incident Role tags
PROP=$(get_prop_id incident_role)
if [ -n "$PROP" ]; then
  echo "   Incident Role tags..."
  for tag in incident-lead responder observer; do
    create_tag "$PROP" "$tag"
  done
fi

# Review Cycle tags
PROP=$(get_prop_id review_cycle)
if [ -n "$PROP" ]; then
  echo "   Review Cycle tags..."
  for tag in h1-2025 h2-2025 h1-2026 h2-2026 h1-2027 h2-2027; do
    create_tag "$PROP" "$tag"
  done
fi

# vault_tags tags
PROP=$(get_prop_id vault_tags)
if [ -n "$PROP" ]; then
  echo "   Vault tags..."
  for tag in work-note decision perf thinking north-star competency person team brain index moc incident evidence; do
    create_tag "$PROP" "$tag"
  done
fi

echo ""

# 4. Create types
echo ">> Creating types..."

create_type() {
  local key="$1" name="$2" icon="$3" layout="$4"
  echo "   Creating type: $name"
  call_api POST "/spaces/$SPACE_ID/types" \
    "{\"name\":\"$name\",\"key\":\"$key\",\"icon\":\"$icon\",\"layout\":\"$layout\"}" > /dev/null 2>&1
  sleep 1
}

create_type "work_note" "Work Note" "clipboard" "basic"
create_type "incident" "Incident" "warning" "basic"
create_type "one_on_one" "1:1 Note" "people" "basic"
create_type "decision" "Decision Record" "scale" "basic"
create_type "person" "Person" "person" "profile"
create_type "team" "Team" "group" "basic"
create_type "competency" "Competency" "star" "basic"
create_type "pr_analysis" "PR Analysis" "code" "basic"
create_type "review_brief" "Review Brief" "document" "basic"
create_type "brain_note" "Brain Note" "brain" "basic"
create_type "brag_entry" "Brag Entry" "trophy" "basic"
create_type "thinking_note" "Thinking Note" "thought" "basic"

echo ""

# 5. Create key brain_note objects
echo ">> Creating key brain note objects..."

create_brain_note() {
  local name="$1" desc="$2" body="$3"
  echo "   Creating: $name"
  call_api POST "/spaces/$SPACE_ID/objects" \
    "{\"name\":\"$name\",\"type_key\":\"brain_note\",\"description\":\"$desc\",\"body\":\"$body\"}" > /dev/null 2>&1
  sleep 1
}

create_brain_note "North Star" "Living goals document — read at session start" "# North Star\n\n## Current Focus\n\n- \n\n## Short-term Goals\n\n- \n\n## Medium-term Goals\n\n- \n\n## Anti-Goals\n\n- \n\n## Shifts Log\n\n| Date | Shift | Reason |\n|------|-------|--------|\n"
create_brain_note "Memories" "Index of memory topics — links to other brain_notes" "# Memories\n\nPersistent context retained across sessions. Each topic lives in its own brain_note.\n\n- North Star — living goals document\n- Key Decisions — architectural and workflow decisions\n- Patterns — recurring conventions\n- Gotchas — things that have bitten before\n- Skills — custom commands and workflows\n\n## Recent Context\n\n-"
create_brain_note "Key Decisions" "Architectural and workflow decisions worth recalling" "# Key Decisions\n\nDecisions that shape how we work. Each entry links to the decision object.\n\n-"
create_brain_note "Patterns" "Recurring patterns and conventions discovered across work" "# Patterns\n\nConventions and patterns observed across projects and sessions.\n\n-"
create_brain_note "Gotchas" "Things that have bitten before and will bite again" "# Gotchas\n\nKnown pitfalls and traps. Check here before repeating mistakes.\n\n-"
create_brain_note "Skills" "Custom slash commands, workflows, and agent capabilities" "# Skills\n\nRegistry of available commands and workflows.\n\nSee SKILL.md for the full command table and agent list."

echo ""

# 6. Create collections
echo ">> Creating collections..."

create_collection() {
  local name="$1" desc="$2"
  echo "   Creating collection: $name"
  call_api POST "/spaces/$SPACE_ID/objects" \
    "{\"name\":\"$name\",\"type_key\":\"collection\",\"description\":\"$desc\"}" > /dev/null 2>&1
  sleep 1
}

create_collection "Active Work" "Current active projects (work_note with status=active)"
create_collection "Archived Work" "Completed projects (work_note with status=completed)"
create_collection "Incidents" "All incident records"
create_collection "1:1 Notes" "Meeting notes from 1-on-1 conversations"
create_collection "People" "Organization directory"
create_collection "Teams" "Team directory"
create_collection "Brag Entries" "Achievement log"
create_collection "Evidence" "PR analyses and review evidence"
create_collection "Competencies" "Skill definitions"
create_collection "Brain Notes" "Operational knowledge"
create_collection "Mind Dashboard" "All key objects — curated overview"

echo ""
echo "=== Bootstrap Complete ==="
echo ""
echo "Space: ${SPACE_NAME:-$SPACE_ID} ($SPACE_ID)"
echo "Saved: $SPACE_FILE"
echo ""
echo "Next steps:"
echo "  1. Verify in Anytype app that types, properties, and collections were created"
echo "  2. Copy SKILL.md to CLAUDE.md (Claude Code) or AGENTS.md (Codex)"
echo "  3. Configure MCP server in your AI tool (see setup/anytype-mcp-config.json)"
echo ""
echo "To change the default space later:"
echo "  bash setup/bootstrap.sh --switch-space"
