# LENS — Structured Review Passes

`lens [name]` is a side-cycle on ANALYZE: a focused pass over the change surface that confirms, refines, downgrades, or withdraws findings — and may surface new ones.

## Lens library

| Lens                       | Question it asks                                                                                                                      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `correctness` (default)    | Does the code do what the diff claims? Trace each changed path: off-by-one, null/None, error paths, resource cleanup, boundary values |
| `security` (default)       | Injection, authz/authn gaps, secret handling, unsafe deserialization, path traversal, supply-chain changes in deps                    |
| `performance`              | Complexity regressions, N+1 queries, unbounded loops, large allocations, hot-path regressions                                         |
| `concurrency`              | Races, lock ordering, shared mutable state, async ordering, idempotency                                                               |
| `api-contract`             | Breaking changes to public interfaces, semver implications, backward compatibility, migration needs                                   |
| `test-coverage`            | Which changed behaviors are untested? Are new tests meaningful or mirror-implementations?                                             |
| `adversarial` (pre-report) | Attack your own findings: which would a maintainer rightly reject? Which lack evidence?                                               |

In the **Standard** pattern, `correctness` and `security` are offered by default before Gate A, and `adversarial` runs as part of the pre-report lenses.

## Stamp semantics

Every lens run updates findings in place (after confirm) and appends a run note:

| Stamp        | Meaning                                                                  |
| ------------ | ------------------------------------------------------------------------ |
| `confirmed`  | Evidence re-verified under this lens                                     |
| `refined`    | Severity, category, or reasoning adjusted (record what and why)          |
| `downgraded` | Severity lowered — e.g. possible-intent resolved with the user           |
| `withdrawn`  | Finding removed — evidence did not hold; keep the record in the run note |

New findings from a lens enter the normal `F-0NN` numbering and go through Gate A like any other.

## After lens

Run **Gate T**: did the lens surface gaps that need more context (missing callers, absent tests)? If yes, route back to GATHER; else proceed to Gate A / REPORT.
