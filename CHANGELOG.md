# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Rust language pack (`references/languages/rust/`): `README.md` index, `review-checklist.md` with Rust-specific instantiations of the general category tags, and `rust-style-reference.md`, a curated, attributed digest of the official Rust Style Guide, the Rust API Guidelines, and Effective Rust. Dispatch already worked via `.rs` → `rust` in `analyze_git_diff.py`; no general rule or script changes were needed.
- README "Language packs" section documenting the bundled Python and Rust packs and their style authorities

### Changed

- Migrated the `soothe-code-review` skill into this repo as `skills/oh-my-codereview/`, replacing the previous orchestrator-style skill
- Renamed the skill to `oh-my-codereview` with short name **OMCR** (was OCR); rebranded README, Makefile, `.gitignore`, and marketplace manifest
- Review output/state directory renamed `.review/` → `.omcr/`, config file `.codereview` → `.omcr`, and scripts updated accordingly
- README and marketplace descriptions rewritten to describe the migrated static-review skill (modes, `.omcr/{review-id}/code-review.md` report, severity rubric)

## [0.1.0] - 2026-10-27

### Added

- Skill skeleton: `SKILL.md` orchestrator with auto-detection, phase-guard, and confirmation gates
- Operations: `init`, `gather`, `analyze`, `lens`, `report`, `recheck`, `audit`, `version`, `workflow`, `qa`
- Review lenses: correctness, security, performance, concurrency, api-contract, test-coverage, adversarial
- Workflow patterns: Standard (default), Rapid, Deep-Audit, Security-Focus, Loop
- Evidence-bound finding format (`F-0NN`), verdict rubric (PASS / PASS_WITH_ISSUES / FAIL)
- Reference docs: REFERENCE, GRAPH, GATES, LLM-STATE, per-op references
- Repo scaffolding: README, Makefile, CI workflow, Claude marketplace plugin manifest
