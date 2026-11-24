# Rust Review Checklist

Rust-specific instantiations of `../../general/`. Each section names its
general rule file and category tag; **only** rows that add concrete Rust
syntax, APIs, or conventions are listed here. General principles are not
restated — load the named general rule for the principle and this file for the
concrete pattern.

Style authority: `rust-style-reference.md` (curated, attributed digest of the
official Rust Style Guide, Rust API Guidelines, Effective Rust, and Rust Design
Patterns). A `—` in the Reference column means the check comes from a general
rule, not from the style digest. When the reviewed repository's own
`rustfmt.toml` / `clippy.toml` / lint configuration conflicts, it wins — see
`../README.md`. Locate a cited section with the `rg` patterns in `README.md`
before reading it.

## 1. Security `[security]`

General rule: `../../general/scanning.md` §1 and `../../general/io.md` §1–2.

| Rust-specific check                                                                                                                                       | Reference section                 |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| Every `unsafe` block has a `// SAFETY:` comment stating the invariants and is wrapped in a safe API; audit pointer arithmetic, `from_raw`, and `transmute` use | `## F. Unsafe and FFI`            |
| At FFI boundaries validate every pointer/length, stop panics with `catch_unwind`, and prefer `bindgen` over hand-written bindings                               | `## F. Unsafe and FFI`            |
| Do not index slices/arrays with untrusted indices (`v[i]` panics); use `.get(i)` and handle `None`                                                              | `## G. Panics and unwinding`      |
| Validate untrusted paths by composing `Path` / `PathBuf` components against an allow-listed root; a string-prefix check alone is insufficient                     | `../../general/io.md` §1          |
| Never pass untrusted data to `Command` with a shell string; use the argument-list form and avoid `sh` interpolation                                                | `../../general/scanning.md` §1    |
| Deserialize untrusted data with an explicit schema; do not disable Serde's validation or deserialize into `Value` and index blindly                                | `## D. Error handling`            |

Grade a reachable memory-safety violation, injection, traversal, or
out-of-bounds panic on untrusted input as Critical per
`../../general/severity-and-feedback.md`.

## 2. Potential bugs `[bug]`

General rule: `../../general/scanning.md` §2.

| Rust-specific check                                                                                                                                  | Reference section                       |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| No `unwrap()` / `expect()` / `panic!` on values derived from fallible operations or untrusted input in library code; return `Result` and use `?` instead | `## D. Error handling`, `## G. Panics` |
| Handle `None` / `Err` explicitly; do not `let _ =` a `Result` that can fail, and do not use `catch_unwind` as an exception mechanism                      | `## D. Error handling`                  |
| Integer casts (`as`) can truncate or wrap; use `TryFrom` / `checked_*` for conversions where the value may not fit                                        | `## C. Type safety`, `## D`            |
| A `.clone()` added solely to silence a borrow-checker error produces an unsynchronized copy; restructure the borrows or use `mem::take`/`replace`          | `## E. Ownership, borrowing, and clones` |
| Lock poisoning: do not blindly `.unwrap()` a `Mutex`/`RwLock` lock when a panicked holder can poison it; handle `PoisonError` deliberately                  | `## H. Concurrency`                     |
| `Drop` implementations never fail and do not block; provide an explicit non-blocking cleanup alternative                                                      | `## I. Common traits`                   |
| Addition/subtraction and indexing panic on overflow / out-of-bounds in debug builds; confirm the boundary is guarded                                          | `## G. Panics and unwinding`            |

Boundary cases (zero, negative, oversized, empty collections, off-by-one) come
from the general rule and are not repeated here.

## 3. Performance `[performance]`

General rule: `../../general/scanning.md` §3.

| Rust-specific check                                                                                                                                | Reference section                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| Prefer iterator adapters over explicit loops where clearer; do not `collect()` into an intermediate `Vec` when the iterator can stay lazy               | `## M. Iterators and performance`  |
| Borrow (`&str`, `&[T]`) in signatures where ownership is not needed; avoid needless `String`/`Vec` allocation and `clone()` in hot paths                  | `## M. Iterators and performance`  |
| Do not optimize prematurely — report a performance claim only with a concrete hot path and measurement rationale                                           | `## M. Iterators and performance`  |
| `BufWriter` must be flushed (`flush()` or dropped properly) or buffered writes are lost; `BufReader` avoids per-read syscalls                             | `../../general/io.md` §5           |

N+1 patterns, blocking I/O on hot paths, and unbounded growth come from the
general rule.

## 4. Resource management `[resources]`

General rule: `../../general/scanning.md` §4.

| Rust-specific check                                                                                                                                    | Reference section                 |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------- |
| Manage resources with RAII / `Drop`; do not leak `File`, sockets, or `MutexGuard` by forgetting to drop them on every path                                 | `## I. Common traits`             |
| Release lock guards before `.await` and keep guard scopes minimal; a guard held across an await can deadlock or fail the `Send` bound                     | `## H. Concurrency`               |
| Clean up temporary files/artifacts with a scope guard or `Drop`; use `tempfile`-style randomized names, never a fixed name in a shared directory           | `../../general/io.md` §4          |

## 5. Testing `[testing]`

General rule: `../../general/scanning.md` §5.

| Rust-specific check                                                                                                                                        | Reference section   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| Cover happy/boundary/error paths with unit + integration tests; keep doctests runnable (they compile under `cargo test`)                                        | `## J. Documentation` |
| Add compile-time `assert_send::<T>()` / `assert_sync::<T>()` tests for raw-pointer types to catch `Send`/`Sync` regressions                                     | `## F. Unsafe and FFI` |
| Use property/fuzz or Miri validation for `unsafe` code and parsers; isolate external I/O with the repository's chosen test doubles                              | `## L. Tooling`      |
| Assert against values derived from the implementation, not hard-coded magic constants; tests are deterministic and do not depend on timing                      | `../../general/scanning.md` §5 |

Coverage of happy/boundary/error paths, determinism, and regression value come
from the general rule.

## 6. Documentation `[documentation]`

General rule: `../../general/documentation.md`.

| Rust-specific check                                                                                                                                        | Reference section   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| Public items have rustdoc examples; examples use `?`, not `try!` or `unwrap`                                                                                    | `## J. Documentation` |
| Document `# Errors`, `# Panics`, and `# Safety` sections where applicable, and keep them consistent with the actual error/panic/unsafe paths                     | `## J. Documentation` |
| Intra-doc links resolve (`[`Foo`]`), and hidden implementation details are not exposed in rustdoc                                                               | `## J. Documentation` |
| `Cargo.toml` metadata (description, license, repository, documentation) and release notes stay in sync with the change                                          | `## J. Documentation`, `## K` |
| Doctest examples use current import paths, names, and arguments                                                                                                 | `## J. Documentation` |

A documented promise contradicted by behavior is Critical per
`../../general/documentation.md`.

## 7. Concurrency `[concurrency]`

General rule: `../../general/concurrency.md`.

| Rust-specific check                                                                                                                                        | Reference section   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| Shared mutable state uses `Arc<Mutex<T>>` / `RwLock<T>` or atomics; `Send`/`Sync` status is verified for raw-pointer types                                     | `## H. Concurrency`  |
| Never hold a `MutexGuard` / `RwLock` guard across `.await`; use scoped threads or owned (`'static`) data for detached tasks                                     | `## H. Concurrency`  |
| Handle `PoisonError` deliberately; avoid lock-order inversion and blocking calls inside async tasks                                                              | `## H. Concurrency`  |
| Prefer message passing / channels where it simplifies ownership; every spawned task has an owner that observes its result                                       | `## H. Concurrency`  |

Execution-context affinity, lock ordering, pool shutdown, and lost-result
aggregation come from the general rule.

## 8. IO `[io]`

General rule: `../../general/io.md`.

| Rust-specific check                                                                                                                                        | Reference section   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| Compose paths with `Path::join` / `PathBuf` and canonicalize against an allow-listed root; avoid raw string concatenation of caller-supplied components            | `../../general/io.md` §1 |
| Propagate or log write/flush failures (`?` on `write_all` / `flush`); clean up partial outputs                                                                   | `../../general/io.md` §5 |
| Use `BufReader`/`BufWriter` for stream consumers; flush or explicitly drop `BufWriter` before reading the output                                                  | `## C. Type safety`  |

Credential handling and temporary-file lifecycle come from the general rule.

## 9. Dependencies `[dependencies]`

General rule: `../../general/dependencies.md`.

| Rust-specific check                                                                                                                                        | Reference section        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| A new `use` has a matching `Cargo.toml` dependency; a removed dependency has no surviving imports; `Cargo.lock` is updated consistently                          | `## K. Dependencies and features` |
| Version requirements respect semver (`"1.2.3"` = `>=1.2.3, <2.0.0`); upgrades and `Cargo.lock` churn are deliberate and reviewed                                 | `## K. Dependencies and features` |
| Features are additive, `default-features = false` is respected, and feature names avoid placeholder words                                                         | `## K. Dependencies and features`, `## A` |
| Re-export dependencies whose types appear in the public API; avoid wildcard `use foo::*` imports                                                                  | `## K. Dependencies and features` |
| New crates carry license metadata and are checked for license/supply-chain compatibility; copied third-party code carries source and license in a comment         | `## K. Dependencies and features` |

Constraint conflicts, license risk, and severity grading come from the general
rule.

## 10. Style `[style]`

General rule for severity and reporting: `../../general/severity-and-feedback.md`
and `../../general/reporting.md`. All items below are Minor unless the
repository's own rules say otherwise, and are **not** reported when the
configured `rustfmt` / `clippy` covers them mechanically.

| Check                  | Detail                                                                                                                                              | Reference section          |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| Casing                 | RFC 430: `UpperCamelCase` types/traits/variants, `snake_case` modules/functions/vars/macros, `SCREAMING_SNAKE_CASE` consts/statics, acronyms as one word (`Uuid`) | `## A. Naming and casing`  |
| Conversion names       | `as_` free borrowed view, `to_` expensive, `into_` consuming; implement `From`/`TryFrom`/`AsRef`/`AsMut`, never `Into`/`TryInto` directly                    | `## A`, `## I`             |
| Getters / iterators    | `field()` not `get_field()`; `iter`/`iter_mut`/`into_iter` with matching `Iter`/`IterMut`/`IntoIter` type names                                              | `## A. Naming and casing`  |
| Common traits          | Public types eagerly implement applicable `Copy`/`Clone`/`Eq`/`PartialEq`/`Ord`/`Hash`/`Debug`/`Display`/`Default`; `Debug` is never empty                    | `## I. Common traits`      |
| Constructors           | Static inherent `new` / `with_*`; builders for complex types; `Default` alongside an empty `new` is expected                                                  | `## C. Type safety`        |
| Type safety            | Newtypes and typed arguments instead of `bool`/`Option` flags; `bitflags` for flag sets; private struct fields                                                  | `## C. Type safety`        |
| Error types            | Custom errors implement `std::error::Error` + `Display` + `Debug`, expose `source()`; no bare `String` as `Result` error                                       | `## D. Error handling`     |
| Formatting             | `rustfmt` defaults: 4-space indent, 100-char width, block indent, trailing commas, no trailing whitespace, line comments                                       | `## B. Formatting`         |
| Clippy                 | Code is Clippy-warning free; a suppressed lint (`#[allow(...)]`) carries a justification comment                                                                  | `## L. Tooling`            |
| Visibility             | Minimize `pub` surface; no wildcard imports; re-exports for API-exposed dependency types                                                                          | `## K. Dependencies`       |
| Comments / docs        | `// SAFETY:` on every `unsafe`; rustdoc `# Errors`/`# Panics`/`# Safety`; intra-doc links resolve                                                                 | `## F`, `## J`             |
| Macros                 | Use macros judiciously; macro input syntax evokes the output and composes with attributes                                                                         | Rust API Guidelines `C-EVOCATIVE` |
| Function length        | Long functions are a readability signal; report only with a concrete decomposition                                                                               | `../../general/scanning.md` §6 |

## Finding format

Attach the general tag from the section heading, the severity per
`../../general/severity-and-feedback.md`, and the cited reference section.
Critical and Major findings additionally require the evidence triple defined in
`../../general/reporting.md`. When a check cites an upstream source rather than
`rust-style-reference.md`, note the source URL from that file's attribution
header in the finding.
