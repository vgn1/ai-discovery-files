# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project uses Semantic Versioning for tagged releases.

## [1.0.0] - 2026-02-24

### Added

- Initial `AI Discovery Files` release with templates, filled examples, and per-file specifications.
- `llms-full.txt` repository extension (specification, template, and example).
- Multilingual site guidance (`specs/multilingual-sites.md`) and Swedish language-path `llms.txt` example.
- Machine-readable dependency map (`specs/dependency-map.yaml`) and dependency-map validator helper (`scripts/check-dependency-map.py`).
- Validation CI workflow, PR template checks, and repository contribution protections (`CODEOWNERS`, RFC gate guidance).

### Changed

- Aligned `llms.txt`/`llm.txt`/`llms.html` templates and specs with the upstream `llms.txt` Markdown format conventions.
- Standardized cross-file Core Identity consistency rules and validation across text/HTML/JSON files.
- Added strict deploy-readiness validation mode (`--strict`) with placeholder/default-value and `llm.txt` URL sanity checks.
- Standardized in-file metadata sections and JSON `metadata.fileSpecification` provenance fields.
- Added optional standalone `DUNS number` and `Alternate domains` fields with cross-file consistency checks.

[1.0.0]: https://github.com/GenerellAI/ai-discovery-files/tree/v1.0.0
