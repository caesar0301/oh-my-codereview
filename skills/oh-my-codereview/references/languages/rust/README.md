# Rust Pack

## Detection

Applies to changed files whose `language` field in `changes.json` is `rust`,
covering Rust source (`.rs`) and build/manifest files commonly reviewed
alongside it (`Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`, `build.rs`).
The diff script maps `.rs` to `rust` directly; no extension change is needed.
Files with an unknown language receive the general rules only.

## Normative style authority

Rust has no single vendored "company style guide" equivalent to the Python
pack's Google guide. The normative authorities for this pack, in precedence
order, are the official/community references distilled in
`rust-style-reference.md`:

1. **The Rust Style Guide** (the default style `rustfmt` implements) —
   <https://doc.rust-lang.org/style-guide/> — formatting, indentation, line
   width, comments, naming-adjacent conventions.
2. **The Rust API Guidelines** —
   <https://rust-lang.github.io/api-guidelines/checklist.html> — naming,
   interoperability, predictability, type safety, dependability,
   documentation, future proofing (the `C-*` checklist items).
3. **RFC 430 (naming conventions)** — casing conventions referenced by
   `C-CASE`.
4. **Effective Rust** (David Drysdale, 2024, CC BY-NC-ND 4.0) —
   <https://www.effective-rust.com/> — idiomatic error handling, panic policy,
   borrow/clone anti-patterns, Clippy, tooling.
5. **Rust Design Patterns / anti-patterns** —
   <https://rust-unofficial.github.io/patterns/> — the "clone to satisfy the
   borrow checker" anti-pattern.

`rust-style-reference.md` is a **curated, attributed digest** of those sources,
not a verbatim copy: it carries source URLs, licenses, and a retrieval date,
and every rule cites the section it came from. When a finding needs verbatim
fidelity or the exact wording, follow the URLs in that file to the upstream
originals. See `../README.md` for the precedence order: the reviewed
repository's own `rustfmt.toml`, `clippy.toml`, lint configuration, and
`CONTRIBUTING` rules override everything below on conflict, and the conflict
should be cited in the report appendix.

## General categories instantiated here

`review-checklist.md` instantiates these general tags with Rust-specific
patterns:

| General rule file                | Tags instantiated                                                                       | Rust pack adds                                                                                                                                    |
| -------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `../../general/scanning.md`      | `[security]`, `[bug]`, `[performance]`, `[resources]`, `[testing]`, `[conciseness]`     | `unsafe` soundness, `unwrap`/panic on untrusted input, integer overflow/ casts, `clone` anti-pattern, iterator vs loop, RAII/Drop, test layering |
| `../../general/documentation.md` | `[documentation]`                                                                       | rustdoc `# Errors`/`# Panics`/`# Safety`, doctests, intra-doc links, feature docs                                                                 |
| `../../general/concurrency.md`   | `[concurrency]`                                                                         | `Send`/`Sync`, `Arc<Mutex<T>>` lock scope, poisoning, blocking in async, lock ordering                                                             |
| `../../general/io.md`            | `[io]`                                                                                  | `Path`/`PathBuf` composition, `BufReader`/`BufWriter` flush, temp files, error propagation on writes                                              |
| `../../general/dependencies.md`  | `[dependencies]`                                                                        | `Cargo.toml` version requirements, `Cargo.lock`, feature flags, re-exports, license metadata                                                       |
| — (pack-owned)                   | `[style]`                                                                               | RFC 430 casing, `as_`/`to_`/`into_` conversions, common traits, `From`/`TryFrom`, builders, newtypes, `Debug`, rustfmt defaults                   |

Severity, conclusions, feedback tone, and the report format are **not**
redefined here; they stay in `../../general/severity-and-feedback.md` and
`../../general/reporting.md`.

## Tooling

Do not hard-code tool commands. Use the reviewed repository's own configured
formatter (`rustfmt`), linter (`clippy`), and test runner (`cargo test`); when
it has none, note that in the report appendix and rely on the static checks in
this pack. Automated formatting and lint findings are **not** reported unless
they change behavior (see the general scanning rules) — in particular, do not
report anything `rustfmt` or `clippy` would catch mechanically. A lint that is
suppressed with `#[allow(...)]` without a justification comment is a legitimate
review finding, not an automated-lint duplicate.

## Targeted reads of the reference digest

`rust-style-reference.md` is organized into top-level `## A.`–`## M.`
sections. Never load it wholesale into context; locate the relevant section,
then read only that range:

```bash
REF="{SKILL_HOME}/references/languages/rust/rust-style-reference.md"
rg -n '^## ' "$REF"                         # list all sections with line numbers
rg -n '^## D\.|^## F\.|^## G\.' "$REF"      # error handling, unsafe, panics
rg -n '^### ' "$REF"                        # list subsections
sed -n '120,180p' "$REF"                    # read one located section
```

Frequently used anchors (relocate with `rg` first; line numbers shift if the
digest is revised):

| Topic                         | Section heading                                  |
| ----------------------------- | ------------------------------------------------ |
| Naming / casing               | `## A. Naming and casing`                       |
| Formatting / rustfmt          | `## B. Formatting (rustfmt default style)`      |
| Type safety / API design      | `## C. Type safety and API design`              |
| Error handling                | `## D. Error handling`                          |
| Ownership / clones            | `## E. Ownership, borrowing, and clones`        |
| Unsafe / FFI                  | `## F. Unsafe and FFI`                          |
| Panics                        | `## G. Panics and unwinding`                    |
| Concurrency                   | `## H. Concurrency`                             |
| Common traits                 | `## I. Common traits and interoperability`      |
| Documentation / rustdoc       | `## J. Documentation`                           |
| Dependencies / features       | `## K. Dependencies and features`               |
| Tooling / Clippy / CI         | `## L. Tooling`                                 |
| Iterators / performance       | `## M. Iterators and performance`               |

## Usage

Load this file first, then `review-checklist.md`. For each candidate finding,
relocate the cited reference section with `rg` and read only that section before
grading. Locate a check in `review-checklist.md` by its category tag or by
searching the pattern name. When the cited rule comes from an upstream source
rather than the digest, follow the URL in `rust-style-reference.md` for the
authoritative wording.
