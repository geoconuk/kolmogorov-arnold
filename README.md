# Kolmogorov–Arnold

A Lean 4 formalisation of the Kolmogorov–Arnold representation theorem, in progress.

**Private work in progress.** Nothing here is finished, and modules carry `sorry` until a
layer is complete. This repository is made public only when the development is done; see
*Status* below for where it actually is.

## What this is for

There is no formalisation of the Kolmogorov–Arnold representation theorem in Mathlib, Tau
Ceti, the Palomar registry, or any other proof assistant. The `lean-eval` benchmark records
seven accepted solutions of a weakened form of it, but every one is unpublished and two have
had their sources permanently lost, so there is nothing to read or build on.

The target here is the Lorentz–Sprecher form — Kolmogorov 1957 with Lorentz's single outer
function and Sprecher's factored inner functions — with the inner functions **universal**:

> There are positive constants `λ_p` and continuous strictly increasing `ψ_q : ℝ → ℝ`, for
> `q ∈ Fin (2n+1)` and `p ∈ Fin n`, depending only on `n`, such that for every continuous
> `f : [0,1]ⁿ → ℝ` there is a continuous `g : ℝ → ℝ` with
> `f(x) = ∑_q g (∑_p λ_p ψ_q (x_p))` on the cube.

The quantifier order is the point. The benchmark form asks only for `∀ f, ∃ ψ`, which lets
the inner functions depend on `f` and is a much weaker statement.

## Who did what

This repository is produced with Claude (Anthropic's model, via Claude Code), and the split
of work is the one `lean-misc-math` uses; it is stated here so that nothing below reads as a
claim of manual work that was not done. *Development-stage wording: to be revised against
what was actually read before this repository is made public.*

**George A. Constantinides — selection, specification, direction, reading.** Chose the
theorem and the target form of the statement, decided the route, the working arrangement and
where the result will live. Reads the published surface — this README and the top-level
theorem statements — and those reads are the human contribution the arrangement depends on.

**Claude — everything mechanical.** The survey of existing formalisations; the Lean
statements and every proof term; the port of the check scripts and axiom audit from
`lean-misc-math`; the commit messages; the draft of this README. What gets read depends on
what it is. The published surface above gets George's read. Proofs, supporting lemmas and
working documents such as commit messages are verified by Lean's kernel and audited for
axioms, but are not read by anyone, human or otherwise. No claim is made that the proofs are
novel, elegant or idiomatic — only that they are correct.

The commit history is in George's name alone, as in `lean-misc-math`, because this section
and the per-file `## Provenance` docstrings are where machine generation is disclosed; a
trailer on every commit would repeat it without adding information. Each result module's
header line and `## Provenance` section record the same division for that file.

A blind read-back — a fresh agent given a Lean statement and nothing else, asked to write out
what it literally asserts — is run on statements before they are read, as `lean-misc-math`
does. On 2026-09-09 it caught `MonotoneOn` where the theorem requires strictly increasing, in
a draft of the target statement written specifically to test for weakenings.

## Route

Kahane's Baire-category proof (*Sur le théorème de superposition de Kolmogorov*,
J. Approx. Theory **13** (1975) 229–234), not the explicit construction: the tuples of inner
functions that work are residual in `C([0,1])^{2n+1}`, which turns the hard combinatorial
step into a density argument that Mathlib is equipped for.

## Status

All four checks currently pass: `lake build` reports *axiom audit passed: 10 declarations
across 3 modules*, and the three scripts are green. Layer 0 went in complete, so the gate has
not yet been red.

| Layer | Content | State |
|---|---|---|
| 0 | positive reals linearly independent over `ℚ` | **complete, audited** |
| 1 | inner-function space, separation property | not started |
| 2 | genericity — the Baire step | not started |
| 3 | one approximation step | not started |
| 4 | iteration to exact representation | not started |
| 5 | Lorentz single-outer-function refinement | not started |
| 6 | roof: statement and sanity checks | **statements fixed** in `Target/Roof.lean`, read back; proof pending |

## Relationship to `lean-misc-math`

Development happens here; the finished modules are **copied** into
`geoconuk/lean-misc-math` under `MiscMath/Analysis/KolmogorovArnold/`, never taken as a Lake
dependency — that repository's axiom audit is scoped to its own namespace and would not walk
a dependency's declarations.

The `scripts/` checks and the `Audit.lean` / `Meta/AxiomAudit.lean` pattern are near-verbatim
copies from that repository, retargeted by namespace. **They are advisory here.** Its copies
are the authority, and the checks that count are the ones re-run there at import.

## Checks

```bash
lake build && ./scripts/check-imports.sh && ./scripts/check-conventions.sh && ./scripts/self-test-audit.sh
```

`lake build` runs the axiom audit, so **it is red whenever any layer still carries `sorry`** —
that is the gate, not a fault. For day-to-day work build the single module instead:

```bash
lake build KolmogorovArnold.RationalIndependence
```

## The target

`Target/Roof.lean` states the three theorems this development exists to prove, named for who
is credited with each *statement*: `kolmogorov_arnold` is Kolmogorov's 1957 form and carries
the plain name; `kolmogorov_arnold_lorentz` is Lorentz's single-outer-function form;
`kolmogorov_arnold_lorentz_sprecher` adds Sprecher's factored inner functions `λ_p ψ_q` and is
the strongest, the one the proof will establish. The strongest is `sorry`; the other two are
derived from it, and the `n = 1` case of the strongest is proved outright.

All three were compared clause by clause against the primary papers — Kolmogorov 1957,
Lorentz 1962, Sprecher 1965, Hedberg 1971, Kahane 1975 — on 2026-09-10; the file's `## Source`
section records what each states and where the Lean statements deliberately go beyond them.
The one clause stronger than any stated theorem is `StrictMono` in the strongest form, kept
on Kahane's remark that quasi-every increasing `φ` is strictly increasing. It is a separate lake target outside
the audited library, the arrangement `lean-misc-math` uses for a Palomar Challenge, so the
four checks stay green while the layers are built. Build it with:

```bash
lake build Target
```

It was fixed and blind-read-back on 2026-09-10, before any layer above 0 was started, so that
the target is pinned while it is still cheap to change.

## Mathlib pin

Held at `v4.33.0` to match the parent repository, so the warm cache is reusable and imported
modules need no repinning. Bump to current Mathlib before any Lean Pool handover: the pool
asks for a warm build against latest, and nothing here is subject to Palomar's
ancestor-of-`master` constraint.

## Licence

Apache 2.0, matching Mathlib and `lean-misc-math`.
