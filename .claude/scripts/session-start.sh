#!/bin/bash
set -eo pipefail

# Session start hook for Anytype Mind

echo "## Session Context"
echo ""
echo "### Date"
echo "$(date +%Y-%m-%d) ($(date +%A))"
echo ""

echo "### Default Space"
if [ -f ".space.md" ]; then
  SPACE_ID=$(grep '^space_id:' .space.md | head -1 | sed 's/^space_id: *//')
  SPACE_NAME=$(grep '^space_name:' .space.md | head -1 | sed 's/^space_name: *//')
  echo "Space: ${SPACE_NAME:-unknown} (${SPACE_ID:-not set})"
  echo "Use this space_id for all Anytype MCP calls."
else
  echo "No default space configured. Run: bash setup/bootstrap.sh"
fi
echo ""

echo "### Anytype Status"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:31009/v1/spaces -H "Authorization: Bearer ${ANYTYPE_API_KEY:-not-set}" -H "Anytype-Version: 2025-11-08" 2>/dev/null | grep -q "200"; then
  echo "Anytype API: connected"
else
  echo "Anytype API: NOT CONNECTED — ensure Anytype desktop app is running and API key is set"
fi
echo ""

echo "### Quick Reference"
echo '- brain_note "North Star" — current goals'
echo '- work_note objects with status=active — current projects'
echo '- brain_note "Memories" — context index'
echo ""
echo "Run /standup for a full structured morning kickoff."
