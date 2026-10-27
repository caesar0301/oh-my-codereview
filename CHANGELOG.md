# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-10-27

### Added

- Skill skeleton: `SKILL.md` orchestrator with auto-detection, phase-guard, and confirmation gates
- Operations: `init`, `gather`, `analyze`, `lens`, `report`, `recheck`, `audit`, `version`, `workflow`, `qa`
- Review lenses: correctness, security, performance, concurrency, api-contract, test-coverage, adversarial
- Workflow patterns: Standard (default), Rapid, Deep-Audit, Security-Focus, Loop
- Evidence-bound finding format (`F-0NN`), verdict rubric (PASS / PASS_WITH_ISSUES / FAIL)
- Reference docs: REFERENCE, GRAPH, GATES, LLM-STATE, per-op references
- Repo scaffolding: README, Makefile, CI workflow, Claude marketplace plugin manifest
