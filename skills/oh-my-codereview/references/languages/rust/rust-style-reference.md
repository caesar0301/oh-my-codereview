<!--

CURATED REFERENCE DIGEST — NOT A VERBATIM COPY. DO NOT REPRESENT AS OFFICIAL.

This file is an attributed digest of official and community Rust style and
best-practice sources, compiled for offline review use. Each section cites its
source URL and, where applicable, the upstream section or checklist item. For
verbatim fidelity or exact wording, follow the URLs to the upstream originals.

Sources (retrieved 2026-11-24):

- The Rust Style Guide — https://doc.rust-lang.org/style-guide/
  (default style implemented by rustfmt; part of the rust-lang project,
  licensed Apache-2.0 / MIT). Section B below.
- The Rust API Guidelines — https://rust-lang.github.io/api-guidelines/checklist.html
  (the C-* checklist; rust-lang/api-guidelines, Apache-2.0 / MIT).
  Sections A, C, I, J below.
- RFC 430 "Finalizing naming conventions" —
  https://github.com/rust-lang/rfcs/blob/master/text/0430-finalizing-naming-conventions.md
  (casing conventions referenced by C-CASE). Section A below.
- Effective Rust, David Drysdale, 2024 — https://www.effective-rust.com/
  (CC BY-NC-ND 4.0, https://creativecommons.org/licenses/by-nc-nd/4.0/).
  Items 3, 4, 16, 17, 18, 29, 30, 31, 34. Sections D, E, F, G, H, L below.
- Rust Design Patterns (anti-patterns) —
  https://rust-unofficial.github.io/patterns/anti_patterns/
  ("Clone to satisfy the borrow checker"). Section E below.
- The Rust Programming Language (the Book) — https://doc.rust-lang.org/book/
  (error handling, ownership, fearless concurrency). Sections D, E, H below.
- Rust by Example / standard library docs — https://doc.rust-lang.org/std/
  (iterator adapters, RAII, Drop). Sections M, C below.

Only this attribution header and the section organization are original to this
file; the rule statements are paraphrased from the sources above. The reviewed
repository's own rustfmt/clippy configuration overrides this digest on
conflict — see ../README.md for the precedence order.

-->

# Rust Style and Best-Practice Reference (Curated Digest)

## A. Naming and casing

Source: Rust API Guidelines `C-CASE`, `C-CONV`, `C-GETTER`, `C-ITER`,
`C-WORD-ORDER`, `C-FEATURE`; RFC 430.

- `UpperCamelCase` for types, traits, enum variants; `snake_case` for modules,
  functions, methods, local variables, macros; `SCREAMING_SNAKE_CASE` for
  constants and statics; short lowercase for lifetimes (`'a`, `'de`, `'src`);
  concise `UpperCamelCase` (usually a single letter `T`) for type parameters.
- In `UpperCamelCase`, acronyms count as one word: `Uuid` not `UUID`, `Stdin`
  not `StdIn`, `Usize` not `USize`. In `snake_case`, acronyms are lower-cased
  (`is_xid_start`). A "word" should not be a single letter unless it is the
  last word: `btree_map` not `b_tree_map`, but `PI_2`.
- Crate names should not use `-rs` / `-rust` as prefix or suffix. Feature names
  avoid placeholder words (`use-alloc`, not `with-alloc` when it is the only
  option); names use a consistent word order.
- Ad-hoc conversion methods follow the prefix convention by cost and ownership:
  `as_` = free, borrowed → borrowed; `to_` = expensive (borrowed → borrowed /
  owned, or owned → owned for `Copy`); `into_` = owned → owned, consumes the
  value. `as_mut_slice` (mutability in the return type) beats `as_slice_mut`.
- Getter methods are `field()` not `get_field()`; collection iterators are
  `iter`, `iter_mut`, `into_iter`, and the iterator type names match the methods
  (`Iter`, `IterMut`, `IntoIter`).

## B. Formatting (rustfmt default style)

Source: The Rust Style Guide (default style implemented by `rustfmt`).

- Use spaces, not tabs; 4 spaces per indentation level; maximum line width
  100 characters. Prefer block indent over visual indent (smaller diffs, less
  rightward drift).
- Use a trailing comma in comma-separated lists followed by a newline; this
  keeps diffs small when items are appended or removed.
- Separate items and statements by zero or one blank line (one or two
  newlines); no trailing whitespace on any line.
- Prefer line comments (`//`) to block comments (`/* ... */`); put a single
  space after `//`; prefer a comment on its own line.
- Sorting (where specified) is "version sorting" so `x8` precedes `x16`.
- These are the `rustfmt` defaults. A repository `rustfmt.toml` overrides them;
  do not report mechanical formatting differences (see the pack README's
  Tooling section).

## C. Type safety and API design

Source: Rust API Guidelines `C-NEWTYPE`, `C-CUSTOM-TYPE`, `C-BITFLAG`,
`C-BUILDER`, `C-STRUCT-PRIVATE`, `C-NEWTYPE-HIDE`, `C-STRUCT-BOUNDS`,
`C-VALIDATE`, `C-METHOD`, `C-NO-OUT`, `C-CTOR`, `C-INTERMEDIATE`,
`C-GENERIC`, `C-OBJECT`, `C-SMART-PTR`, `C-DEREF`, `C-CONV-SPECIFIC`;
Effective Rust Items 1, 7, 8.

- Use the type system to express data structures and invariants: newtypes give
  static distinctions (`struct UserId(u64)`), and arguments convey meaning
  through types rather than `bool` / `Option` (avoid "boolean blindness").
  A set of flags is `bitflags`, not an enum.
- Builders enable construction of complex values; constructors are static,
  inherent methods named `new` or `with_more_details`. Functions with a clear
  receiver are methods; functions do not take out-parameters.
- Keep struct fields private for future proofing; newtypes encapsulate
  implementation details; do not duplicate derived trait bounds on data
  structures.
- Only smart pointers implement `Deref` / `DerefMut`; smart pointers do not add
  inherent methods; conversions live on the most specific type.
- Validate arguments at the boundary. Expose intermediate results to avoid
  duplicate work; let the caller decide where to copy and place data; minimize
  assumptions about parameters with generics; keep traits object-safe if they
  may be useful as trait objects.
- Prefer `Option`/`Result` transforms over explicit `match` where they are
  clearer (Effective Rust Item 3).

## D. Error handling

Source: Effective Rust Item 4 (`std::error::Error`); Rust API Guidelines
`C-GOOD-ERR`; the Book ch. 9.

- Prefer returning `Result<T, E>` over `panic!` for recoverable errors; the `?`
  operator propagates errors concisely.
- Custom error types should implement `std::error::Error` (which requires
  `Display` + `Debug`) and expose nested causes via `source()`. A bare
  `String` as `E` does not implement `Error` and cannot be given one by a
  downstream crate (orphan rule).
- Error types are meaningful and well-behaved (`C-GOOD-ERR`): `Display` is
  user-facing, `Debug` is programmer-facing, `source()` chains the cause.
- Prefer `TryFrom` / `TryInto` for fallible conversions; implement `From` for
  infallible ones (see section I).

## E. Ownership, borrowing, and clones

Source: Rust Design Patterns anti-pattern "Clone to satisfy the borrow
checker"; Effective Rust Items 14, 15; the Book ch. 4.

- Do not add `.clone()` merely to silence a borrow-checker error. A clone
  creates an independent copy whose changes are not synchronized with the
  original; restructure the borrows instead. `Rc<T>` / `Arc<T>` clones are the
  deliberate exception (shared ownership via reference counting).
- Use `std::mem::take` / `std::mem::replace` to move owned values out of
  enums/structs while keeping ownership intact.
- Clones should be deliberate and understood; `cargo clippy` detects many
  unnecessary clones (`redundant_clone`, `clone_on_copy`).

## F. Unsafe and FFI

Source: Effective Rust Items 16, 34, 35; the Rustnomicon.

- Avoid `unsafe` unless necessary; encapsulate every `unsafe` block behind a
  safe API and document its safety invariants with a `// SAFETY:` comment
  explaining why the invariants hold.
- In types that manipulate raw pointers, verify the `Send` / `Sync` status
  actually reflects thread safety (compile-time `assert_send` / `assert_sync`
  tests catch regressions).
- Control what crosses FFI boundaries: use `catch_unwind` to stop panics from
  propagating into non-Rust callers, prefer `bindgen` over hand-written FFI
  mappings, and validate every pointer/length coming from the other side.

## G. Panics and unwinding

Source: Effective Rust Item 18.

- `panic!` is for unrecoverable bugs, not input validation. Prefer `Result`.
  `unwrap()` / `expect()` on values derived from untrusted input or fallible
  operations are latent panics; in library code, propagate instead.
- `catch_unwind` is not a general exception mechanism: `panic = "abort"`
  (Cargo profile) and some targets (e.g. WebAssembly) always abort, and
  unwinding raises exception-safety concerns for invariants.
- Document panic conditions for public APIs (section J, `# Panics`).
- Indexing (`v[i]`), integer arithmetic in debug builds, `unwrap`, and
  `assert!` can all panic; check the boundary or use checked/`get` variants.

## H. Concurrency

Source: Effective Rust Item 17 ("Be wary of shared-state parallelism");
Rust API Guidelines `C-SEND-SYNC`; the Book ch. 16; general/concurrency.md.

- `Send` / `Sync` are auto-derived; be vigilant with raw-pointer types.
  Shared mutable state needs `Arc<Mutex<T>>` / `RwLock<T>` (or atomics); keep
  lock guards as short-lived as possible and never hold a `MutexGuard` across
  an `.await` (it is usually not `Send` and can deadlock).
- Handle `PoisonError` deliberately (a panicked holder poisons a `Mutex`);
  do not blindly `.unwrap()` a lock when poisoning is possible.
- Avoid lock-order inversion and blocking calls inside async tasks; prefer
  message passing / owned data where it simplifies ownership.
- `std::sync::mpsc` / channels and scoped threads (`std::thread::scope`) avoid
  `'static` requirements; a detached task needs owned (`'static`) data.

## I. Common traits and interoperability

Source: Rust API Guidelines `C-COMMON-TRAITS`, `C-CONV-TRAITS`, `C-COLLECT`,
`C-SERDE`, `C-SEND-SYNC`, `C-DEBUG`, `C-DEBUG-NONEMPTY`; Effective Rust Items
10, 11.

- New public types should eagerly implement the applicable common traits:
  `Copy`, `Clone`, `Eq`, `PartialEq`, `Ord`, `PartialOrd`, `Hash`, `Debug`,
  `Display`, `Default`. Crates that define a type must implement them —
  downstream crates cannot (orphan rule). It is normal to provide both
  `Default` and an empty `new` constructor.
- All public types implement `Debug`, and the `Debug` representation is never
  empty (`C-DEBUG`, `C-DEBUG-NONEMPTY`).
- Implement `From` / `TryFrom` / `AsRef` / `AsMut` for conversions; **never**
  implement `Into` / `TryInto` directly (they have blanket impls from
  `From` / `TryFrom`). Collections implement `FromIterator` and `Extend`.
- Data structures implement Serde `Serialize` / `Deserialize` where relevant,
  gated behind a `serde` feature so downstream users do not pay the cost.
- Implement `Drop` for RAII cleanup of resources (Effective Rust Item 11);
  destructors never fail (`C-DTOR-FAIL`) and destructors that may block have
  non-blocking alternatives (`C-DTOR-BLOCK`).

## J. Documentation

Source: Rust API Guidelines `C-CRATE-DOC`, `C-EXAMPLE`, `C-QUESTION-MARK`,
`C-FAILURE`, `C-LINK`, `C-METADATA`, `C-RELNOTES`, `C-HIDDEN`; Effective Rust
Item 27.

- Crate-level docs are thorough and include examples; every public item has a
  rustdoc example. Examples use `?`, not `try!` and not `unwrap`
  (`C-QUESTION-MARK`).
- Function docs include `# Errors`, `# Panics`, and `# Safety` sections where
  applicable (`C-FAILURE`). Prose contains intra-doc links to relevant items
  (`C-LINK`). Hidden, unhelpful implementation details stay out of rustdoc
  (`C-HIDDEN`).
- `Cargo.toml` carries common metadata: authors, description, license,
  homepage, documentation, repository, keywords, categories; significant
  changes are documented in release notes.
- Doctests are compiled and run by `cargo test`; keep examples current with
  import paths, names, and arguments.

## K. Dependencies and features

Source: Effective Rust Items 21–26; the Cargo Book.

- Understand what semver promises: `"1.2.3"` means `>=1.2.3, <2.0.0`; a
  caret requirement is the default. `Cargo.lock` is committed for binaries
  and reproducible CI, and dependency upgrades are reviewed deliberately.
- Minimize visibility (`pub` surface); avoid wildcard (`use foo::*`) imports;
  re-export dependencies whose types appear in your public API so callers do
  not need a matching direct dependency.
- Manage the dependency graph (`cargo tree`, `cargo-deny`, `cargo audit`) and
  be wary of feature creep: features should be additive, default features
  justified, and `default-features = false` respected where possible.
- Review license compatibility and supply-chain metadata for new crates.

## L. Tooling

Source: Effective Rust Items 29, 30, 31, 32; the Clippy / rustfmt docs.

- Make code Clippy-warning free. Clippy categories: correctness, idiom,
  concision, performance, readability (e.g. `approx_constant`,
  `fn_params_excessive_bools`, `needless_return`). A suppressed lint
  (`#[allow(clippy::some_lint)]`) should carry a justification comment.
- Use `rustfmt` for formatting; do not debate mechanical style.
- Write more than unit tests: integration tests, doc tests, property/fuzz
  tests, and CI. Enable Clippy and formatting checks in CI so new warnings
  are obvious.
- Take advantage of the tooling ecosystem (Miri for `unsafe` validation,
  `cargo test`, `cargo bench`, `cargo doc`).

## M. Iterators and performance

Source: Effective Rust Items 9, 20; the Book / std::iter docs.

- Consider iterator transforms (`map`, `filter`, `collect`, `fold`) instead of
  explicit loops where they are clearer; iterators are zero-cost abstractions
  and avoid intermediate allocation when chained.
- Avoid the temptation to over-optimize (Item 20): measure before optimizing,
  prefer clarity, and do not clone or allocate in hot paths without evidence.
- Prefer `&str`/slices and borrowing over owned `String`/`Vec` in signatures
  where ownership is not needed; use `Cow` when ownership is conditional.
- `collect()` into an intermediate `Vec` only when the collection is actually
  needed; otherwise keep the iterator lazy.
