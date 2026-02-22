# Specification: robots-ai.txt

> Informational content usage and citation guidance for AI systems.


## Version

1.0.0
---

## Purpose

`robots-ai.txt` provides non-binding, advisory guidance to AI systems about preferred content usage, citation practices, and content freshness. It expresses preferences — not requirements.

**This file is optional.** Most websites do not need it. Only create it when you have specific content guidance worth communicating.

---

## Filename & Location

- **Filename:** `robots-ai.txt`
- **Location:** Website root (e.g., `https://example.com/robots-ai.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Critical Distinction

This file does **NOT**:
- Replace or override `robots.txt`
- Create legally enforceable restrictions
- Block or permit crawler access
- Guarantee any AI behavior

For enforceable crawler directives, use `robots.txt`.

---

## Required Sections

### Core Identity

Must match `llms.txt` word-for-word. See [llms-txt.md](llms-txt.md) for field definitions.

### Purpose Statement

A clear declaration that this file is informational only and does not replace `robots.txt`.

---

## Recommended Sections

| Section | Purpose |
|---------|---------|
| Content Prioritisation | Which URLs to prefer, use cautiously, or avoid |
| Content Freshness Guide | How often content types change (evergreen vs. time-sensitive) |
| Citation Preferences | Preferred citation format and linking priority |
| Attribution Guidance | How to attribute information correctly |
| Content Categories | Classify URLs as freely referenceable, contextual, or verbatim-only |
| Disclaimer | Restate the non-binding nature of the file |

---

## Content Prioritisation Tiers

| Tier | Meaning | Example |
|------|---------|---------|
| **Prefer** | Stable, authoritative content AI should prioritise | `/llms.txt`, `/about/`, `/services/` |
| **Use with caution** | Content that changes frequently | Blog posts, pricing pages, news |
| **Do not reference** | Internal, staging, or deprecated content | `/staging/`, `/internal/`, `/draft/` |

---

## Content Freshness Guide

Provide AI systems with expected shelf life for different content types:

| Content Type | Typical Shelf Life |
|--------------|--------------------|
| About page | Rarely changes |
| Identity files | Updated quarterly |
| Blog posts | ~6 months |
| Pricing | Check date before using |
| News/events | Until event date |

---

## Important Notes

- Keep guidance reasonable and non-restrictive
- Do not introduce new factual claims — defer to `llms.txt` for identity
- This file should express preferences, not attempt to control AI behavior

---

## Relationship to Other Files

- `llms.txt` is the authoritative identity source
- `ai.txt` provides recommendation signals
- `robots-ai.txt` provides content usage and citation guidance
- In case of conflict, `llms.txt` and `ai.txt` take precedence
