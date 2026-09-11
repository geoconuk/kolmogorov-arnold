# The Kolmogorov–Arnold representation theorem in Lean 4

A complete, `sorry`-free formalisation, on top of Mathlib, of the Kolmogorov–Arnold
representation theorem: every continuous function on the unit cube `[0,1]ⁿ` is a finite sum
of continuous functions of one variable, each applied to a sum of continuous functions of one
variable, where the inner functions depend only on `n` and not on the function represented.
It is proved for every `n`, in the Lorentz–Sprecher form with strictly increasing inner
functions, and Lorentz's form and Kolmogorov's original 1957 form are derived from it. The
proof is the Baire-category argument of Hedberg (1971) and Kahane (1975).

About 2,500 lines of Lean in the library proper, 200 declarations, every one depending on no
axiom beyond `propext`, `Classical.choice` and `Quot.sound`. The proofs are machine-generated;
see [Provenance](#provenance).

The same statements and proofs are also published, under the namespace `MiscMath.Analysis`,
in [`geoconuk/lean-misc-math`](https://github.com/geoconuk/lean-misc-math) from its v0.3.0
release; see [Publication and citation](#publication-and-citation). This repository is the
standalone development they were built in.

## The theorem

Three theorems in [`KolmogorovArnold/Theorem.lean`](KolmogorovArnold/Theorem.lean), named for
who is credited with each *statement*. Each implies the next, and the two implications are
proved there; the strongest is the one the development establishes.

**`KolmogorovArnold.kolmogorov_arnold_lorentz_sprecher`** — the Lorentz–Sprecher form. For
every `n` there are positive constants `λ_p` (`p < n`) and continuous strictly increasing
functions `ψ_q : ℝ → ℝ` (`q < 2n + 1`), depending only on `n`, such that every `f` continuous
on `[0,1]ⁿ` can be written `f(x) = ∑_q g(∑_p λ_p ψ_q(x_p))` on the cube, for some continuous
`g : ℝ → ℝ` depending on `f`.

```lean
theorem kolmogorov_arnold_lorentz_sprecher (n : ℕ) :
    ∃ (lam : Fin n → ℝ) (ψ : Fin (2 * n + 1) → ℝ → ℝ),
      (∀ p, 0 < lam p) ∧
      (∀ q, Continuous (ψ q)) ∧
      (∀ q, StrictMono (ψ q)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ g : ℝ → ℝ, Continuous g ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, g (∑ p, lam p * ψ q (x p))
```

**`KolmogorovArnold.kolmogorov_arnold_lorentz`** — Lorentz's form. Continuous monotone
`φ_{q,p} : ℝ → ℝ` depending only on `n`, and for each `f` a single continuous outer function
`Φ`, with `f(x) = ∑_q Φ(∑_p φ_{q,p}(x_p))` on the cube.

**`KolmogorovArnold.kolmogorov_arnold`** — Kolmogorov's form. Continuous `φ_{q,p} : ℝ → ℝ`
depending only on `n`, and for each `f` continuous outer functions `Φ_0, …, Φ_{2n}`, with
`f(x) = ∑_q Φ_q(∑_p φ_{q,p}(x_p))` on the cube.

The order of the quantifiers is the content. In every form the inner functions are chosen
before `f`, so one family serves every continuous function on the cube; only the outer
functions depend on `f`. The statements use nothing beyond Mathlib's `Continuous`,
`ContinuousOn`, `StrictMono`, `Monotone`, `Set.Icc` on `Fin n → ℝ` and finite sums, and
introduce no definition of their own. They are made for every `n`; the literature states
`n ≥ 2`, and `n ≤ 1` is true and trivial.

`Theorem.lean` also carries sanity checks: the `n = 1` case of the Lorentz–Sprecher form
proved outright without the theorem, Kolmogorov's form instantiated at `n = 2` (five terms)
and `n = 3` (seven terms, the case that bears on Hilbert's thirteenth problem), and two
`example`s that separate the three forms at the level of witnesses, showing that the single
outer function and the strictly increasing factored inner functions are each a genuine extra
demand on the inner functions and not a rewording.

## Sources

The statements were compared clause by clause against the five primary papers; the
`## Source` section of `Theorem.lean` records what each states and where the Lean statements
deliberately go beyond them.

- A. N. Kolmogorov, *On the representation of continuous functions of several variables by
  superposition of continuous functions of one variable and addition*, Dokl. Akad. Nauk SSSR
  114 (1957) 953–956. The theorem: universal continuous inner functions, `2n + 1` outer
  functions. No monotonicity in the statement.
- G. G. Lorentz, *Metric entropy, widths, and superpositions of functions*, Amer. Math.
  Monthly 69 (1962) 469–485, Theorem 7: a single outer function, monotone increasing inner
  functions.
- D. A. Sprecher, *On the structure of continuous functions of several variables*, Trans.
  Amer. Math. Soc. 115 (1965) 340–355, Theorem 1: a single inner function `ψ` with constants
  `λ_p`, from which the factored form `λ_p ψ_q` follows.
- T. Hedberg, *The Kolmogorov superposition theorem*, Appendix II to H. S. Shapiro, *Topics
  in Approximation Theory*, Lecture Notes in Math. 187, Springer, 1971, 267–275, Theorem 1:
  the Baire-category proof, in exactly the shape of `kolmogorov_arnold_lorentz_sprecher`,
  with non-decreasing inner functions by his Remark 2.
- J.-P. Kahane, *Sur le théorème de superposition de Kolmogorov*, J. Approx. Theory 13 (1975)
  229–234: the same proof for general `n`, and the remark that quasi-every increasing
  continuous function is strictly increasing.

The strict monotonicity of the `ψ_q` in `kolmogorov_arnold_lorentz_sprecher` is stronger
than any theorem the five primaries state and rests on Kahane's remark; the refinement is
stated as Theorem 4.2 of S. A. Morris, *Hilbert 13: Are there any genuine continuous
multivariate real-valued functions?*, Bull. Amer. Math. Soc. 58 (2021) 107–118. The other
departures are all strengthenings: statements for every `n`, inner and outer functions
continuous on all of `ℝ` rather than on an interval, and no normalisation of the `λ_p` or
the `ψ_q` claimed.

## The proof

The Baire-category route of Hedberg and Kahane, not Kolmogorov's explicit construction. In
the complete metric space of `(2n + 1)`-tuples of monotone continuous functions `[0,1] → ℝ`,
the tuples that admit a one-step approximation of a given `f` form an open dense set;
intersecting over a countable dense set of `f`, and with the dense `Gδ` of strictly increasing
tuples, gives one tuple that approximates every `f` in one step, and iterating on the residual
gives exact representation. Constructing a nested system of shifted cell decompositions with
the right covering multiplicity in general dimension is replaced by showing that a set is
dense, which is what Mathlib is equipped for.

The modules under `KolmogorovArnold/`, in dependency order. Each module's docstring records
what was taken from which paper and where the formalisation departs.

| Module | Content |
|---|---|
| `RationalIndependence` | positive reals linearly independent over `ℚ`, from powers of Liouville's constant: the constants `λ_p` |
| `InnerSpace` | the complete metric space of tuples of monotone continuous functions `[0,1] → ℝ` |
| `Superposition` | the superposition operator; the set of tuples admitting a one-step approximation of `f` is open |
| `StrictlyIncreasing` | the strictly increasing tuples form a dense `Gδ` (Kahane's remark) |
| `Cells`, `Staircase`, `Levels`, `Approximant` | Hedberg's cell system in general dimension, staircase inner functions, rational levels with an injective cell map, and the approximating tuple |
| `Density` | the approximation sets are dense: Hedberg's Lemma 2 for general `n`, the one place the geometry of the cube enters |
| `Generic` | the Baire step: a residual set of tuples approximates every `f` in one step, with norm control |
| `Representation` | iteration on the residual and summation of the geometric series: exact representation on the cube |
| `Theorem` | extension of the inner functions from `[0,1]` to `ℝ`, the three theorems, the sanity checks |
| `Audit`, `Meta/AxiomAudit` | the library-wide axiom audit, run by `lake build` |

## Verification

- **No `sorry`, no extra axioms.** `KolmogorovArnold/Audit.lean` runs `#audit_axioms` over
  the whole library at elaboration time and is part of the default build target, so
  `lake build` fails if any declaration in `KolmogorovArnold.*` depends on an axiom outside
  `propext`, `Classical.choice` and `Quot.sound`. A passing build prints
  `axiom audit passed: 200 declarations across 14 modules`.
- **Three textual checks.** `scripts/check-imports.sh` confirms every module is reachable
  from the root, so nothing escapes the audit; `scripts/check-conventions.sh` rejects `sorry`,
  `native_decide`, `axiom`, `unsafe` and `@[implemented_by]` textually and holds the roof to
  its documentation conventions; `scripts/self-test-audit.sh` plants an unsound module and
  fails unless the audit rejects it.
- **The statements are the ones fixed in advance.** `Target/Roof.lean` states the three
  theorems as they were fixed on 2026-09-10, before the proof was built. It imports only
  Mathlib, proves the two derivations and the sanity checks, and leaves the Lorentz–Sprecher
  form as its one `sorry`: it is a statement surface, not a result, and it is kept outside the
  library and its default targets for that reason. `Target/TypeCheck.lean` ascribes each of its
  three statements, copied verbatim, to the corresponding theorem of `Theorem.lean`, so the
  library cannot drift from the fixed target without a build failure. Anyone importing this
  project elsewhere should take `KolmogorovArnold/` and leave `Target/` behind.

```bash
lake build && ./scripts/check-imports.sh && ./scripts/check-conventions.sh && ./scripts/self-test-audit.sh
lake build Target TargetTypeCheck
```

## Provenance

This repository was produced with Claude (Anthropic's model, via Claude Code). The division
of work is stated so that nothing here reads as a claim of manual work that was not done.

**George A. Constantinides — selection, specification, and the read of the three
statements.** Chose the theorem and the target form of the statement, decided the proof route
and the arrangement of the development. Read the three theorem statements of
`Target/Roof.lean` against the five primary papers on 2026-09-10 and agreed them, before any
layer above `RationalIndependence` was built; `Target/TypeCheck.lean` proves that the
theorems of `KolmogorovArnold/Theorem.lean` carry those statements verbatim. That read is the
whole of the human read, and it is the human contribution the arrangement depends on. He also
reads this README.

**Claude — everything else.** The survey of existing formalisations, the Lean statements and
every proof, the check scripts and axiom audit (ported from `lean-misc-math`), the commit
messages, and the draft of this README. Everything other than the three statements above —
the statements and proofs of the support modules, their docstrings, and the working
documents — is verified by Lean's kernel and audited for axioms, and may be read by no one. No
claim is made that the proofs are novel, elegant or idiomatic, only that they are correct.

Before the statements were read, each was read back blind: a fresh agent was given the Lean
statement and nothing else and asked to write out in English what it literally asserts, and
the rendering was compared against the source. On 2026-09-09 this caught `MonotoneOn` where
the theorem requires strictly increasing, in a draft written to test for exactly such
weakenings.

The commit history is in George's name alone; this section, the `Authors:` line heading
every module under `KolmogorovArnold/` apart from the audit tooling, and the `## Provenance`
docstrings of the seven modules that carry one are where machine generation is disclosed. An
independent review of the published copy on 2026-09-11 found no defect in the three
statements or the proof chain and five defects in the prose, all corrected here as well.

## Relation to existing work

No formalisation of the theorem was found, as of 2026-09-10, in Mathlib, Tau Ceti, the
Palomar registry, the 1000+ theorems list, or the Isabelle AFP, Rocq, HOL Light, Mizar or
Metamath libraries. Mathlib has nothing that states or approaches it. The `lean-eval`
benchmark poses the theorem as `kolmogorov_arnold_superposition`
(`LeanEval/Analysis/KolmogorovArnold.lean`) in its **non-universal** form, `∀ f, ∃ g φ`, in
which the inner functions may depend on `f`; as of the same date that problem records seven
accepted solutions, none with public source. The universal form proved here is the theorem
as Kolmogorov stated it; the non-universal form is its immediate consequence and says nothing
about universality.

## Building

Requires [elan](https://leanprover-community.github.io/install/); the toolchain is pinned in
`lean-toolchain` (Lean 4.33.0) and Mathlib at `v4.33.0` in `lakefile.toml`.

```bash
lake exe cache get   # Mathlib's prebuilt oleans
lake build           # the library and the axiom audit
```

Each module imports only the Mathlib it uses, so `lake build KolmogorovArnold.Density`, say,
rebuilds one module in seconds once Mathlib is warm.

## Publication and citation

The finished modules were copied into
[`geoconuk/lean-misc-math`](https://github.com/geoconuk/lean-misc-math) on 2026-09-11 and
released there as v0.3.0: `Theorem.lean` is the roof `MiscMath/Analysis/KolmogorovArnold.lean`,
with the three theorems and their sanity checks byte-identical apart from the namespace, and
the other modules sit beneath it under `MiscMath/Analysis/KolmogorovArnold/` with only their
imports, namespace and module docstrings changed. The theorems there are
`MiscMath.Analysis.kolmogorov_arnold_lorentz_sprecher`, `MiscMath.Analysis.kolmogorov_arnold_lorentz`
and `MiscMath.Analysis.kolmogorov_arnold`, documented at
<https://geoconuk.github.io/lean-misc-math/docs/MiscMath/Analysis/KolmogorovArnold.html>.

That copy is the one under a release discipline and a Zenodo DOI, and the one a citation
should name: concept DOI [10.5281/zenodo.22648192](https://doi.org/10.5281/zenodo.22648192),
which resolves to the newest release. This repository is kept as the development it was
built in, with the fixed target and its type check, and is not a Lake dependency of the
published copy.

## Licence

Apache 2.0, matching Mathlib.
