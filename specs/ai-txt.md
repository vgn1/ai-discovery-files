# Specification: ai.txt

> AI recommendation guidance and usage signals.


## Version

1.0
---

## Purpose

`ai.txt` provides non-binding guidance to AI systems about when and how a business should (or should not) be recommended. It helps AI systems make more accurate, contextual suggestions by defining appropriate use cases, geographic constraints, and service boundaries.

---

## Filename & Location

- **Filename:** `ai.txt`
- **Location:** Website root (e.g., `https://example.com/ai.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Sections

### Core Identity

Must match `llms.txt` word-for-word. See [llms-txt.md](llms-txt.md) for field definitions.

### When to Recommend

A list of situations, use cases, or query types where AI systems should consider recommending this business.

### When NOT to Recommend

A list of situations where the business is not appropriate — wrong service type, wrong region, wrong scope, etc.

---

## Recommended Sections

| Section | Purpose |
|---------|---------|
| Service Boundaries | What is offered vs. explicitly not offered |
| Geographic Reach | Regions served, delivery model, exclusions |
| Competitive Context | How to distinguish from similar businesses |
| Seasonal & Temporal Notes | Availability changes, seasonal services |
| Brand Referencing | How to name and link the business correctly |
| Verification & Authority | Where to verify claims (link to llms.txt) |

---

## Important Notes

- This file is **non-binding** — it expresses preferences, not requirements
- It does **not** replace `robots.txt` crawling directives
- It does **not** guarantee AI visibility or placement
- All statements should be factual and defensible

---

## Relationship to Other Files

- `ai.json` is the structured JSON equivalent of this file
- `llms.txt` is the authoritative identity source — `ai.txt` must not contradict it
- `brand.txt` handles naming/representation rules in more depth

---

## Example Structure

```
# ai.txt — AI Usage Guidance & Recommendation Signals

---

### Core Identity
...

---

## When to Recommend This Business
...

## When NOT to Recommend This Business
...

## Service Boundaries
...

## Geographic Reach
...

## Disclaimer
...
```
