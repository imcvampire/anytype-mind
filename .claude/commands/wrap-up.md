# Wrap Up

Full session review before ending. Review context, ways of working, objects created/modified, consistency, and suggest improvements.

## Usage

```
/wrap-up
```

Triggered when the user says "wrap up", "let's wrap", "wrapping up", or similar. Claude should invoke this automatically.

## Subagent

- **`brag-spotter`** — run at the end to find uncaptured wins and competency gaps from the session

## Workflow

### 1. Review What Was Done

Scan the conversation for:
- Objects created or modified via Anytype MCP (list them all with types and names)
- Person objects created or updated
- Brain_note objects updated (Patterns, Gotchas, Key Decisions, Memories)
- Brag_entry objects added
- Relations created between objects

### 2. Verify Object Quality

For each object created or modified this session, check via MCP `getObject`:
- Properties complete? (`description`, `quarter`, `status`, type-specific required fields per `references/type-schema.md`)
- At least one relation to another object?
- Correct type_key?
- Description accurate and ~150 chars?
- Status property correct?

### 3. Check Index Consistency

Search for key brain_note objects and verify:
- "Memories" brain_note — does it reflect what happened this session?
- "North Star" brain_note — did any focus areas shift?
- Search for person objects — any new people or relationship changes to capture?
- Search for brag_entry objects — any wins from this session?

### 4. Check for Orphans

- Any new objects without relations to other objects?
- Any new person objects not linked from relevant work_note objects?
- Any thinking_note objects that should be promoted to proper types or deleted?

### 5. Archive Check

- Are there work_note objects with status=active that should be status=completed?

### 6. Ways of Working Review

Check if this session revealed:
- A new pattern that should be added to the "Patterns" brain_note?
- A new gotcha for the "Gotchas" brain_note?
- A workflow improvement for the "Skills" brain_note?
- A SKILL.md update needed (new convention, stale reference)?

### 7. Suggest Improvements

Based on how the session went:
- Were there friction points in the workflow?
- Did we do something manually that could be automated?
- Any new properties or types that would help future queries?

### 8. Report

Present a concise summary:
- **Done**: what was captured this session
- **Fixed**: issues found and resolved
- **Flagged**: things that need user input
- **Suggested**: improvements for next time

## Important

- This is a READ + VERIFY pass, not a creation pass. Fix small issues (missing properties, broken relations), but flag larger changes for user approval.
- Be honest about what's missing — the goal is leaving the Anytype space in a better state than you found it.
- If North Star goals shifted during the session, suggest updating the brain_note.
