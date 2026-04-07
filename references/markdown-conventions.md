# Markdown Conventions for Anytype Objects

Anytype objects support markdown in their `body` field. This document covers conventions for writing object bodies.

## Key Principles

- **Metadata** goes in object properties (set via API), not in the body.
- **Internal links** are object relations (set via `object`-format properties). Reference other objects by name in body text.
- **Tags** use the `vault_tags` multi_select property, not inline `#tags`.
- **Callouts** use standard blockquotes (`>`).

## Body Structure

### Standard Sections by Type

**Work Note body:**
```markdown
# Context

What this project is about and why it matters.

# Notes

Key observations, progress, decisions made.

# Action Items

- [ ] Pending task
- [x] Completed task

# Related

Links to related objects mentioned by name.
```

**Incident body:**
```markdown
# Context

What happened and what triggered it.

# Root Cause

Technical explanation of the failure.

# Timeline

| Time | Event |
|------|-------|
| 14:00 | Alert fired |
| 14:15 | Investigation started |

# Impact

Users affected, business impact.

# Resolution

What was fixed and how.

# Analysis

Strategic significance, patterns, lessons learned.
```

**1:1 Note body:**
```markdown
# Key Takeaways

Bullet points of the most important things discussed.

# Decisions Made

Anything agreed upon.

# Action Items

- [ ] Task with owner

# Quotes Worth Noting

> Direct quotes that reveal priorities or feedback.

# What to Watch

Things to monitor, concerns, ambiguous signals.
```

**Decision Record body:**
```markdown
# Context

What prompted this decision.

# Options Considered

1. **Option A** -- description, pros, cons
2. **Option B** -- description, pros, cons

# Decision

What was chosen and why.

# Consequences

Expected outcomes and trade-offs.
```

**Brain Note body:**
```markdown
# Topic Name

Content organized by subtopic. Each brain note covers one concept.

## Subtopic

Details, examples, links to evidence objects by name.
```

**Person body:**
```markdown
# Role & Team

Current role, team, reporting chain.

# Relationship

How you work together, communication style.

# Key Moments

Significant interactions, decisions, feedback.

# Notes

Ongoing observations, context for reviews.
```

## Formatting

Standard markdown works in Anytype bodies:

- **Headings**: `#`, `##`, `###`
- **Bold/Italic**: `**bold**`, `*italic*`
- **Lists**: `-` unordered, `1.` ordered
- **Checkboxes**: `- [ ]`, `- [x]`
- **Code**: `` `inline` ``, ` ``` ` fenced blocks
- **Tables**: pipe-delimited
- **Blockquotes**: `>`
- **Links**: `[text](url)` for external URLs
- **Horizontal rules**: `---`
- **Math**: `$inline$`, `$$block$$` (if supported by Anytype)

## Referencing Other Objects

Reference other objects by name in the body text. The formal relationship is created via object properties (the `object` format), not via special link syntax in the body.

Example:
```
See Alice Chen for details on Project Alpha.
```

Then set `related_person` and other object-type properties to create the formal relations.

## What NOT to Put in Body

- **Metadata**: Use object properties, not inline YAML or tags
- **Status tracking**: Use the `status` property
- **Dates**: Use date properties
- **Categories**: Use `vault_tags` multi_select property
- **Relations to other objects**: Use object-format properties

The body is for human-readable content only. All structured data goes in properties.
