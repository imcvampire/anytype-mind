# Project Archive

Mark a completed project as archived in Anytype — update status, verify properties, and update related objects.

## Usage

```
/project-archive <project name>
```

## Workflow

### 1. Find the Object

Search for work_note objects with status=active via MCP `searchSpace` matching the project name. Confirm with the user before proceeding.

### 2. Update Properties

Via MCP `updateObject`:
- Set `status: completed`
- Verify `quarter` property is correct
- Verify `description` reflects the final state

### 3. Update Related Objects

- Search for "North Star" brain_note — if this project is listed in Current Focus, note it as completed
- Search for brag_entry objects — verify the project is captured in the relevant quarter
- Search for "Memories" brain_note — update if the project is mentioned as "in progress"

### 4. Verify

- Check that the object no longer appears in "Active Work" collection queries
- Verify relations to people, teams, and competency objects are intact

## Important

- Don't archive without user confirmation
- If the project has related incident objects, ask if their status should also be updated
