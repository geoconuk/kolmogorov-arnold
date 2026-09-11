# Kolmogorov–Arnold

A Lean 4 formalisation of the Kolmogorov–Arnold representation theorem.

**This is the development record; the published copy lives elsewhere.** The development is
complete and `sorry`-free: the theorem is proved in `KolmogorovArnold/Theorem.lean` in the
three forms fixed in `Target/Roof.lean` before any layer was built. The modules were then
copied, with their statements and proofs unchanged, into
[`geoconuk/lean-misc-math`](https://github.com/geoconuk/lean-misc-math) as
`MiscMath/Analysis/KolmogorovArnold.lean` and the support modules beneath it, released there
as `v0.3.0`. Use that copy: it is the one under that repository's audit, conventions and
release discipline, and the one a citation should name. This repository stays as it was at
the handover, so that the plan, the layers and the fixed target can be read in the order they
happened.

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
claim of manual work that was not done.

**George A. Constantinides — selection, specification, direction, and the read of the three
statements.** Chose the theorem and the target form of the statement, decided the route, the
working arrangement and where the result lives. Read the three theorem statements of
`Target/Roof.lean` — `kolmogorov_arnold_lorentz_sprecher`, `kolmogorov_arnold_lorentz` and
`kolmogorov_arnold` — against the five primary papers on 2026-09-10 and agreed them, before
any layer above 0 was built; `Target/TypeCheck.lean` proves the theorems in
`KolmogorovArnold/Theorem.lean` carry those statements verbatim. That read is the whole of the
human read, and it is the human contribution the arrangement depends on. He also reads this
README.

**Claude — everything mechanical.** The survey of existing formalisations; the Lean
statements and every proof term; the port of the check scripts and axiom audit from
`lean-misc-math`; the commit messages; the plan; the draft of this README. Everything other
than the three statements above — the statements and proofs of the support modules under
`KolmogorovArnold/`, their docstrings, and the working documents — is verified by Lean's
kernel and audited for axioms, and may be read by no one. No claim is made that the proofs are
novel, elegant or idiomatic — only that they are correct.

The commit history is in George's name alone, as in `lean-misc-math`, because this section
and the per-file `## Provenance` docstrings are where machine generation is disclosed; a
trailer on every commit would repeat it without adding information. Each module's header line
and `## Provenance` section record the same division for that file: `Theorem.lean`'s says the
three statements were read, and each support module's says that its own were not advertised
and may be read by no one.

A blind read-back — a fresh agent given a Lean statement and nothing else, asked to write out
what it literally asserts — is run on statements before they are read, as `lean-misc-math`
does. On 2026-09-09 it caught `MonotoneOn` where the theorem requires strictly increasing, in
a draft of the target statement written specifically to test for weakenings.

## Route

The Baire-category proof of Hedberg (*The Kolmogorov superposition theorem*, Appendix II to
H. S. Shapiro, *Topics in Approximation Theory*, LNM 187, Springer, 1971, pp. 267–275) and
Kahane (*Sur le théorème de superposition de Kolmogorov*, J. Approx. Theory **13** (1975)
229–234), not the explicit construction: the tuples of inner functions that work are residual in
the space of monotone continuous functions `[0,1] → ℝ` to the power `2n+1`, which turns the hard
combinatorial step into a density argument that Mathlib is equipped for. Hedberg supplied the
lemma structure and the rational levels with rationally independent `λ_p`; Kahane the
general-`n` interval system, the monotone space, and the remark that quasi-every monotone
function is strictly increasing, which is what pays for the `StrictMono` clause. The module
docstrings under `KolmogorovArnold/` record, layer by layer, what was taken from where and
where the formalisation departs.

## Status

All four checks pass: `lake build` reports *axiom audit passed: 200 declarations across 14
modules*, and the three scripts are green. Every layer went in complete, so the gate was never
red. `Target/TypeCheck.lean` ascribes the three fixed target statements to the library's
theorems, so the statements proved are the statements that were read.

| Layer | Content | State |
|---|---|---|
| 0 | positive reals linearly independent over `ℚ` (`RationalIndependence`) | **complete, audited** |
| 1 | inner-function space (`InnerSpace`); superposition operator and the approximation sets `U_f`, open (`Superposition`); quasi-every monotone function is strictly increasing (`StrictlyIncreasing`) | **complete, audited** |
| 2 | density of `U_f` — the Baire step (`Cells`, `Staircase`, `Levels`, `Approximant`, `Density`) | **complete, audited** |
| 3 | one approximation step for every `f`, from a generic tuple (`Generic`) | **complete, audited** |
| 4 | iteration to exact representation on the cube (`Representation`) | **complete, audited** |
| 5–6 | extension of the inner functions to `ℝ`; the three theorems and their sanity checks (`Theorem`) | **complete, audited** |

The handover into `lean-misc-math` is done (below). Registration and publication steps, if
any, happen from there, each on George's instruction.

## Relationship to `lean-misc-math`

Development happened here; the finished modules were **copied** into
`geoconuk/lean-misc-math` under `MiscMath/Analysis/KolmogorovArnold/` on 2026-09-11, never
taken as a Lake dependency — that repository's axiom audit is scoped to its own namespace and
would not walk a dependency's declarations. In the copy: `Theorem.lean` became the roof
`MiscMath/Analysis/KolmogorovArnold.lean`, with the three theorems and their sanity checks
byte-identical and only the namespace changed (`MiscMath.Analysis`); `Inner.extend` and its
three lemmas moved, verbatim, into a support module `Extend.lean`; the eleven other modules
have their imports and namespace renamed and no other change to code; and the support-module
docstrings were rewritten as support docstrings, since there the advertised statements are
named once, in the roof's `## Provenance`. `Target/` was not copied — a Palomar Challenge, if
one is made, is prepared in that repository's `Palomar/` directory.

The `scripts/` checks and the `Audit.lean` / `Meta/AxiomAudit.lean` pattern are near-verbatim
copies from that repository, retargeted by namespace. **They are advisory here.** Its copies
are the authority, and the checks that count are the ones re-run there at import.

## Checks

```bash
lake build && ./scripts/check-imports.sh && ./scripts/check-conventions.sh && ./scripts/self-test-audit.sh
```

`lake build` runs the axiom audit, so **it is red whenever any layer still carries `sorry`** —
that is the gate, not a fault. For day-to-day work build the single module instead, e.g.

```bash
lake build KolmogorovArnold.Superposition
```

Each module imports only the Mathlib it uses, so one builds in seconds once Mathlib is warm.

## The target

`Target/Roof.lean` states the three theorems this development exists to prove, named for who
is credited with each *statement*: `kolmogorov_arnold` is Kolmogorov's 1957 form and carries
the plain name; `kolmogorov_arnold_lorentz` is Lorentz's single-outer-function form;
`kolmogorov_arnold_lorentz_sprecher` adds Sprecher's factored inner functions `λ_p ψ_q` and is
the strongest, the one the proof establishes. In the Target the strongest is `sorry` and the
other two are derived from it; in `KolmogorovArnold/Theorem.lean` all three are proved with the
same statements, and `Target/TypeCheck.lean` (`lake build TargetTypeCheck`) checks that they
are the same.

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
the target was pinned while it was still cheap to change; George read the three statements
against the primary papers the same day and agreed them. No statement changed during the
development.

## Mathlib pin

Held at `v4.33.0` to match the parent repository, so the warm cache is reusable and imported
modules need no repinning. Bump to current Mathlib before any Lean Pool handover: the pool
asks for a warm build against latest, and nothing here is subject to Palomar's
ancestor-of-`master` constraint.

## Licence

Apache 2.0, matching Mathlib and `lean-misc-math`.
