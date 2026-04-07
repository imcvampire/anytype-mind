# Incident Capture

Capture an incident from Slack channels, DMs, and threads into structured Anytype objects. Produces a complete incident object with timeline, people, analysis, and brag entry.

## Usage

```
/incident-capture <slack-urls>
```

Provide one or more Slack URLs: incident channels, DM conversations, threads.

## Subagents

Launch both in parallel when starting the capture:
- **`slack-archaeologist`** — reads all Slack sources, builds unified timeline with attribution
- **`people-profiler`** — bulk creates/updates person objects for everyone involved

## Workflow

### 1. Gather Raw Data

For each Slack URL provided:
- Read the full channel/DM/thread using Slack MCP tools
- Read ALL sub-threads
- Note every timestamp, person, and message

### 2. Identify People

For every person who posted or was mentioned:
- Fetch their Slack profile
- Search Anytype for existing person objects via MCP `searchSpace`
- Track who did what (reported, investigated, fixed, confirmed)

### 3. Build the Timeline

Reconstruct a detailed timeline from all sources with exact timestamps and attribution.

### 4. Create the Incident Object

Via MCP `createObject`:
- `type_key`: "incident"
- `name`: descriptive incident name
- `description`: ~150 chars
- Properties: `status`, `quarter`, `ticket`, `severity`, `incident_role`, `vault_tags: [work-note, incident]`
- Body sections: Context, Root Cause, Resolution, Timeline, Impact, Involved Personnel, Notes, Analysis, Related

### 5. Create/Update Person Objects

For key people involved who don't have person objects:
- Create via MCP `createObject` with type_key="person"
- Set properties: description, title, related_team
For existing person objects:
- Update body to add the incident as a Key Moment

### 6. Update Related Objects

- Search for "Memories" brain_note — add incident summary
- Search for "Patterns" brain_note — update if this reveals a recurring pattern
- Search for "Gotchas" brain_note — update if this reveals a technical gotcha
- Create a brag_entry object for the relevant quarter with relations to the incident

### 7. Offer Next Steps

- "Want me to prepare the incident ticket fields?"
- "Want me to draft a message for the incident channel?"
- "Should I run `/vault-audit` to verify everything links properly?"

## Important

- **Read every message** — don't skim or summarize prematurely
- **Preserve exact timestamps**
- **Attribute everything** — who said what, who did what
- **Be blameless in public docs** — use commit SHAs, not names, in shareable documents
- **Private analysis is honest** — the vault object can include strategic analysis
