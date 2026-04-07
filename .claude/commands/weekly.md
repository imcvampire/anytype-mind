---
description: "Weekly synthesis — cross-session review of Anytype activity, North Star alignment, patterns, uncaptured wins, and forward priorities."
---

Cross-session synthesis of the past week. Bridges daily standup (lightweight) and quarterly review brief (comprehensive). This is ANALYSIS, not verification — find patterns, surface drift, detect uncaptured work.

## Subagent

- **`brag-spotter`** — run with weekly scope to find uncaptured wins and competency gaps

## Workflow

### 1. Gather Week's Activity

Automated — no user input needed:

- Search Anytype via MCP `searchSpace` sorted by `last_modified_date` desc, limit 50 — all recently modified objects
- Filter to objects modified in the past 7 days
- Search for one_on_one objects from this week
- Search for work_note objects with status changes
- Search for incident objects from this week

### 2. North Star Alignment

Search for "North Star" brain_note and compare actual activity against stated focus:

- **Aligned work**: which Current Focus items got attention this week?
- **Drift**: work that doesn't map to any stated goal (not necessarily bad — flag it)
- **Silent goals**: focus items with zero activity
- **Emerging themes**: work patterns suggesting a focus shift

### 3. Cross-Day Patterns

Look across the week's objects for:
- Recurring themes (same topic in multiple objects)
- Multiple incidents touching the same system
- Topics appearing in BOTH work_note and one_on_one objects (these are signals)
- Context that evolved across sessions

### 4. Uncaptured Win Detection

Run the `brag-spotter` subagent, then filter to wins from the past 7 days.

Additionally check:
- Were completed items logged as brag_entry objects?
- Any 1:1 feedback or kudos not captured?
- Incident contributions not bragged about?

### 5. Competency Signal Mapping

Search for competency objects. For each:
- Was it exercised this week? (check for work_note objects with relations to it)
- Present as a compact table: competency name, exercised (yes/no)

### 6. Forward Look

- Work_note objects with status=active that need attention
- North Star goals that need focus next week
- Suggested priority ordering based on goals + momentum + gaps

### 7. Present Synthesis

- **This Week**: 3-5 bullet summary of what happened
- **North Star Check**: alignment status
- **Patterns**: cross-day themes
- **Uncaptured Wins**: items for brag entries (from brag-spotter)
- **Competency Coverage**: compact table
- **Next Week**: suggested priorities

After presenting, offer:
- "Want me to create brag_entry objects for any of these wins?"
- "Should I update the North Star brain_note?"

## Important

- This is transient analysis by default — do NOT create objects unless the user asks.
- Keep the tone analytical, not cheerful.
- Be honest about drift and silent goals.
- Don't duplicate standup (daily) or wrap-up (session). This is SYNTHESIS across days.
