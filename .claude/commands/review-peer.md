# Peer Review Writer

Write a peer review for a colleague. Produces project feedback, principles, and performance summary — all within character limits, fact-checked against Anytype evidence.

## Usage

```
/review-peer <Name>
```

## Workflow

### 1. Gather Evidence

Search Anytype via MCP for:
1. Person object for <Name> — background and context
2. pr_analysis objects with `related_person` matching this person
3. work_note and incident objects mentioning this person (via `searchSpace`)
4. one_on_one objects involving this person
5. Any brag sheet or impact overview the person shared (user provides)

### 2. Assess Visibility

For each submitted project, classify evidence level:
- **Direct**: Worked together daily, first-hand observations
- **Reviewed**: Saw their PRs, reviewed some code
- **Informed**: From their brag sheet, limited personal observation

Be explicit about this in the review text.

### 3. Draft

For each section, draft within character limits. Use `.claude/scripts/charcount.sh` to verify.

**Project feedback**: Lead with your relationship to the work. Describe behaviors and decisions.

**Principles**: Lead with first-hand evidence. Each principle should have distinct evidence.

**Strengths**: Synthesize the defining theme across all projects.

**Areas of Development**: Must be genuinely distinct per person. Frame constructively.

**Confidential Comment**: Something the manager specifically needs to know.

### 4. Quality Checks

- [ ] All sections within character limits
- [ ] No PR numbers — describe what was done instead
- [ ] No line counts
- [ ] Honest about visibility level per project
- [ ] No repetition across sections
- [ ] Areas of Development is specific to THIS person
- [ ] Tone sounds like a colleague

### 5. Fact-Check

Search Anytype for every factual claim:
- Dates, timelines, sequences
- Specific contributions attributed to the person
- Claims about "first," "only," or "every"

### 6. Save

Create a thinking_note object with the draft for copy-pasting.
After submission, promote to a proper review object.

## Tone Rules

- Write like a colleague talking about someone they work with
- Specific enough to be credible, casual enough to be human
- No emojis, no corporate buzzwords
- It's OK for sections to be shorter if that's all you need to say
