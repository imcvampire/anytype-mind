# Generate Review Brief

Generate a performance review context transfer document from Anytype data. Supports manager version and peer version.

## Usage

```
/review-brief <audience> [period]
```

Examples:
- `/review-brief manager "Q3 2024 + Q4 2024"`
- `/review-brief peers "Q3 2024 + Q4 2024"`

## Subagent

- **`review-prep`** — aggregates all evidence (brag entries, decisions, incidents, competencies, 1:1 feedback, PR scans) for the period

Launch the subagent first, then use its output to write the brief.

## Workflow

### 1. Gather Data

Search Anytype via MCP for:
- Existing review_brief objects for this cycle
- brag_entry objects for the period's quarters
- pr_analysis objects for the cycle
- work_note objects from the period
- competency objects (all — for reference)
- one_on_one objects from the period

### 2. Generate Content

**For manager audience:**
- Frame for non-technical audience — outcome language
- Include: The Arc (narrative), Impact at a Glance, Impact Details, Competency Highlights, Documentation Trail
- No object references — use plain text

**For peer audience:**
- More technical but accessible
- Organize by project
- Include "Other things worth mentioning"
- Casual tone

### 3. Create review_brief Object

Via MCP `createObject`:
- `type_key`: "review_brief"
- `name`: "<Cycle> Review Brief - <Audience>"
- Properties: `review_cycle`, `vault_tags: [perf, review-prep]`
- Body: the generated brief

### 4. Verify

- Cross-check PR counts and dates against pr_analysis objects
- Ensure all links reference real objects

## Important

- NEVER include: sensitive interpersonal details, 1:1 talking points, personal strategic notes in shared versions
- Manager version: non-technical language, professional
- Peer version: project-focused, accessible
