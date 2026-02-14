# Specification: llms.html

> Human-readable HTML version of the business identity.

---

## Purpose

`llms.html` provides a styled, browser-friendly version of the authoritative identity defined in `llms.txt`. It allows humans to review the same information that AI systems consume from the plain-text files.

---

## Filename & Location

- **Filename:** `llms.html`
- **Location:** Website root (e.g., `https://example.com/llms.html`)
- **Encoding:** UTF-8
- **Content-Type:** `text/html; charset=utf-8`

---

## Required Content

The HTML page must contain the same information as `llms.txt`:

| Section | Required |
|---------|----------|
| Core Identity block | Yes |
| About | Yes |
| Services | Yes |
| Geographic Availability | Recommended |
| Business Details | Recommended |
| Contact | Yes |
| Key Pages | Recommended |

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
- Core Identity values must match `llms.txt` exactly
- Add or remove service sections as needed, but maintain the section wrapper structure
- All content must be factual and verifiable

---

## Relationship to Other Files

- `llms.txt` is the plain-text source of truth
- `llms.html` is the human-readable equivalent
- Content must not diverge from `llms.txt`
- The page should link back to `llms.txt` in the footer
