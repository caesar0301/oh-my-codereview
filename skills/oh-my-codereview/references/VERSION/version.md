# VERSION — Workspace Artifact Versioning

Tag, list, diff, and back up review artifacts (`docs/review/`, findings, reports).

| Command                  | Action                                                              |
| ------------------------ | ------------------------------------------------------------------- |
| `version tag <name>`     | Tag the current review state (e.g. `pre-recheck`, `v2-findings`)    |
| `version list`           | List tags with dates and artifact hashes                            |
| `version diff <t1> <t2>` | Show what changed in findings/report between tags                   |
| `version backup`         | Timestamped backup of `docs/review/` + `.ocr/` into `.ocr/backups/` |

Backups live under `.ocr/backups/` (private working state, gitignored by default in target repos). Tags are recorded in `.ocr/versions.json`.
