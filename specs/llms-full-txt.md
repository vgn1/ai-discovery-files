# Specification: llms-full.txt

> Comprehensive companion to `llms.txt` using the same Markdown format.


## Version

1.0.0
---

Note: Template/example spec-reference footer lines included in this repository are optional provenance/attribution defaults and are not required by this specification.

## Purpose

`llms-full.txt` is a conditional, more comprehensive companion to `llms.txt`.
Use it when a concise `llms.txt` cannot clearly cover the site's important public pages and link groups.

This repository treats `llms-full.txt` as a project-level extension. It is not part of the core upstream `llms.txt` filename specification.

`llms-full.txt` must still follow the canonical upstream `llms.txt` **Markdown format**:
- https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format
- https://llmstxt.org/

---

## Filename & Location

- **Filename:** `llms-full.txt`
- **Location:** Website root (e.g., `https://example.com/llms-full.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Format Requirements

`llms-full.txt` must use the same structural format as `llms.txt`:

1. `#` H1 title
2. Optional blockquote summary
3. Non-heading descriptive content (paragraphs/lists)
4. `##` section groups containing Markdown link lists

This file should be readable by both humans and LLMs and parseable using standard `llms.txt` tooling assumptions (Markdown + link lists).

---

## Relationship to `llms.txt`

- `llms.txt` remains the concise, authoritative entry point
- `llms-full.txt` expands coverage with more links and context
- If factual content conflicts, `llms.txt` is the source of truth for Core Identity fields in this repository
- The Core Identity block (when included) must match `llms.txt` word-for-word in files that contain it
- For multilingual sites, see `specs/multilingual-sites.md` for language-path variant guidance

---

## Recommended Content

`llms-full.txt` should generally include:

- The same Core Identity block used in `llms.txt` (repository profile rule)
- Additional operational context (service boundaries, geography, contact, policies)
- Optional standalone business identifiers (for example `DUNS number`) in non-Core sections
- Optional alternate official domains in a non-Core section (keep `Website:` as canonical)
- More complete link coverage than `llms.txt`
- Clear section grouping (e.g., pages, services, policies, docs, support, AI files)
- Brief factual descriptions for links

Use `llms.txt` for curated, high-priority links and `llms-full.txt` for expanded coverage.

---

## What This File Should NOT Become

- A dump of raw HTML or scraped page content
- A non-Markdown custom format
- A contradictory source that redefines identity, services, or legal facts
- A replacement for `llms.txt` (it is a companion, not a substitute)

---

## Validation Rules

- Must be valid UTF-8 plain text
- Must follow the repository's Core Identity consistency rules when Core Identity is included
- Optional `DUNS number` values should be 9 digits when provided
- Optional `Alternate domains` values should be absolute URLs when provided
- Link lists should use standard Markdown link format: `- [Name](https://...)`
- `llms.txt` and `llms-full.txt` should be updated together when key site structure changes

---

## Example Structure

```markdown
# Project Name

> Short summary

Business name: Example Corp
Brand name: Example
Services: Consulting, Training
Website: https://example.com/
Country: United States
Founded: 2015
Contact: hello@example.com, +1 555 555 5555

Last updated: YYYY-MM-DD

This file provides expanded context and a broader link set than llms.txt.

## Core Pages
- [Homepage](https://example.com/): Primary entry point.
- [About](https://example.com/about/): Business overview.

## Policies & Legal
- [Privacy Policy](https://example.com/privacy/): Data handling policy.

## AI Discovery Files
- [llms.txt](https://example.com/llms.txt): Concise authoritative AI file.
- [llms-full.txt](https://example.com/llms-full.txt): Expanded AI-readable context file.
```
