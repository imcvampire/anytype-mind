# Defuddle

Extract clean markdown content from web pages using Defuddle CLI. Removes navigation, ads, and clutter to save tokens. Use instead of raw web fetch for standard web pages.

Install: `npm install -g defuddle-cli`

## Usage

```bash
defuddle parse <url> --md
```

Save to file:
```bash
defuddle parse <url> --md -o content.md
```

Extract specific metadata:
```bash
defuddle parse <url> -p title
defuddle parse <url> -p description
defuddle parse <url> -p domain
```

## Output Formats

| Flag | Format |
|------|--------|
| `--md` | Markdown (preferred) |
| `--json` | JSON with both HTML and markdown |
| (none) | HTML |
| `-p <name>` | Specific metadata property |
