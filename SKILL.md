# Anytype Mind

Personal knowledge base powered by Anytype -- an external brain for work notes, decisions, performance tracking, and AI context.

All data lives in Anytype as typed objects with properties and relations. AI agents interact with Anytype via the **Anytype MCP Server** (`@anyproto/anytype-mcp`).

## Prerequisites

- Anytype desktop app running (API at `localhost:31009`)
- Anytype MCP server configured in your AI tool (see `setup/anytype-mcp-config.json`)
- API key created in Anytype Settings > API Keys
- Default space selected (stored in `.space.md` -- run `bash setup/bootstrap.sh` to set)

## Default Space

The file `.space.md` (gitignored) stores the selected Anytype space ID. Read it at session start to know which `space_id` to pass to every MCP call. If it doesn't exist, prompt the user to run `bash setup/bootstrap.sh`.

To switch spaces: `bash setup/bootstrap.sh --switch-space`

## Quick Reference

| What | How |
|------|-----|
| Read an object | MCP `searchSpace` by name, then `getObject` by ID |
| Create an object | MCP `createObject` with `type_key`, `name`, `body`, properties |
| Update an object | MCP `updateObject` with object ID and changed fields |
| Search | MCP `searchGlobal` or `searchSpace` with query, types, sort |
| List by type | MCP `listObjects` with type filter or property filters |
| Add relation | Set an `object`-format property on the source object |

See `references/anytype-mcp.md` for full tool patterns.

## Custom Slash Commands

Defined in `.claude/commands/`. See `references/` for supporting docs.

| Command | Purpose |
|---------|---------|
| `/standup` | Morning kickoff -- load context, review recent changes, surface tasks, priorities |
| `/dump` | Freeform capture -- dump anything, gets routed to the right Anytype objects |
| `/wrap-up` | Full session review -- verify objects, relations, suggest improvements |
| `/humanize` | Voice-calibrated editing -- make object body sound like you, not AI |
| `/weekly` | Weekly synthesis -- cross-session patterns, North Star alignment, uncaptured wins |
| `/capture-1on1` | Capture 1:1 meeting transcript into structured Anytype object |
| `/incident-capture` | Capture incident from Slack channels/DMs into structured objects |
| `/slack-scan` | Deep scan Slack channels/DMs for evidence |
| `/peer-scan` | Deep scan a peer's GitHub PRs for review prep |
| `/review-brief` | Generate review brief (manager or peer version) |
| `/self-review` | Write self-assessment for review tool |
| `/review-peer` | Write peer review |
| `/vault-audit` | Audit object integrity, relations, orphans, stale context |
| `/project-archive` | Mark a project as completed, update collections |

## Data Model

All knowledge is stored as **Anytype objects** with typed properties. See `references/type-schema.md` for the full schema.

### Object Types

| Type Key | Purpose | Key Properties |
|----------|---------|----------------|
| `work_note` | Project work, deliverables | status, quarter, project_name, related_team |
| `incident` | Incidents and outages | status, quarter, ticket, severity, incident_role |
| `one_on_one` | 1:1 meeting notes | quarter, related_person |
| `decision` | Decision records | status |
| `person` | People in your org | title, related_team |
| `team` | Teams and groups | -- |
| `competency` | Skill definitions | -- |
| `pr_analysis` | PR deep scan evidence | related_person, review_cycle |
| `review_brief` | Review period briefs | review_cycle |
| `brain_note` | Operational knowledge | -- |
| `brag_entry` | Achievement records | quarter |
| `thinking_note` | Scratchpad drafts | -- |

### Properties

All objects support these base properties (built-in or custom):
- `description` (text) -- ~150 chars, always filled
- `vault_tags` (multi_select) -- classification tags
- `status` (select) -- active, completed, archived, proposed, accepted, deprecated
- `quarter` (select) -- Q1-2025, Q2-2025, etc.

See `references/type-schema.md` for the full property list per type.

### Collections

Objects are organized into Anytype collections that replace folder-based navigation:

| Collection | Filter |
|------------|--------|
| Active Work | type=work_note, status=active |
| Archived Work | type=work_note, status=completed |
| Incidents | type=incident |
| 1:1 Notes | type=one_on_one |
| People | type=person |
| Teams | type=team |
| Brag Entries | type=brag_entry |
| Evidence | type=pr_analysis |
| Competencies | type=competency |
| Brain Notes | type=brain_note |

See `references/collection-views.md` for collection patterns.

## Session Workflow

### Starting a Substantial Session

The `SessionStart` hook loads context via Anytype MCP: North Star goals, active work, recent changes, open tasks.

**Shortcut**: Run `/standup` for a structured morning kickoff.

If doing it manually:
1. Search for `brain_note` named "North Star" -- ground suggestions in current goals
2. Search `work_note` objects with `status=active` -- see current projects
3. Search `brain_note` named "Memories" -- index of memory topics
4. Search for `action` type objects with `done=false` -- pending items

### Ending a Substantial Session

**When the user says "wrap up" or similar -- invoke `/wrap-up` automatically.**

If `/wrap-up` is not invoked, at minimum:
1. Update completed projects: set `status: completed` on work_note objects
2. Verify new objects have relations to at least one other object
3. Update brain_note objects (Key Decisions, Patterns, Gotchas) with key learnings
4. Check if wins should be added as brag_entry objects
5. Offer to update the "North Star" brain_note if goals shifted

### Creating Objects

1. **Always set properties**: at minimum `description` (~150 chars) and type-specific required properties per `references/type-schema.md`.
2. **Use the correct type_key** for the object being created.
3. **Write body in markdown** following `references/markdown-conventions.md`.
4. **Add relations immediately** -- every object must relate to at least one other object.
5. **Add to collections** if not auto-included by type filters.

### Object Types and Where They Go

- **Project work?** -- create `work_note` with status=active
- **Completed project?** -- `work_note` with status=completed
- **Incident?** -- create `incident` object (use `/incident-capture`)
- **1:1 meeting?** -- create `one_on_one` object (use `/capture-1on1`)
- **Decision?** -- create `decision` object
- **Person info?** -- create/update `person` object
- **Team info?** -- create/update `team` object
- **Achievement?** -- create `brag_entry` object
- **Codebase knowledge?** -- create `brain_note` object
- **Scratchpad?** -- create `thinking_note` object (promote or delete later)

### Relations -- This Is Critical

**Every object must have at least one relation.** An object with no relations is a bug.

Use object-format properties (`related_person`, `related_team`) to create relations between objects. Additionally, mention related objects by name in the body text.

Relation patterns:
- **work_note <-> decision**: bidirectional relations
- **work_note -> competency**: link to competencies demonstrated
- **work_note -> team**: link to team(s) involved
- **work_note -> person**: link people involved
- **one_on_one -> person**: always link the meeting participant
- **brag_entry -> work_note**: every entry links to evidence
- **brain_note -> source**: every memory links to where it was learned

### Thinking Workflow

Use `thinking_note` objects for drafts and reasoning before creating final objects.

1. Create a `thinking_note` with descriptive name
2. Reason through the problem in the body
3. Promote findings to proper typed objects
4. Delete the thinking_note -- it served its purpose

## Memory System

All persistent knowledge lives in Anytype as `brain_note` objects:

| Object Name | Purpose |
|-------------|---------|
| North Star | Living goals document, read at session start |
| Memories | Index of memory topics with links to other brain_notes |
| Key Decisions | Architectural and workflow decisions |
| Patterns | Recurring conventions discovered across work |
| Gotchas | Things that have bitten before |
| Skills | Custom commands and workflows |

When asked to "remember" something:
1. Search for the appropriate brain_note by name
2. Update its body with the new knowledge
3. Add a relation to the context object
4. Update the "Memories" brain_note index if a new topic was created

## Tags Convention

Use the `vault_tags` multi_select property:

- **Type tags**: `work-note`, `decision`, `perf`, `thinking`, `north-star`, `competency`, `person`, `team`, `brain`
- **Index tags**: `index`, `moc`

Other metadata uses dedicated properties (`status`, `quarter`, `review_cycle`, etc.), not tags.

## Properties for Querying

These properties enable search and collection filtering:

- `review_cycle: h2-2024` -- find all review material for a cycle
- `related_person: <object_id>` -- find all evidence related to a person
- `related_team: <object_id>` -- find all objects related to a team
- `status: active` -- find active projects
- `quarter: Q1-2026` -- find all work for a quarter
- `ticket: TICKET-123` -- find incident by ticket number
- `severity: high` -- incident severity
- `incident_role: incident-lead` -- your role in an incident

## Subagents

Specialized agents in `.claude/agents/` for heavy operations.

| Agent | Purpose | Invoked by |
|-------|---------|------------|
| `brag-spotter` | Finds uncaptured wins and competency gaps | `/wrap-up`, `/weekly` |
| `context-loader` | Loads all context about a person, project, or concept | Direct |
| `cross-linker` | Finds objects missing relations | `/vault-audit` |
| `people-profiler` | Bulk creates/updates person objects from Slack profiles | `/incident-capture` |
| `review-prep` | Aggregates all performance evidence for a review period | `/review-brief` |
| `slack-archaeologist` | Full Slack reconstruction | `/incident-capture` |
| `vault-librarian` | Object integrity, orphans, stale content | `/vault-audit` |
| `review-fact-checker` | Verifies claims in review drafts against vault sources | `/self-review`, `/review-peer` |

## Hooks (Claude Code only)

| Hook | When | What |
|------|------|------|
| SessionStart | On startup/resume | Load North Star, active work, recent changes, tasks via Anytype MCP |
| UserPromptSubmit | Every message | Classifies content and injects routing hints |
| PostToolUse | After MCP writes | Validates object properties and relations |
| PreCompact | Before context compaction | Backs up session transcript |
| Stop | End of every session | Lightweight checklist reminder |

## Anytype MCP Reference

The Anytype MCP server exposes these endpoint groups:
- **Search**: Global and space-specific search with type/property filters
- **Objects**: CRUD operations with markdown body support
- **Types**: Manage custom object types
- **Properties**: Manage typed properties (text, date, select, multi_select, object)
- **Tags**: Manage select/multi_select tag values
- **Lists**: Manage collections and their views
- **Templates**: List and read templates

See `references/anytype-mcp.md` for detailed tool call patterns.

## Rules

- All data lives in Anytype -- never create standalone .md files for vault content.
- Every object needs a `description` property (~150 chars).
- Every object must have at least one relation to another object.
- Prefer Anytype search over broad listing when looking for specific objects.
- When asked to "remember" something, update the relevant brain_note in Anytype.
- Check for existing objects before creating new ones (search first).
- Respect Anytype rate limits: burst 60, then 1/sec sustained.
- The Anytype desktop app must be running for the MCP server to work.

## Cross-Platform Support

This project works in:
- **Claude Code**: Copy `SKILL.md` to `CLAUDE.md`. Hooks load from `.claude/settings.json`.
- **Codex**: Copy `SKILL.md` to `AGENTS.md`. Configure Anytype MCP in Codex settings.
- **Cursor**: MCP configured in `.cursor/mcp.json`. Commands load from `.claude/commands/`.
