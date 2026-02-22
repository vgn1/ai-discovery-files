# AI Discovery Files

A standardised set of files that help AI systems (ChatGPT, Claude, Gemini, Perplexity, etc.) accurately discover, interpret, and represent your business.

These templates are ready to customise for your own website.

---

## Quick Start

1. **Copy the templates:** Copy everything from the `templates/` folder
2. **Start with the essentials:** `llms.txt` and `identity.json`
3. **Fill in your details:** Replace all `[placeholder]` values with real business information
4. **Ensure consistency:** Core Identity fields must be word-for-word identical across files that contain them
5. **Deploy:** Upload completed files to your website root (e.g., `https://yourdomain.com/llms.txt`)
6. **Validate:** Run `./scripts/validate.sh path/to/your/files/` and check each file is accessible at its expected URL

---

## Files Overview

### Layer 1 — Core Identity (start here)

| File | Purpose | Priority |
|------|---------|----------|
| `llms.txt` | Primary AI-readable identity — the single source of truth (format follows the canonical upstream `llms.txt` spec) | **Required** |
| `llm.txt` | Compatibility redirect for AI systems that request the singular form | **Required** |
| `llms-full.txt` | Expanded AI-readable context and broader link coverage (same Markdown format as `llms.txt`) | Conditional (use when a concise `llms.txt` cannot cover the site's important public pages clearly) |
| `llms.html` | Human-readable HTML version of the identity for browsers | Recommended |
| `identity.json` | Structured identity data (Schema.org aligned) for machine parsing | **Required** |
| `ai.json` | Structured identity + recommendation signals in JSON | Recommended |

### Layer 2 — Guidance & Control

| File | Purpose | Priority |
|------|---------|----------|
| `ai.txt` | When to recommend (and not recommend) your business | Recommended |
| `brand.txt` | Naming rules, pronunciation, voice & tone, misuse prevention | Recommended |
| `robots-ai.txt` | Content citation preferences and freshness guidance | Optional |

### Layer 3 — Enhancement

| File | Purpose | Priority |
|------|---------|----------|
| `faq-ai.txt` | Verified answers to real customer questions | Recommended |
| `developer-ai.txt` | API, SDK, and integration details (only if applicable) | Conditional |

---

## File Dependencies

```
llms.txt (source of truth)
├── llm.txt          (compatibility redirect → llms.txt)
├── llms-full.txt    (expanded AI-readable context companion)
├── llms.html        (human-readable HTML version)
├── identity.json    (structured version of the same identity)
├── ai.json          (structured identity + recommendation data)
├── ai.txt           (contains Core Identity fields aligned to llms.txt)
├── brand.txt        (keeps naming identity aligned to llms.txt)
├── faq-ai.txt       (contains Core Identity fields aligned to llms.txt)
├── developer-ai.txt (contains Core Identity fields aligned to llms.txt)
└── robots-ai.txt    (contains Core Identity fields aligned to llms.txt)
```

**Rule:** Core Identity fields in files that include them must match `llms.txt` exactly. If you update one, update all corresponding fields.

Machine-readable dependency authority: [`specs/dependency-map.yaml`](specs/dependency-map.yaml)
- This maps duplicated fields, similar/semantic fields, and cross-file change triggers.
- The validator performs a first pass from this map for literal exact-match dependencies.

---

## Implementation Checklist

- [ ] Replace all `[placeholder]` values in every file
- [ ] Verify Core Identity fields are identical across all files that include them
- [ ] Remove any files you don't need (e.g., `developer-ai.txt` if no API)
- [ ] Validate `identity.json` and `ai.json` are valid JSON (use a JSON validator)
- [ ] Upload all files to website root directory
- [ ] Confirm each file is publicly accessible
- [ ] Set correct content types (`text/plain` for `.txt`, `application/json` for `.json`, `text/html` for `.html`)


---

## Important Notes

- **No subdirectories when deployed.** All files must live at the site root. (They are grouped in `templates/` in this repo for organisation — flatten when deploying.)
- **No renaming.** AI systems look for these exact filenames.
- **UTF-8 encoding** for all files.
- **Facts only.** Avoid marketing language — AI systems work best with straightforward, verifiable statements.
- **Keep files current.** Update the "Last updated" date whenever you make changes.

---

## Specifications

Each file has a corresponding specification document in the [`specs/`](specs/) directory describing its purpose, required/optional sections, formatting rules, and relationships to other files.

For `llms.txt`, this repository defers to the canonical upstream specification:
- [AnswerDotAI/llms-txt](https://github.com/AnswerDotAI/llms-txt)
- [Upstream `## Format` section (`nbs/index.qmd`)](https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format)
- [Pinned upstream snapshot used by this repo](https://github.com/AnswerDotAI/llms-txt/tree/861bae977483bfaaafd610ea004d423398c42d64)
- [llmstxt.org](https://llmstxt.org/)

`/specs/llms-txt.md` in this repo is intentionally a thin reference plus repository-specific profile rules.

---

## Validation

Run the validation script to check your files for common issues:

```sh
./scripts/validate.sh              # checks templates/ by default
./scripts/validate.sh path/to/dir  # check a custom directory
```

The script checks:

| Check | What it does |
|-------|-------------|
| **File existence** | Verifies all required, recommended, and optional files are present |
| **JSON validity** | Confirms `identity.json` and `ai.json` parse without errors |
| **UTF-8 encoding** | Checks all `.txt`, `.json`, and `.html` files are UTF-8 compatible |
| **Core Identity consistency** | Compares `Business name`, `Brand name`, and `Services` fields across all `.txt` files against `llms.txt` (the source of truth) |
| **Dependency map (first pass)** | Loads `specs/dependency-map.yaml` and enforces all `exact_match` + `literal` rules |
| **Placeholder detection** | Counts remaining `[bracket]` placeholders that need to be replaced before deploying |

---

## Examples

The [`examples/`](examples/) directory contains a fully filled-in set of AI Discovery Files for a fictional company (Mossbridge Analytics). Use it as a reference when completing your own templates.

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to help improve these templates.

For spec-level changes (new file types, normative format updates, validator rule changes, deprecations), please use the RFC process in [rfcs/0001-rfc-process.md](rfcs/0001-rfc-process.md). Start from [rfcs/template.md](rfcs/template.md).

### Contributors

<!-- Add your name here when you contribute! -->

Thanks to everyone who has contributed to this project. Contributors will be listed here as the community grows.

---

## License

This project is licensed under the [MIT License](LICENSE).
