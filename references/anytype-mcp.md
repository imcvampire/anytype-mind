# Anytype MCP Tool Reference

The Anytype MCP server (`@anyproto/anytype-mcp`) exposes REST API endpoints as MCP tools. All operations require the Anytype desktop app running locally.

**Base URL**: `http://localhost:31009/v1`
**Auth**: Bearer token via `OPENAPI_MCP_HEADERS` environment variable
**API Version**: `2025-11-08`

## Common Patterns

### Find an Object by Name

Search first, then get by ID:
```
1. searchSpace(space_id, query="North Star", types=["brain_note"])
2. getObject(space_id, object_id=<id from search result>)
```

### Create an Object

```
createObject(space_id, {
  name: "Project Alpha",
  type_key: "work_note",
  body: "# Context\n\nMarkdown body here...",
  description: "Auth service refactor for improved security",
  icon: "rocket",
  properties: {
    status: "active",
    quarter: "Q2-2026",
    project_name: "auth-refactor"
  }
})
```

### Update an Object

```
updateObject(space_id, object_id, {
  name: "Project Alpha (Completed)",
  body: "updated markdown...",
  properties: {
    status: "completed"
  }
})
```

### Append to Object Body

Read current body, append, then update:
```
1. obj = getObject(space_id, object_id)
2. new_body = obj.body + "\n\n## New Section\n\nAppended content"
3. updateObject(space_id, object_id, { body: new_body })
```

## Endpoint Reference

### Search

#### Search Globally
```
POST /v1/search
```
Search across all spaces. Body:
```json
{
  "query": "search text",
  "types": ["work_note", "incident"],
  "sort": { "direction": "desc", "property": "last_modified_date" }
}
```
Query params: `offset`, `limit`

#### Search Within Space
```
POST /v1/spaces/{space_id}/search
```
Same body as global search, scoped to one space.

### Objects

#### List Objects
```
GET /v1/spaces/{space_id}/objects?offset=0&limit=50
```
Supports property-based filtering:
- `?status=active` -- exact match
- `?created_date[gte]=2024-01-01` -- date range
- `?vault_tags[in]=urgent,important` -- tag inclusion
- `?done=false` -- boolean filter

#### Get Object
```
GET /v1/spaces/{space_id}/objects/{object_id}
```
Returns full object: name, body (markdown), properties, type, icon.

#### Create Object
```
POST /v1/spaces/{space_id}/objects
```
Body:
```json
{
  "name": "Object Name",
  "type_key": "work_note",
  "body": "# Markdown content",
  "description": "Brief description (~150 chars)",
  "icon": "emoji_name",
  "template_id": "optional_template_id",
  "properties": {
    "status": "active",
    "quarter": "Q1-2026"
  }
}
```

#### Update Object
```
PATCH /v1/spaces/{space_id}/objects/{object_id}
```
Partial update -- only send fields to change:
```json
{
  "name": "Updated Name",
  "body": "Updated markdown body",
  "type_key": "new_type_key",
  "properties": {
    "status": "completed"
  }
}
```

#### Delete Object
```
DELETE /v1/spaces/{space_id}/objects/{object_id}
```

### Types

#### List Types
```
GET /v1/spaces/{space_id}/types?offset=0&limit=50
```
Supports filtering: `?name[contains]=work`

#### Get Type
```
GET /v1/spaces/{space_id}/types/{type_id}
```

#### Create Type
```
POST /v1/spaces/{space_id}/types
```
Body:
```json
{
  "name": "Work Note",
  "key": "work_note",
  "icon": "clipboard",
  "layout": "basic",
  "properties": ["status", "quarter", "project_name", "related_team"]
}
```

#### Update Type
```
PATCH /v1/spaces/{space_id}/types/{type_id}
```

#### Delete Type
```
DELETE /v1/spaces/{space_id}/types/{type_id}
```

### Properties

#### List Properties
```
GET /v1/spaces/{space_id}/properties
```
Supports filtering: `?name[contains]=status`

#### Create Property
```
POST /v1/spaces/{space_id}/properties
```
Body:
```json
{
  "name": "Status",
  "key": "status",
  "format": "select"
}
```

Supported formats: `text`, `number`, `date`, `select`, `multi_select`, `object`, `checkbox`, `url`

#### Update / Delete Property
```
PATCH /v1/spaces/{space_id}/properties/{property_id}
DELETE /v1/spaces/{space_id}/properties/{property_id}
```

### Tags (for select/multi_select properties)

#### List Tags
```
GET /v1/spaces/{space_id}/properties/{property_id}/tags
```

#### Create Tag
```
POST /v1/spaces/{space_id}/properties/{property_id}/tags
```
Body: `{ "name": "active" }`

Tags can also be created inline when creating properties with `format: select` or `multi_select`.

#### Update / Delete Tag
```
PATCH /v1/spaces/{space_id}/properties/{property_id}/tags/{tag_id}
DELETE /v1/spaces/{space_id}/properties/{property_id}/tags/{tag_id}
```

### Lists (Collections)

#### Add Objects to List
```
POST /v1/spaces/{space_id}/lists/{list_id}/objects
```
Body: `{ "object_ids": ["id1", "id2"] }`

#### Remove Objects from List
```
DELETE /v1/spaces/{space_id}/lists/{list_id}/objects
```
Body: `{ "object_ids": ["id1"] }`

#### List Views
```
GET /v1/spaces/{space_id}/lists/{list_id}/views
```

#### Get View Objects
```
GET /v1/spaces/{space_id}/lists/{list_id}/views/{view_id}/objects
```

### Templates

#### List Templates for Type
```
GET /v1/spaces/{space_id}/types/{type_id}/templates
```

#### Get Template
```
GET /v1/spaces/{space_id}/types/{type_id}/templates/{template_id}
```

### Spaces

#### List Spaces
```
GET /v1/spaces
```

#### Get Space
```
GET /v1/spaces/{space_id}
```

#### Create Space
```
POST /v1/spaces
```

#### Update Space
```
PATCH /v1/spaces/{space_id}
```

### Members

#### List Members
```
GET /v1/spaces/{space_id}/members
```

#### Get/Update Member
```
GET /v1/spaces/{space_id}/members/{member_id}
PATCH /v1/spaces/{space_id}/members/{member_id}
```

## Rate Limits

- Burst: 60 requests
- Sustained: 1 request/second
- Disable for bulk operations: set `ANYTYPE_API_DISABLE_RATE_LIMIT=1` before starting Anytype
- 429 response means rate limit hit -- back off and retry

