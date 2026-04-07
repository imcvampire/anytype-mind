# Peer PR Deep Scan

Deep scan a peer's GitHub PRs for performance review preparation. Produces a structured pr_analysis object in Anytype.

## Usage

```
/peer-scan <name> <github-username> <repo> [period]
```

Example: `/peer-scan "Jane Doe" jdoe example-repo "Jan 2025 - Jun 2025"`

## Workflow

1. **Fetch full PR list** (limit 200):
   ```
   gh pr list --repo <org>/<repo> --author <username> --state all --limit 200 --json number,title,state,createdAt,mergedAt,additions,deletions
   ```

2. **Filter to review period** (default: last 6 months). For EACH PR in period, fetch details:
   ```
   gh pr view <number> --repo <org>/<repo> --json body,reviews,comments,additions,deletions,changedFiles,title,state,createdAt,mergedAt
   ```

3. **Produce structured analysis** with sections:
   - PR count by month (velocity trends)
   - Projects/themes (group PRs by area)
   - Quality signals (review comments, change requests, reverts)
   - Notable contributions (architectural decisions, complex fixes)
   - Growth signals (scope expansion, leadership evidence)
   - Full PR table

4. **Create pr_analysis object** via MCP `createObject`:
   - `type_key`: "pr_analysis"
   - `name`: "<Name> PRs - <Period>"
   - `description`: one-line summary of findings
   - Properties: `related_person` (link to person object), `review_cycle`, `vault_tags: [perf, evidence]`
   - Body: the structured analysis

5. **Link to person object** — search for and update the person's object with a reference to this analysis.

## Important

- Be thorough — this feeds into performance reviews
- Note PRs that were reverted or closed (quality signal)
- Look for patterns in reviewer feedback
- Identify cross-team PRs (collaboration evidence)
- Map PRs to projects you have context on
