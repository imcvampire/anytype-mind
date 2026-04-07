# Slack Deep Scan

Deep scan Slack channels and DMs for evidence involving a specific person or project. Extracts every touchpoint with timestamps for review evidence or project documentation.

## Usage

```
/slack-scan <target> [channels...] [date-range]
```

Examples:
- `/slack-scan "Jane Doe" C0EXAMPLE1 C0EXAMPLE2 "after:2026-03-16"`
- `/slack-scan "project:example" C0EXAMPLE1 C0EXAMPLE2`

## Workflow

1. **Read each channel** fully using Slack MCP tools (paginate until all messages are fetched).

2. **Search for the person** across channels.

3. **Check DMs** the user points to. Read full history for the relevant period.

4. **For each message involving the target**, extract:
   - Timestamp and channel
   - What was said/done
   - Context
   - Evidence type: technical work, leadership, collaboration, problem-solving, initiative

5. **Organize by date** with clear headers per day. Separate:
   - **Project evidence** — create or update relevant work_note objects
   - **Review/personal context** — update person objects or create review-related objects
   - **Team dynamics** — update person objects

6. **Flag items** that contradict or complement existing Anytype objects.

## Important

- Be meticulous — timestamps matter for evidence
- Capture exact quotes showing initiative, leadership, or problem-solving
- Note when the person was tagged by others (shows they're a go-to person)
- Separate project work from review prep from personal conversations
- Check for threads when a message has replies
