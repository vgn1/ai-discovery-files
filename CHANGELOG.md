# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project uses Semantic Versioning for tagged releases.

## [Unreleased]

### Added

- Added `CHANGELOG.md` to track repository-level updates.
- Added missing Mossbridge example files in `examples/`: `llm.txt`, `llms.html`, `ai.json`, `developer-ai.txt`, and `robots-ai.txt`.
- Added a repository extension for `llms-full.txt`, including a new specification (`specs/llms-full-txt.md`), template (`templates/llms-full.txt`), and filled Mossbridge example (`examples/llms-full.txt`).
- Added a machine-readable cross-file dependency map (`specs/dependency-map.yaml`) and a first-pass validator helper (`scripts/check-dependency-map.py`) for exact-match dependency checks.

### Changed

- Adopted canonical upstream `llms.txt` specification references in repo docs, including direct and pinned links to `nbs/index.qmd#format`, plus Apache-2.0 attribution for verbatim upstream format text.
- Reworked `templates/llms.txt` and `examples/llms.txt` to match the upstream `llms.txt` format pattern (H1, optional summary/content, then H2 link-list sections).
- Updated `specs/llm-txt.md`, `templates/llm.txt`, and `examples/llm.txt` so `llm.txt` explicitly points to the canonical upstream `llms.txt` format reference.
- Updated `specs/llms-html.md`, `templates/llms.html`, and `examples/llms.html` so HTML output mirrors the upstream-aligned `llms.txt` structure and section groups.
- Clarified `README.md` and `AGENTS.md` so Core Identity consistency applies to files that include Core Identity fields, not every file.
- Enhanced `scripts/validate.sh` to validate full Core Identity field alignment across relevant files (including `brand.txt` and `ai.json`), use robust UTF-8 decoding checks, and ignore Markdown link labels in placeholder detection while treating placeholders in `examples/` as errors.
- Updated docs, templates, examples, and structured manifests (`ai.json`) to include `llms-full.txt` in AI Discovery file lists and references.
- Updated `scripts/validate.sh`, `README.md`, and `AGENTS.md` to integrate the dependency map workflow and include `llms-full.txt` in recommended/core-identity validation coverage.

## [1.0.0] - 2026-02-16

### Added

- Initial stable release of the AI Discovery Files templates, examples, and specifications.

### Changed

- Added per-file `Version: 1.0` markers across specification documents.

[Unreleased]: https://github.com/vgn1/ai-discovery-files/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/vgn1/ai-discovery-files/tree/v1.0.0
