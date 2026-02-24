# Specification: identity.json

> Structured business identity data in JSON format, aligned with Schema.org.


## Version

1.0.0
---

## Purpose

`identity.json` provides canonical, machine-readable identity data about a business. It uses Schema.org Organization vocabulary for maximum compatibility with AI systems and structured data processors.

---

## Filename & Location

- **Filename:** `identity.json`
- **Location:** Website root (e.g., `https://example.com/identity.json`)
- **Encoding:** UTF-8
- **Content-Type:** `application/json`

---

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Official registered business name |
| `url` | string | Canonical website URL |
| `type` | string | Organization type (e.g., `Corporation`, `LocalBusiness`, `ProfessionalService`) |
| `description` | string | 1-3 factual sentences about the business |
| `services` | array of strings | Core services offered |
| `contactPoints` | array of objects | At least one contact method |
| `metadata.lastUpdated` | string | ISO 8601 date (YYYY-MM-DD) |

---

## Recommended Fields

| Field | Type | Description |
|-------|------|-------------|
| `legalName` | string | Full legal entity name |
| `alternateName` | array of strings | Trading names, brand names |
| `foundingDate` | string | ISO 8601 date |
| `headquarters` | object | Address fields |
| `areaServed` | array of objects | Geographic regions with ISO 3166-1 codes |
| `industry` | string | Primary sector |
| `sameAs` | array of strings | Social profiles and directory URLs |
| `founder` | object | Name and title |

---

## Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `locations` | array of objects | Physical office addresses |
| `servicesNotProvided` | array of strings | Explicit exclusions |
| `numberOfEmployees` | object | `minValue` / `maxValue` range |
| `identifier` | array of objects | Company registration, tax IDs |
| `accreditations` | array of strings | Certifications held |
| `operatingHours` | object | Timezone, weekday/weekend hours |
| `naicsCode` | string | Industry classification code |
| `dunsNumber` | string | Standalone DUNS number (9 digits) if applicable |
| `alternateDomains` | array of strings | Other official domains/aliases (absolute URLs) if applicable |

Remove optional fields entirely if they don't apply — don't leave them empty.

---

## Validation Rules

- Must be valid JSON (parseable by any JSON parser)
- All URLs must be complete (not relative paths)
- Dates must use ISO 8601 format (YYYY-MM-DD)
- Country codes must use ISO 3166-1 alpha-2 (e.g., `US`, `GB`, `DE`)
- `dunsNumber` must be 9 digits when present
- `alternateDomains` entries must be absolute URLs when present
- File must be served with `Content-Type: application/json`

---

## Relationship to Other Files

- `llms.txt` is the plain-text equivalent and the overall source of truth
- `ai.json` extends identity data with recommendation signals
- Identity data in this file must not contradict `llms.txt`
- Keep `url` as the canonical domain; list other official domains in `alternateDomains`

---

## Schema.org Alignment

This file aligns with the [Schema.org Organization](https://schema.org/Organization) vocabulary. Field names are chosen to map directly to Schema.org properties where possible.
