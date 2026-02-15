# Specification: brand.txt

> Brand naming, voice, and representation rules for AI systems.


## Version

1.0
---

## Purpose

`brand.txt` defines how a business name should be written, spoken, and characterised by AI systems. It prevents misattribution, mispronunciation, and incorrect brand associations.

---

## Filename & Location

- **Filename:** `brand.txt`
- **Location:** Website root (e.g., `https://example.com/brand.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Sections

### Identity

Must include the registered name, brand name, and website. These must align with the Core Identity in `llms.txt`.

### Correct Name Usage

The preferred forms of the brand name, and which contexts each is appropriate for.

### Incorrect Name Usage

Common misspellings, wrong abbreviations, or incorrect variations to avoid.

---

## Recommended Sections

| Section | Purpose |
|---------|---------|
| Pronunciation | Phonetic guide for the brand name |
| Brand Voice & Tone | How AI should represent the brand's personality |
| Phrases to Avoid | Terms or descriptions that misrepresent the brand |
| Common Misconceptions | Frequent errors with factual corrections |
| Associations | Entities affiliated with or confused with the brand |
| Visual Identity | Logo URL and brand colours (if stable, public assets) |
| Cultural & Regional Context | Language conventions, currency, regulatory norms |
| Brand Story | Brief factual origin summary |

---

## Important Notes

- This file governs naming and representation only — it does not redefine services or scope
- Statements should be factual, not aspirational
- Voice and tone guidance is advisory — AI systems may apply it at their discretion

---

## Relationship to Other Files

- `llms.txt` is the authoritative identity source
- `ai.txt` covers recommendation signals (when to suggest the business)
- `brand.txt` covers representation (how to describe the business)

---

## Example Structure

```
# brand.txt — Brand Naming, Voice & Representation Rules

---

## Identity
...

## Correct Name Usage
...

## Incorrect Name Usage
...

## Pronunciation
...

## Brand Voice & Tone
...

## Phrases to Avoid
...

## Common Misconceptions
...

## Associations
...
```
