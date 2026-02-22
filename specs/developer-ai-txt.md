# Specification: developer-ai.txt

> Technical integration information for AI systems.


## Version

1.0.0
---

## Purpose

`developer-ai.txt` provides AI systems with technical context about a business's developer-facing interfaces — APIs, SDKs, webhooks, and integrations. It helps AI systems give accurate technical guidance when users ask about integrating with the business.

**Conditional:** Only create this file if the business offers APIs, SDKs, or developer integrations. If there are no public technical interfaces, this file is not needed.

---

## Filename & Location

- **Filename:** `developer-ai.txt`
- **Location:** Website root (e.g., `https://example.com/developer-ai.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Sections

### Core Identity

Must match `llms.txt` word-for-word. See [llms-txt.md](llms-txt.md) for field definitions.

### Developer Hub

Links to documentation, API reference, and developer portal.

### API Overview

| Field | Required |
|-------|----------|
| API style (REST, GraphQL, etc.) | Yes |
| Base URL | Yes |
| Current version | Yes |
| Data format | Yes |
| Authentication method | Yes |

---

## Recommended Sections

| Section | Purpose |
|---------|---------|
| Quick Start | Code sample showing the simplest integration path |
| SDKs & Libraries | Table of available packages by platform |
| Authentication & Access | How to obtain credentials, key types, rate limits |
| Webhooks | Availability, setup, signature verification, retry policy |
| Error Handling | Error response format and common status codes |
| Common Integration Scenarios | Typical use cases developers implement |
| Versioning & Deprecation | Version scheme, changelog URL, deprecation policy |
| Developer Support | Support channels with links |
| Legal & Compliance | API terms, developer agreement, privacy policy |

---

## Content Guidelines

- Link to actual, accessible documentation — not planned or coming-soon pages
- Keep technical details accurate and current
- Include code samples where helpful (use fenced code blocks)
- Rate limits should include specific numbers
- Authentication flows should be concrete, not vague

---

## Important Notes

- This file covers technical integrations only
- It must not contradict or redefine information in core identity files
- Update when API versions, capabilities, or access methods change

---

## Relationship to Other Files

- `llms.txt` provides the business identity — `developer-ai.txt` provides technical details
- `faq-ai.txt` may cover basic "how to integrate" questions
- This file goes deeper into technical specifics
