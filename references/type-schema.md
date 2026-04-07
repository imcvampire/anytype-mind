# Anytype Mind -- Type Schema

Defines all custom types, properties, tags, and their relationships for the Anytype Mind space.

## Types

### work_note
- **Name**: Work Note
- **Layout**: basic
- **Icon**: clipboard
- **Properties**: status, quarter, project_name, related_team, vault_tags
- **Use**: Project work, deliverables, active tasks

### incident
- **Name**: Incident
- **Layout**: basic
- **Icon**: warning
- **Properties**: status, quarter, ticket, severity, incident_role, related_team, vault_tags
- **Use**: Production incidents, outages, post-mortems

### one_on_one
- **Name**: 1:1 Note
- **Layout**: basic
- **Icon**: people
- **Properties**: quarter, related_person, vault_tags
- **Use**: Meeting notes from 1-on-1 conversations

### decision
- **Name**: Decision Record
- **Layout**: basic
- **Icon**: scale
- **Properties**: status, vault_tags
- **Use**: Architectural and workflow decisions

### person
- **Name**: Person
- **Layout**: profile
- **Icon**: person
- **Properties**: title, related_team, vault_tags
- **Use**: People in your organization

### team
- **Name**: Team
- **Layout**: basic
- **Icon**: group
- **Properties**: vault_tags
- **Use**: Teams and organizational groups

### competency
- **Name**: Competency
- **Layout**: basic
- **Icon**: star
- **Properties**: vault_tags
- **Use**: Skill definitions with level criteria

### pr_analysis
- **Name**: PR Analysis
- **Layout**: basic
- **Icon**: code
- **Properties**: related_person, review_cycle, vault_tags
- **Use**: GitHub PR deep scan evidence for reviews

### review_brief
- **Name**: Review Brief
- **Layout**: basic
- **Icon**: document
- **Properties**: review_cycle, vault_tags
- **Use**: Performance review period briefs

### brain_note
- **Name**: Brain Note
- **Layout**: basic
- **Icon**: brain
- **Properties**: vault_tags
- **Use**: Operational knowledge (memories, patterns, decisions, gotchas, goals)

### brag_entry
- **Name**: Brag Entry
- **Layout**: basic
- **Icon**: trophy
- **Properties**: quarter, vault_tags
- **Use**: Achievement records with links to evidence

### thinking_note
- **Name**: Thinking Note
- **Layout**: basic
- **Icon**: thought
- **Properties**: vault_tags
- **Use**: Scratchpad drafts -- promote to proper types or delete when done

## Properties

### Built-in (available on all objects)
- `name` (text) -- object title
- `description` (text) -- ~150 char summary, always required
- `created_date` (date) -- auto-set on creation
- `last_modified_date` (date) -- auto-updated

### Custom Properties

| Key | Name | Format | Tags/Values | Used By |
|-----|------|--------|-------------|---------|
| `vault_tags` | Tags | multi_select | work-note, decision, perf, thinking, north-star, competency, person, team, brain, index, moc, incident, evidence | All types |
| `status` | Status | select | active, completed, archived, proposed, accepted, deprecated | work_note, incident, decision |
| `quarter` | Quarter | select | Q1-2025, Q2-2025, Q3-2025, Q4-2025, Q1-2026, Q2-2026, Q3-2026, Q4-2026 | work_note, incident, one_on_one, brag_entry |
| `ticket` | Ticket | text | -- | incident |
| `severity` | Severity | select | low, medium, high, critical | incident |
| `incident_role` | Incident Role | select | incident-lead, responder, observer | incident |
| `review_cycle` | Review Cycle | select | h1-2025, h2-2025, h1-2026, h2-2026 | pr_analysis, review_brief |
| `related_person` | Related Person | object | -- (links to person objects) | one_on_one, pr_analysis |
| `related_team` | Related Team | object | -- (links to team objects) | work_note, incident, person |
| `project_name` | Project | text | -- | work_note |
| `title` | Title | text | -- (job title) | person |

## Required Properties by Type

These MUST be set when creating objects of each type:

| Type | Required Properties |
|------|-------------------|
| work_note | description, status, quarter |
| incident | description, status, quarter, ticket, severity, incident_role |
| one_on_one | description, quarter |
| decision | description, status |
| person | description, title |
| team | description |
| competency | description |
| pr_analysis | description, related_person, review_cycle |
| review_brief | description, review_cycle |
| brain_note | description |
| brag_entry | description, quarter |
| thinking_note | description |

## Key Brain Note Objects

These brain_note objects form the memory system and should always exist:

| Name | Purpose |
|------|---------|
| North Star | Living goals document -- read at session start |
| Memories | Index of memory topics -- links to other brain_notes |
| Key Decisions | Architectural and workflow decisions worth recalling |
| Patterns | Recurring conventions discovered across work |
| Gotchas | Things that have bitten before and will bite again |
| Skills | Custom slash commands and workflows |

## Relation Patterns

- **work_note** should relate to: person, team, competency, decision objects
- **incident** should relate to: person (involved), team, competency objects
- **one_on_one** should relate to: person (the participant)
- **brag_entry** should relate to: work_note or incident (the evidence)
- **pr_analysis** should relate to: person (the subject)
- **person** should relate to: team
- **brain_note** should relate to: source objects where knowledge was learned
- **decision** should relate to: work_note that led to the decision
