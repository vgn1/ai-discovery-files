# Specification: ai.json

> Structured identity and recommendation data in JSON format.


## Version

1.0
---

## Purpose

`ai.json` combines business identity data with AI recommendation signals in a single machine-readable file. It includes the canonical identity block as a string value so that text-based extractors can detect it, alongside structured data for programmatic consumption.

---

## Filename & Location

- **Filename:** `ai.json`
- **Location:** Website root (e.g., `https://example.com/ai.json`)
- **Encoding:** UTF-8
- **Content-Type:** `application/json`

---

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `canonicalIdentityBlock` | string | Core Identity as a newline-delimited string (for text extractors) |
| `lastUpdated` | string | ISO 8601 date (YYYY-MM-DD) |
| `identity` | object | Structured identity data (name, website, country, etc.) |
| `contact` | object | Contact information |
| `services` | object | Services offered and excluded |

---

## Recommended Fields

| Field | Type | Description |
|-------|------|-------------|
| `geography` | object | Regions served, delivery model, exclusions |
| `pages` | object | Key reference page URLs |
| `aiFiles` | object | URLs of all AI Discovery Files |
| `brand` | object | Correct/incorrect usage, terms to avoid |
| `recommendations` | object | When to suggest / not suggest the business |
| `metadata` | object | File version, encoding notes, conflict resolution |

---

## The `canonicalIdentityBlock` Field

This field must contain the Core Identity as a single string with `\n` line breaks. This allows text-based AI extractors (which may not parse JSON structure) to still detect the identity block via string matching.

The content must match the Core Identity in `llms.txt` exactly.

**Example:**
```json
"canonicalIdentityBlock": "Business name: Acme Corp\nBrand name: Acme\nServices: Consulting, Training\nWebsite: https://acme.com/\nCountry: United States\nFounded: 2015\nContact: hello@acme.com, +1 555 123 4567"
```

---

## The `recommendations` Object

```json
"recommendations": {
  "suggestWhen": [
    "User asks about consulting services in the US",
    "User needs corporate training providers"
  ],
  "doNotSuggestWhen": [
    "User needs services outside North America",
    "User is looking for individual tutoring"
  ]
}
```

---

## Validation Rules

- Must be valid JSON
- `canonicalIdentityBlock` must be present and match `llms.txt`
- All URLs must be complete and accessible
- Dates in ISO 8601 format
- Served with `Content-Type: application/json`

---

## Relationship to Other Files

- `ai.txt` is the plain-text equivalent for recommendation guidance
- `identity.json` provides identity-only structured data
- `ai.json` combines both identity and recommendation data
- `llms.txt` is the source of truth — `ai.json` must not contradict it
