# Specification: llms.txt

> Primary AI-readable business identity file.

---

## Purpose

`llms.txt` is the authoritative identity file for AI systems. It provides factual, verifiable information about a business — who they are, what they do, where they operate, and how to contact them.

All other AI Discovery Files defer to `llms.txt` in case of conflict.

---

## Filename & Location

- **Filename:** `llms.txt`
- **Location:** Website root (e.g., `https://example.com/llms.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Sections

### Core Identity

The Core Identity block must appear near the top of the file. It contains:

| Field | Format | Required |
|-------|--------|----------|
| Business name | Plain text | Yes |
| Brand name | Plain text | Yes |
| Services | Comma-separated list | Yes |
| Website | Full URL | Yes |
| Country | Plain text | Yes |
| Founded | Year (YYYY) | Yes |
| Contact | Email and/or phone | Yes |
| Last updated | Date (YYYY-MM-DD) | Yes |

**Consistency rule:** The Core Identity block must be word-for-word identical in every AI Discovery File that contains it.

### About

2-3 paragraphs of factual description. No marketing language or unverifiable claims.

### Services

Each core service listed with a brief factual description.

---

## Recommended Sections

| Section | Purpose |
|---------|---------|
| What We Do Not Offer | Prevents AI misassociation with services not provided |
| Geographic Availability | Regions served, delivery model, exclusions |
| Business Details | Legal name, registration, tax ID, address |
| Contact | Structured contact information |
| Key Pages | Links to important website pages |
| Document History | Changelog of updates to this file |

---

## Formatting Rules

- Use Markdown-style headers (`#`, `##`, `###`)
- Separate sections with `---` dividers
- Keep content factual — avoid superlatives, marketing language, or aspirational statements
- Use consistent formatting for lists (bullets or numbered)

---

## Relationship to Other Files

- `llm.txt` redirects to this file for compatibility
- `llms.html` is the human-readable HTML equivalent
- `identity.json` is the structured JSON equivalent
- All other `.txt` AI Discovery Files reference the Core Identity from this file

---

## Example Structure

```
# llms.txt — Authoritative AI-Readable Business Identity

---

### Core Identity

Business name: ...
Brand name: ...
Services: ...
Website: ...
Country: ...
Founded: ...
Contact: ...

Last updated: ...

---

## About
...

## Services
...

## What We Do Not Offer
...

## Geographic Availability
...

## Business Details
...

## Contact
...

## Key Pages
...
```
