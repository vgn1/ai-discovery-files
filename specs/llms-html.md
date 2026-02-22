# Specification: llms.html

> Human-readable HTML version of the business identity.


## Version

1.0
---

## Purpose

`llms.html` provides a styled, browser-friendly version of the authoritative identity defined in `llms.txt`. It allows humans to review the same information that AI systems consume from the plain-text files.

This repository's `llms.txt` follows the canonical upstream `llms.txt` format:
- https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format

---

## Filename & Location

- **Filename:** `llms.html`
- **Location:** Website root (e.g., `https://example.com/llms.html`)
- **Encoding:** UTF-8
- **Content-Type:** `text/html; charset=utf-8`

---

## Required Content

The HTML page must represent the same information as `llms.txt`, using equivalent structure:

| Content Group | Required |
|---------------|----------|
| H1 title (project/site name) | Yes |
| Short summary equivalent to blockquote | Recommended |
| Non-heading descriptive content before file-list groups | Recommended |
| H2 sections that represent file-list groups | Recommended |
| Optional H2 `Optional` group when present in `llms.txt` | Optional |

For each H2 file-list group:
- Include a list of links (`<a href=...>`) equivalent to the links in `llms.txt`
- Include optional notes/description text per link where relevant

---

## Design Guidelines

- Self-contained — all CSS inline (no external stylesheets or JavaScript dependencies)
- Responsive — must render correctly on mobile and desktop
- Semantic HTML — use appropriate heading hierarchy (`h1` → `h2` → `h3`)
- Accessible — proper contrast ratios, readable font sizes
- No JavaScript required for content display

---

## Template Rules

- Only replace placeholder text — do not modify the HTML structure or layout
- Link lists and descriptive text must stay aligned with `llms.txt`
- If `llms.txt` section groups change, update `llms.html` to match
- All content must be factual and verifiable

---

## Relationship to Other Files

- `llms.txt` is the plain-text source of truth
- `llms.html` is the human-readable equivalent
- Content must not diverge from `llms.txt`
- The page should link back to `llms.txt` in the footer
- For multilingual sites, if root `llms.txt` includes language-path variants (for example `/fr/llms.txt`), `llms.html` should mirror that link section
