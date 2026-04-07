# Capture 1:1 Meeting

Take a meeting transcript, notes, or Gemini summary and create a structured Anytype object with key takeaways, quotes, action items, and context.

## Usage

```
/capture-1on1 <participant>
```

User will paste the transcript/notes. Example: `/capture-1on1 <name>`

## Workflow

1. **Parse the input** — handle Gemini transcripts, raw notes, or meeting summaries.

2. **Create one_on_one object** via MCP `createObject`:
   - `name`: "<Participant> <YYYY-MM-DD>"
   - `type_key`: "one_on_one"
   - `description`: one-line summary of key topics (~150 chars)
   - Properties: `quarter` (derived from date)
   - `related_person`: link to the participant's person object (search first, create if missing)

3. **Structure the body** with these sections:
   - **Key Takeaways** — bullet points grouped by topic
   - **Decisions Made** — anything agreed upon
   - **Action Items** — with checkboxes, who owns each
   - **Quotes Worth Noting** — direct quotes in blockquotes
   - **What Went Well** — what landed, what resonated
   - **What to Watch** — things to monitor, concerns
   - **Related** — names of related objects

4. **Update related objects**:
   - Search for the participant's person object — update body with 1:1 context
   - Search for "Memories" brain_note — update if any context changed
   - Update relevant work_note objects if projects were discussed

5. **Check for stale context** — if the meeting reveals something that contradicts existing objects, flag and update.

## Important

- Preserve the conversational tone — don't over-formalize quotes
- Flag sensitive interpersonal items
- Separate what was SAID from what it MEANS (interpretation goes in "What to Watch")
