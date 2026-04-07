---
description: "Freeform capture mode. Dump anything — conversations, decisions, incidents, wins, thoughts — and I'll route it all to the right Anytype objects with proper types, properties, and relations."
---

Process the following freeform dump. For each distinct piece of information:

1. **Classify** it: decision, incident, 1-on-1 content, win/achievement, architecture, project update, person context, or general work note.
2. **Search first**: Use MCP `searchSpace` to check if a related object already exists. Prefer updating existing objects over creating new ones for small updates.
3. **Create or update** the appropriate Anytype object following SKILL.md conventions:
   - Correct `type_key` (work_note, incident, one_on_one, decision, person, brag_entry, brain_note, etc.)
   - All required properties per `references/type-schema.md` (description, status, quarter, etc.)
   - Markdown body following `references/markdown-conventions.md`
   - Relations to relevant objects (people, teams, competencies)
4. **Add to collections** if the object should appear in curated lists (e.g., add incidents to "Incidents" collection).
5. **Update brain_notes** as needed (Memories, Brag Doc equivalent, People context).
6. **Create relations**: Ensure every new object relates to at least one existing object.

After processing everything, provide a summary:
- What was captured and what type each object was created as
- Any existing objects updated
- Relations created
- Any items you weren't sure how to classify (ask the user)

Content to process:
$ARGUMENTS
