# Vault Audit

Deep structural audit of the Anytype space. Checks object integrity, properties, relations, collections, and consistency. Fix what can be fixed, flag what needs user input.

**When to use**: After substantial sessions, after reorganization, or periodically to maintain space health. For lighter end-of-session checks, use `/wrap-up` instead.

## Usage

```
/vault-audit
```

## Subagents

Launch sequentially:
- **`vault-librarian`** — orphan detection, property validation, stale objects, index consistency
- **`cross-linker`** — finds objects missing relations

## Workflow

### 1. Check Object Types

List all objects via MCP `listObjects` for each type_key. Verify:
- work_note objects with status=active actually represent current work
- work_note objects with status=completed are properly closed
- incident objects have all required properties (ticket, severity, incident_role)
- person objects have title property set
- All objects have description property (~150 chars)

### 2. Check Required Properties

For each object type, verify required properties per `references/type-schema.md`:
- work_note: description, status, quarter
- incident: description, status, quarter, ticket, severity, incident_role
- one_on_one: description, quarter
- decision: description, status
- person: description, title
- All others: description

### 3. Check Relations

For each object:
- Does it have at least one relation to another object?
- work_note objects should relate to at least one person or team
- one_on_one objects should relate to the participant (person)
- brag_entry objects should relate to evidence (work_note or incident)
- incident objects should relate to people involved

### 4. Check for Orphans

Search for objects with no inbound relations:
- For each type, search all objects
- Check which objects are not referenced by any other object
- These are orphans — suggest which objects should link to them

### 5. Check for Stale Active Objects

Search work_note objects with status=active:
- Check last_modified_date — objects not modified in 60+ days may need archiving
- Flag for user review

### 6. Check Brain Notes

Search for the key brain_note objects (North Star, Memories, Key Decisions, Patterns, Gotchas, Skills):
- Do they all exist?
- Is "Memories" up to date?
- Is "North Star" reflecting current reality?

### 7. Check Collections

List all collections. Verify:
- Do the expected collections exist (Active Work, Incidents, People, etc.)?
- Do collection contents match their intended filters?

### 8. Fix and Report

- Fix clearly wrong things (missing required properties, objects with wrong status)
- For ambiguous issues, list them and ask the user
- Summarize:
  - **Fixed**: issues resolved
  - **Flagged**: needs user input
  - **Suggested**: improvements

## Important

- Don't delete anything without asking
- Don't create new objects during audit — just fix existing ones
- Preserve existing property values when editing
