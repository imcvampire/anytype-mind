---
description: "Voice-calibrated editing — makes Claude-drafted text sound like you wrote it, not like AI wrote it."
---

Edit an Anytype object's body to match your writing voice. This is voice calibration, not pattern removal — learn HOW you write, not just what to avoid.

## Usage

```
/humanize <object name or search term>
```

## Workflow

### 1. Load Voice Samples

Search for 2-3 recent objects you actually wrote or heavily edited to calibrate voice:
- Search for "North Star" brain_note — how you write about yourself
- Search for recent one_on_one objects — natural conversational voice
- Any brain_note with your authentic writing style

Extract voice fingerprint: sentence length, punctuation habits, how you open sections, how you qualify statements, ratio of direct-to-hedged language, use of dashes and fragments.

### 2. Read Target Object

Search for the object specified in $ARGUMENTS via MCP `searchSpace`, then `getObject` to read full body.

Detect context from type_key:
- **one_on_one** — conversational, direct, uses "I", okay to be informal
- **review_brief / pr_analysis** — corporate-confident but human, evidence-based, respect charcount
- **incident** — precise, factual, timeline-oriented, no filler
- **brain_note** — terse shorthand, fragments okay
- **Default** — colleague-to-colleague, like explaining something in a 1:1

### 3. Edit Body

Rewrite the object body via MCP `updateObject`. Key principles:

**Voice rules (from samples):**
- Direct statements, not hedged ones ("This was stressful" not "This presented some challenges")
- Match your natural rhythm — fragments, dashes, whatever you actually use
- Observations should be sharp, not softened
- A concise 600-char section is better than a padded 950-char one

**Anti-patterns (kill these):**
- "Notably", "significantly", "demonstrates", "leveraged", "facilitated"
- "It's worth noting that..." — just note it
- Hedge stacking: "potentially", "arguably", "it could be said that"
- Empty transitions: "Moving forward", "In terms of"
- Passive voice where active is natural: "was identified" → "found"
- Bullet points that all start with the same word pattern

**Preserve untouched:**
- All object properties (do not change via this command)
- Code blocks, tables, checkboxes in the body
- External URLs

### 4. Summarize Changes

Present a brief summary:
- **Tone shift**: what changed overall
- **Key rewrites**: 2-3 examples of before/after
- **Preserved**: confirm what was left untouched

## Important

- This is NOT "remove AI words from a list." It's "make this sound like the same person who wrote the other objects."
- If the body is already well-written, say so and make minimal changes.
- Respect the context — a peer review needs to stay professional even after humanizing.
- If charcount matters (review content), verify limits after editing with `.claude/scripts/charcount.sh`.

Content to edit:
$ARGUMENTS
