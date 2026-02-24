# Specification: Multilingual Sites (Repository Profile)

> Repository guidance for publishing AI Discovery Files on multilingual websites.


## Version

1.0.0
---

## Purpose

This document defines how this repository recommends handling multilingual websites.

The upstream `llms.txt` format specifies the Markdown structure of a file and notes that `llms.txt` may exist at the root path (and optionally in a subpath), but it does not define a standard multilingual discovery pattern for language variants.

This repository therefore defines a project-level profile for multilingual sites.

---

## Core Rule (Multilingual Sites)

For multilingual sites, publish:

1. A primary `llms.txt` at the site root (for the default / primary language)
2. Additional language-specific `llms.txt` files at language paths (for example `/fr/llms.txt`, `/sv/llms.txt`)
3. Links from the root `llms.txt` to each language-specific `llms.txt`

Example:
- `https://www.yourdomain.com/llms.txt` (primary/default language)
- `https://www.yourdomain.com/fr/llms.txt` (French)
- `https://www.yourdomain.com/sv/llms.txt` (Swedish)

---

## Root `llms.txt` Requirements (Multilingual)

The root `llms.txt` should remain concise and authoritative for the primary language.

If multilingual variants exist, the root file should include a dedicated section linking to them.
Recommended heading: `## Language-Specific llms.txt Files`

### Root Linking Rule

In multilingual setups, the root `llms.txt` should link to language-specific `llms.txt` variants only (for example `/fr/llms.txt`, `/sv/llms.txt`) in the language-variants section.

Do not link localized non-`llms.txt` AI Discovery files (for example `/fr/faq-ai.txt`, `/fr/ai.txt`) directly from the root `llms.txt` language-variants section.
Those localized AI Discovery files should be linked from their corresponding language-path `llms.txt`.

For example:

```markdown
## Language-Specific llms.txt Files

- [French llms.txt](https://www.yourdomain.com/fr/llms.txt): French-language AI discovery file.
- [Swedish llms.txt](https://www.yourdomain.com/sv/llms.txt): Swedish-language AI discovery file.
```

Use normal `llms.txt` Markdown link-list format (H2 section + list items with links and brief descriptions).

---

## Language-Path `llms.txt` Requirements

Each language-path `llms.txt` should:

- Follow the same upstream `llms.txt` Markdown format
- Be written in the target language (recommended for user-facing descriptions and link notes)
- Link to pages in the same language path when those localized pages exist
- Include a link back to the root `llms.txt` (recommended)
- Keep factual content aligned with the primary language file

If the site uses translated AI Discovery Files beyond `llms.txt` (such as `/fr/faq-ai.txt`), link them from the language-path `llms.txt` in the relevant sections.

This creates a hub pattern where:
- root `llms.txt` links to language-specific `llms.txt` files
- each language-specific `llms.txt` links to AI Discovery files and pages for that language

---

## Multilingual Link Topology (Illustrative)

```text
/llms.txt                        (primary language, e.g. English)
├── links to /fr/llms.txt
├── links to /sv/llms.txt
└── does not directly link to /fr/faq-ai.txt or /sv/ai.txt in the language-variants section

/fr/llms.txt                     (French language hub)
├── links to /fr/ai.txt          (if published)
├── links to /fr/faq-ai.txt      (if published)
├── links to /fr/identity.json   (if published)
└── links to /llms.txt           (recommended back-link)

/sv/llms.txt                     (Swedish language hub)
├── links to /sv/ai.txt          (if published)
├── links to /sv/faq-ai.txt      (if published)
├── links to /sv/identity.json   (if published)
└── links to /llms.txt           (recommended back-link)
```

---

## Path & Language Guidance

- Use your site's existing language URL scheme (e.g., `/fr/`, `/sv/`, `/es-mx/`)
- Prefer stable language paths over query parameters for discoverability
- Language labels in link text should be clear and human-readable (e.g., "French", "Svenska", "Español (México)")
- If useful, include the locale code in the description (e.g., `fr`, `de`, `es-MX`)

This repository does not require a specific locale code standard for labels, but BCP 47-style tags are recommended when codes are shown.

---

## Consistency & Conflict Resolution

- The root `llms.txt` remains the repository's primary source of truth for the primary language
- Language variants should be treated as translations/localized equivalents, not separate factual sources
- Do not let translated variants drift on services, geography, policies, or contact details
- Update the relevant language `llms.txt` files when pages are added/removed in that language

---

## Relationship to Other Files

- `llm.txt` at the root should continue pointing to the root `llms.txt`
- `llms-full.txt` (if used) may follow the same multilingual pattern (`/fr/llms-full.txt`, etc.), but this is optional
- `llms.html` may remain a root human-readable view, or be localized if your site localizes HTML content consistently

---

## Validation Notes

The repository validator currently validates root templates/examples and does not automatically validate language-path variants.

For multilingual deployments, validate manually:

- Root `llms.txt` links to each language-path `llms.txt`
- Each language-path `llms.txt` is reachable and encoded as UTF-8
- Localized links point to the correct language pages
- Core facts remain consistent across languages
