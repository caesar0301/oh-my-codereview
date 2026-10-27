# GATHER — Build the Change Surface

`gather <pr|diff|range|repo>` collects everything the review needs: the change itself plus the context to judge it.

## Buckets

| Bucket               | Content                                                                                  |
| -------------------- | ---------------------------------------------------------------------------------------- |
| `materials/diffs/`   | The diff artifact(s): PR patch, `git diff base..head`, working-tree diff                 |
| `materials/commits/` | Commit list with messages (intent evidence for the review)                               |
| `materials/context/` | Touched files **in full**, plus key callers/callees and shared types read during analyze |
| `materials/tests/`   | Tests touching or touched by the change; test plans that fail                            |
| `materials/ci/`      | CI logs, linter output, type-check output when available                                 |
| `materials/failed/`  | Sources that could not be gathered, with reasons                                         |

Create a bucket folder only when writing its first file. Record every source in `docs/index/changes-index.json` (id, bucket, ref, path, gathered-at).

## Source types

- PR URL / number → prefer `gh pr diff` + `gh pr view` (metadata, review thread state)
- Branch or range → `git diff`, `git log`
- Working tree → `git diff HEAD` plus untracked files
- Pasted diff → write to `materials/diffs/pasted-<n>.diff`
- Repo path (audit) → no diff; the audit scope defines the surface

## Gate G — change-surface completeness (run after each gather batch)

Check and show a coverage report:

1. Every file in the diff is readable in full somewhere on disk (diff hunks alone are not context)
2. Tests related to touched modules identified (or explicitly noted missing)
3. Commit messages captured (intent matters: a fix that adds a feature is a finding)
4. CI/type-check signals gathered or marked unavailable

**Warn** on any gap without an explicit user opt-out. A review of hunks without context produces hallucinated findings — this gate exists to prevent exactly that.
