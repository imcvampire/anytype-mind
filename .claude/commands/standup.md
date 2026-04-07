---
description: "Morning kickoff. Load today's context from Anytype, review recent changes, surface open tasks, and identify priorities."
---

Run the morning standup using Anytype MCP:

1. Search for `brain_note` named "North Star" via MCP `searchSpace` — read its body for current goals
2. List `work_note` objects with `status=active` via MCP `listObjects` — see current projects
3. Search for recently modified objects via MCP `searchSpace` sorted by `last_modified_date` desc, limit 15 — review what changed
4. Search for `action` type objects with `done=false` via MCP `listObjects` — open tasks
5. Search for `brain_note` named "Memories" — check recent context

Present a structured standup summary:
- **Yesterday**: What got done (from recently modified objects)
- **Active Work**: Current work_note objects with status=active and their descriptions
- **Open Tasks**: Pending action items
- **North Star Alignment**: How active work maps to current goals
- **Suggested Focus**: What to prioritize today based on goals + open items

Keep it concise. This is a quick orientation, not a deep dive.
