# Collection Views Reference

Anytype collections organize objects into filtered, sorted views.

## Core Collections

These collections should be created during bootstrap (`setup/bootstrap.sh`):

| Collection Name | Purpose | Base Filter |
|----------------|---------|-------------|
| Active Work | Current projects | type_key=work_note, status=active |
| Archived Work | Completed projects | type_key=work_note, status=completed |
| Incidents | All incidents | type_key=incident |
| 1:1 Notes | Meeting notes | type_key=one_on_one |
| People | Org directory | type_key=person |
| Teams | Team directory | type_key=team |
| Brag Entries | Achievement log | type_key=brag_entry |
| Evidence | PR analyses | type_key=pr_analysis |
| Competencies | Skill definitions | type_key=competency |
| Brain Notes | Operational knowledge | type_key=brain_note |
| Mind Dashboard | All key objects | Mixed types (curated) |

## Working with Collections via MCP

### Creating a Collection

Collections in Anytype are objects with a special layout. Create via:
```
createObject(space_id, {
  name: "Active Work",
  type_key: "collection",
  description: "Current active projects",
  icon: "rocket"
})
```

### Adding Objects to a Collection

```
addListObjects(space_id, list_id, {
  object_ids: ["obj_id_1", "obj_id_2"]
})
```

### Removing Objects from a Collection

```
removeListObjects(space_id, list_id, {
  object_ids: ["obj_id_1"]
})
```

### Listing Collection Views

```
listViews(space_id, list_id)
```

### Getting Objects from a View

```
getViewObjects(space_id, list_id, view_id)
```

## Querying Without Collections

For ad-hoc queries, use the search and list endpoints with property filters:

### By Type
```
listObjects(space_id, ?type_key=work_note)
```

### By Property Value
```
listObjects(space_id, ?status=active)
listObjects(space_id, ?quarter=Q1-2026)
listObjects(space_id, ?severity=high)
```

### By Date Range
```
listObjects(space_id, ?created_date[gte]=2026-01-01&created_date[lte]=2026-03-31)
```

### By Tag
```
listObjects(space_id, ?vault_tags[in]=incident,work-note)
```

### Combined Filters
```
listObjects(space_id, ?status=active&quarter=Q2-2026)
```

## Limitations

- **No computed formulas**: Computed fields like age or evidence count must be calculated in commands/agents when needed.
- **No grouping in API**: The API returns flat lists. Grouping by property must be done client-side (in commands/agents).
- **No custom sort formulas**: Sort by built-in properties only (name, created_date, last_modified_date, or custom properties).
