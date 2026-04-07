# Anytype Mind

> **A knowledge base that makes AI remember everything.** Built on Anytype, works with Claude Code, Codex, and Cursor.

[![Anytype](https://img.shields.io/badge/anytype-required-blue)](https://anytype.io)
[![MCP](https://img.shields.io/badge/anytype%20mcp-2025--11--08-green)](https://developers.anytype.io/docs/examples/featured/mcp)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This repo is heavily inspired by <https://github.com/breferrari/obsidian-mind>.

---

## The Problem

AI assistants forget. Every session starts from zero -- no context on your goals, team, patterns, or wins. Knowledge never compounds.

## The Solution

Give the AI a structured brain in Anytype. Start a session, talk about your day, and the AI handles the rest -- typed objects, relations, performance tracking. Every conversation builds on the last.

---

## Quick Start

### 1. Set Up Anytype

1. Install and open [Anytype](https://anytype.io)
2. Create an API key: Settings > API Keys > Create new

### 2. Bootstrap the Space

```bash
ANYTYPE_API_KEY="your-key" bash setup/bootstrap.sh
```

This creates all types, properties, tags, and collections in your Anytype space.

### 3. Configure Your AI Tool

**Claude Code:**

```bash
cp SKILL.md CLAUDE.md
claude mcp add anytype -e OPENAPI_MCP_HEADERS='{"Authorization":"Bearer <KEY>", "Anytype-Version":"2025-11-08"}' -s user -- npx -y @anyproto/anytype-mcp
```

**Codex:**

```bash
cp SKILL.md AGENTS.md
# Add Anytype MCP to Codex settings (see setup/anytype-mcp-config.json)
```

**Cursor:**
Add to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "anytype": {
      "command": "npx",
      "args": ["-y", "@anyproto/anytype-mcp"],
      "env": {
        "OPENAPI_MCP_HEADERS": "{\"Authorization\":\"Bearer <KEY>\", \"Anytype-Version\":\"2025-11-08\"}"
      }
    }
  }
}
```

### 4. Start Using

```
/standup          # Morning kickoff
/dump <anything>  # Capture freeform info
wrap up           # End of session review
```

---

## Requirements

- [Anytype](https://anytype.io) desktop app (must be running for API access)
- One of: [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://openai.com/codex), or [Cursor](https://cursor.com)
- Python 3 (for hook scripts)
- Node.js / npx (for Anytype MCP server)

---

## How It Works

All data lives as **typed Anytype objects** with properties and relations. AI agents interact via the **Anytype MCP server**, which exposes the Anytype API as MCP tools.

**12 object types** map your work: work notes, incidents, 1:1s, decisions, people, teams, competencies, PR analyses, review briefs, brain notes, brag entries, and thinking notes.

**Relations** connect everything: work notes link to people, teams, and competencies. When review season arrives, the relations on each competency are already the evidence trail.

**5 lifecycle hooks** handle routing automatically:

| Hook | What It Does |
|------|-------------|
| SessionStart | Loads North Star, active work, recent changes via Anytype MCP |
| UserPromptSubmit | Classifies content (decision, incident, win, 1:1) and injects routing hints |
| PostToolUse | Validates object properties and relations after MCP calls |
| PreCompact | Backs up session transcript |
| Stop | End-of-session checklist |

---

## Commands

14 slash commands in `.claude/commands/`:

| Command | Purpose |
|---------|---------|
| `/standup` | Morning kickoff -- loads context, suggests priorities |
| `/dump` | Freeform capture -- routes everything to the right objects |
| `/wrap-up` | Session review -- verify objects, relations, spot wins |
| `/humanize` | Voice-calibrated editing |
| `/weekly` | Weekly synthesis -- patterns, North Star alignment |
| `/capture-1on1` | Capture 1:1 transcript into structured object |
| `/incident-capture` | Capture incident from Slack into objects |
| `/slack-scan` | Deep scan Slack for evidence |
| `/peer-scan` | Deep scan GitHub PRs for review prep |
| `/review-brief` | Generate review brief |
| `/self-review` | Write self-assessment |
| `/review-peer` | Write peer review |
| `/vault-audit` | Audit object integrity and relations |
| `/project-archive` | Mark project as completed |

---

## Subagents

8 specialized agents in `.claude/agents/`:

| Agent | Purpose |
|-------|---------|
| `brag-spotter` | Finds uncaptured wins |
| `context-loader` | Loads all context about a topic |
| `cross-linker` | Finds objects missing relations |
| `people-profiler` | Creates person objects from Slack |
| `review-prep` | Aggregates review evidence |
| `slack-archaeologist` | Full Slack reconstruction |
| `vault-librarian` | Object integrity maintenance |
| `review-fact-checker` | Verifies review claims |

---

## Project Structure

```
SKILL.md              # Master instructions (copy to CLAUDE.md or AGENTS.md)
README.md             # This file
vault-manifest.json   # Type/property schema
references/           # Shared reference docs
  anytype-mcp.md      # MCP tool reference
  type-schema.md      # Full type/property definitions
  markdown-conventions.md
  collection-views.md
  defuddle.md
setup/                # One-time setup
  bootstrap.sh        # Creates Anytype space schema
  anytype-mcp-config.json
.claude/              # Claude Code / Cursor integration
  settings.json       # Hooks configuration
  commands/           # 14 slash commands
  agents/             # 8 subagents
  scripts/            # Hook scripts
```

---

## License

MIT
