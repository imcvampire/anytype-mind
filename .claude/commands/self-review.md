# Self-Review Writer

Write your self-assessment for your company's review tool. Produces project impact descriptions, competency self-assessments, principles, and growth plan — all within character limits, fact-checked, strategically calibrated.

## Usage

```
/self-review [cycle]
```

Default cycle: current review period.

## Context: Review System

Adapt to your company's review system. Common patterns:
- **Evaluation axes**: Impact, Competencies, Principles
- **Rating scale**: Below/Meet/Above or 1-5
- **Your self-assessment sets the anchor** — especially when the manager is new

## Workflow

### 1. Load Context

Search Anytype via MCP for:
1. "North Star" brain_note — current goals
2. review_brief objects for this cycle
3. Previous cycle review objects — baselines
4. brag_entry objects covering the period
5. competency objects — all definitions
6. work_note objects for submitted projects

### 2. Draft Projects

For each submitted project (within character limits):
- Open with your role and scope
- Cover impact dimensions: delivery, quality, complexity
- Include specific evidence: numbers should be factual
- End with outcome or significance

### 3. Draft Competencies

For each competency, decide current level (Yes/No) and next level (Yes/No):
- Read criteria from the competency object
- Check each sub-criterion: is there concrete evidence?
- Draft text: lead with behaviors and decisions, not deliverables
- Reference previous cycle baseline

### 4. Draft Principles

For each principle:
- Reference previous cycle baseline
- Lead with strongest evidence
- Make growth explicit if rating changed

### 5. Strategic Calibration

Review the full picture before finalizing:
- Are ratings defensible?
- Are next-level claims backed by evidence?
- Will the manager have enough context to defend in calibration?

### 6. Quality Checks

- [ ] All sections within character limits (use `.claude/scripts/charcount.sh`)
- [ ] Every factual claim backed by Anytype evidence
- [ ] No fabricated decisions
- [ ] Dates verified
- [ ] Growth baselines stated

### 7. Fact-Check Pass

For every claim:
- Search Anytype for the source object
- Is it first-hand or inferred?
- Could a reviewer challenge it?

### 8. Save

Create a thinking_note object with the draft for copy-pasting.
After submission, create a proper review object in Anytype.

## Tips

1. Your self-assessment anchors the conversation — especially with a new manager.
2. Check character counts early and often.
3. Watch special characters — some review tools count em-dashes as multiple characters.
4. Fact-check before submitting.
