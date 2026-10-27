# INIT — Bootstrap the Review Workspace

`init "<target>"` creates the review workspace for a named target (PR, branch, commit range, or repo path).

## Behavior

1. Resolve the target: PR URL / number, branch name, commit range (`base..head`), working tree, or repo path for audit mode.
2. Create **only**:
   - `AGENTS.md` — workspace brief: target, base ref, head ref, review pattern, language, created date
   - `.ocr/tree-state.json` — see `../LLM-STATE.md`
   - `.ocr/pattern.json` — default `standard` unless user names another pattern
   - `.ocr/locale.json` — optional preferred language for the report
3. Do **not** create empty folders. `materials/`, `docs/`, `deliverables/` appear only when their first file is written.

## AGENTS.md shape

```markdown
# Review Workspace: <target>

- Target: <PR URL | range | repo path>
- Base: <ref> Head: <ref>
- Pattern: standard
- Report language: <auto-detected or explicit>
- Created: <date>
```

## After init

Show the recommended next step (`gather` for diff targets, `audit` scope proposal for repo targets) and the pattern in use.
