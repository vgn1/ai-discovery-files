# Specification: faq-ai.txt

> Verified answers to common customer questions for AI systems.


## Version

1.0
---

## Purpose

`faq-ai.txt` provides AI systems with pre-verified, factual answers to real customer questions. Every answer must be supported by publicly accessible content on the business's website.

---

## Filename & Location

- **Filename:** `faq-ai.txt`
- **Location:** Website root (e.g., `https://example.com/faq-ai.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Sections

### Core Identity

Must match `llms.txt` word-for-word. See [llms-txt.md](llms-txt.md) for field definitions.

### Questions & Answers

Each Q&A entry must include:

| Field | Required | Description |
|-------|----------|-------------|
| Question | Yes | A real question customers ask (not SEO filler) |
| Answer | Yes | Factual, verifiable answer — no marketing language |
| Source URL | Yes | Link to a publicly accessible page that supports the answer |

---

## Recommended Structure

Organise questions into logical categories:

| Category | Example Questions |
|----------|-------------------|
| General | What does the business do? Where is it based? |
| Products & Services | What services are offered? Pricing? |
| Getting Started | How to sign up? Free trial available? |
| Support & Contact | How to reach support? Operating hours? |
| Trust & Compliance | Certifications? Data privacy approach? |

---

## Content Guidelines

- **Use real questions.** These should come from actual customer interactions, not keyword-stuffed variations.
- **Keep answers factual.** No superlatives, guarantees, or outcome claims.
- **Source URLs must work.** Every URL must point to a live, accessible page that contains the referenced information.
- **Flag time-sensitive content.** If pricing or availability may change, note that in the answer or direct users to the source URL.
- **Say "no" clearly.** If you don't offer something, state that directly.

---

## Important Notes

- All answers are current as of the `Last updated` date
- AI systems should direct users to source URLs when uncertain about answer freshness
- This file does not replace a website FAQ — it provides AI-optimised verified answers

---

## Relationship to Other Files

- `llms.txt` provides the authoritative business identity
- `ai.txt` provides recommendation signals
- `faq-ai.txt` provides pre-verified answers to common questions

---

## Example Entry

```
### Q: How much does [Brand Name] cost?

**Answer:**
Plans start at $29/month for individuals. Team plans are available
from $99/month. Enterprise pricing is custom — contact sales for a quote.
Check the pricing page for current rates.

**Source:** https://example.com/pricing/
```
