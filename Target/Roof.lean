/-
Copyright (c) 2026 George A. Constantinides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: George A. Constantinides (selection, specification), Claude (formalisation, proof)
-/
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.Order.ProjIcc
import Mathlib.Algebra.BigOperators.Fin

/-!
# The Kolmogorov–Arnold representation theorem — statement surface

**This file is the target, not a result.** It states the theorems this development exists to
prove, and the one that carries the content is `sorry`. It lives outside the audited library
on purpose — the same arrangement `lean-misc-math` uses for a Palomar Challenge — so that the
audit stays green and meaningful while the layers are built, and so that the statements are
fixed, read and read back *before* several thousand lines are built toward them. When Layer 6
closes the `sorry` these statements move into the library with their proofs; this file then
becomes the Challenge.

Three statements, in decreasing strength, named for who is credited with the *statement*
(not for the proof route): the Lorentz–Sprecher form, which is the strongest and the one the
proof will establish; Lorentz's form; and Kolmogorov's, which carries the plain name because
it is the theorem as proved in 1957 and as usually cited. The two weaker forms are derived
from the strongest here.

## Informal statement

Fix `n`. Write `[0,1]ⁿ` for the closed unit cube.

**Lorentz–Sprecher form** (`kolmogorov_arnold_lorentz_sprecher`). There are positive
constants `λ₁, …, λₙ` and continuous strictly increasing functions `ψ₀, …, ψ₂ₙ : ℝ → ℝ`, all
depending only on `n`, such that every function `f` continuous on `[0,1]ⁿ` can be written
`f(x) = ∑_{q=0}^{2n} g(∑_{p=1}^{n} λ_p ψ_q(x_p))` on the cube, for some continuous
`g : ℝ → ℝ` depending on `f`.

**Lorentz's form** (`kolmogorov_arnold_lorentz`). There are continuous `φ_{q,p} : ℝ → ℝ`
(`q = 0, …, 2n`; `p = 1, …, n`) depending only on `n` such that every `f` continuous on
`[0,1]ⁿ` is `f(x) = ∑_{q=0}^{2n} Φ(∑_{p=1}^{n} φ_{q,p}(x_p))` on the cube for some continuous
`Φ : ℝ → ℝ`.

**Kolmogorov's form** (`kolmogorov_arnold`). As above but with `2n + 1` outer
functions: `f(x) = ∑_{q=0}^{2n} Φ_q(∑_{p=1}^{n} φ_{q,p}(x_p))`.

In every form the inner functions are quantified **before** `f`: one family serves every
`f`. That is the content of the theorem, and it is what distinguishes these statements from
the weaker `∀ f, ∃ φ` form that the `lean-eval` benchmark poses.

The statements are made for every `n`. The literature states `n ≥ 2`; the cases `n = 0`
and `n = 1` are true and trivial (`n = 1`: take every inner function to be the identity and
`g = f/3`), and the sanity checks below prove `n = 1` directly.

## Source

Attributions follow the introduction of J. Braun and M. Griebel, *On a constructive proof of
Kolmogorov's superposition theorem*, Constr. Approx. 30 (2009) 653–675, which states them in
one sentence: "Lorentz showed that the outer functions Φ_q can be chosen to be the same
[19, 20] while Sprecher proved that the inner functions ψ_{q,p} can be replaced by λ_p ψ_q with
appropriate constants λ_p [25, 26]. A proof of Lorentz's version with one outer function that
is based on the Baire category theorem was given by Hedberg [9] and Kahane."

- **Kolmogorov's form.** A. N. Kolmogorov, *On the representation of continuous functions of
  several variables by superposition of continuous functions of one variable and addition*,
  Dokl. Akad. Nauk SSSR 114 (1957) 953–956.
- **Single outer function.** G. G. Lorentz, *Metric entropy, widths, and superpositions of
  functions*, Amer. Math. Monthly 69 (1962) 469–485; and *Approximation of Functions*, Holt,
  Rinehart & Winston, 1966, Ch. 11.
- **Factored inner functions `λ_p ψ_q`.** D. A. Sprecher, *On the structure of continuous
  functions of several variables*, Trans. Amer. Math. Soc. 115 (1965) 340–355; and *An
  improvement in the superposition theorem of Kolmogorov*, J. Math. Anal. Appl. 38 (1972)
  208–213.
- **Baire-category proofs** (the route this development takes). T. Hedberg, *The Kolmogorov
  superposition theorem*, Appendix II to H. S. Shapiro, *Topics in Approximation Theory*,
  Lecture Notes in Math. 187, Springer, 1971, 267–275; J.-P. Kahane, *Sur le théorème de
  superposition de Kolmogorov*, J. Approx. Theory 13 (1975) 229–234; exposition in S. Ya.
  Khavinson, *Best Approximation by Linear Superpositions*, Transl. Math. Monogr. 159, AMS,
  1997. The `n = 2` instance in the factored form, `f(x,y) = ∑_{k=1}^{5} h(φ_k(x) + √2 φ_k(y))`,
  is the theorem of S. Dzhenzher and A. Skopenkov, *A structured proof of Kolmogorov's
  Superposition Theorem*, arXiv:2105.00408.

Not targeted: Sprecher's further refinement to a single inner function with shifts,
`∑_q g(∑_p λ_p ψ(x_p + qa) + q)`, as corrected by Köppen (2002) and Braun–Griebel (2009,
Thm 2.14); it is what "Sprecher's version" usually means, and the name
`kolmogorov_arnold_lorentz_sprecher` is deliberately not `_sprecher` alone, to avoid that
reading.

**One point not yet verified against the primary sources.** That the Baire-category proofs
deliver the *factored* Lorentz–Sprecher form, rather than only Lorentz's, rests here on the
Dzhenzher–Skopenkov `n = 2` statement and on secondary descriptions; Hedberg and Kahane have
not yet been read. Layer 1 lifts its definitions from those papers and will settle it. If
they deliver only Lorentz's form, the strongest statement here moves down one rung and the
factored form needs Sprecher's argument.

Departures from the sources, all strengthenings and all deliberate: the inner functions are
stated as continuous on all of `ℝ` rather than on `[0,1]` (extend linearly); the outer
function is continuous on `ℝ` rather than on a compact interval (Tietze); strict
monotonicity of the `ψ_q` in the Lorentz–Sprecher form is not part of the theorem as usually
cited (neither Kolmogorov's statement as given by Braun–Griebel nor Dzhenzher–Skopenkov claims
it) and is included because a Baire route delivers it — among continuous non-decreasing
functions on `[0,1]` the strictly increasing ones are a dense `Gδ`, so a residual set meets
them.

## Provenance

Result selected by George A. Constantinides. The target form was fixed by him against the
sources above; the Lean statements were written by Claude and had a blind read-back before
his read. Nothing here is proved except the two derivations and the sanity checks;
`kolmogorov_arnold_lorentz_sprecher` is `sorry` until Layer 6.

## Sanity checks

The derivations `kolmogorov_arnold_lorentz` and `kolmogorov_arnold` are themselves checks:
they show the Lorentz–Sprecher form is strong enough to yield the forms that are cited. The
`example`s prove the `n = 1` case of the Lorentz–Sprecher form outright, with no appeal to
the `sorry`, which demonstrates that the conjunction of conditions asked for in the
conclusion is satisfiable in a non-degenerate way — the guard an existence statement needs
in place of a
satisfiability witness for hypotheses, of which there are none.

## Relation to Mathlib

Nothing in Mathlib states or approaches this theorem; see the survey in the plan. The
statements use only `Continuous`, `ContinuousOn`, `StrictMono`, `Set.Icc` on `Fin n → ℝ`,
and finite sums.
-/

open Set

namespace KolmogorovArnold

/-- **Kolmogorov–Arnold, Lorentz–Sprecher form.** Positive constants `λ_p` and continuous
strictly increasing `ψ_q : ℝ → ℝ`, depending only on `n`, such that every `f` continuous on
the cube is `∑_q g (∑_p λ_p ψ_q (x_p))` for some continuous `g`. Lorentz's single outer
function and Sprecher's factored inner functions; the strongest statement here and the one
the development proves. `sorry` until Layer 6. -/
theorem kolmogorov_arnold_lorentz_sprecher (n : ℕ) :
    ∃ (lam : Fin n → ℝ) (ψ : Fin (2 * n + 1) → ℝ → ℝ),
      (∀ p, 0 < lam p) ∧
      (∀ q, Continuous (ψ q)) ∧
      (∀ q, StrictMono (ψ q)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ g : ℝ → ℝ, Continuous g ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, g (∑ p, lam p * ψ q (x p)) := by
  sorry

/-- **Kolmogorov–Arnold, Lorentz's form.** Continuous `φ_{q,p} : ℝ → ℝ` depending only on
`n` such that every `f` continuous on the cube is `∑_q Φ (∑_p φ_{q,p} (x_p))` for a single
continuous `Φ`. Lorentz (1962). Derived from the Lorentz–Sprecher form by
`φ_{q,p} := λ_p • ψ_q`. -/
theorem kolmogorov_arnold_lorentz (n : ℕ) :
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : ℝ → ℝ, Continuous Φ ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p)) := by
  obtain ⟨lam, ψ, -, hψc, -, h⟩ := kolmogorov_arnold_lorentz_sprecher n
  exact ⟨fun q p t => lam p * ψ q t, fun q p => continuous_const.mul (hψc q), h⟩

/-- **Kolmogorov–Arnold representation theorem** (Kolmogorov 1957). Continuous
`φ_{q,p} : ℝ → ℝ` depending only on `n` such that every `f` continuous on the cube is
`∑_q Φ_q (∑_p φ_{q,p} (x_p))` for continuous `Φ_q`. The theorem as originally proved and as
usually cited, hence the plain name. Follows from Lorentz's form by taking every `Φ_q` to be
the single `Φ`. -/
theorem kolmogorov_arnold (n : ℕ) :
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : Fin (2 * n + 1) → ℝ → ℝ, (∀ q, Continuous (Φ q)) ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ q (∑ p, φ q p (x p)) := by
  obtain ⟨φ, hφ, h⟩ := kolmogorov_arnold_lorentz n
  refine ⟨φ, hφ, fun f hf => ?_⟩
  obtain ⟨Φ, hΦ, hrep⟩ := h f hf
  exact ⟨fun _ => Φ, fun _ => hΦ, hrep⟩

/-! ## Sanity checks -/

/-- The `n = 1` case of the Lorentz–Sprecher form, proved outright: every inner function the
identity, `λ = 1`, and `g = f ∘ clamp / 3`. Shows the conclusion's conjunction of conditions is
satisfiable without appeal to the `sorry` above. -/
example :
    ∃ (lam : Fin 1 → ℝ) (ψ : Fin (2 * 1 + 1) → ℝ → ℝ),
      (∀ p, 0 < lam p) ∧
      (∀ q, Continuous (ψ q)) ∧
      (∀ q, StrictMono (ψ q)) ∧
      ∀ f : (Fin 1 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ g : ℝ → ℝ, Continuous g ∧
          ∀ x ∈ Icc (0 : Fin 1 → ℝ) 1, f x = ∑ q, g (∑ p, lam p * ψ q (x p)) := by
  refine ⟨fun _ => 1, fun _ => id, fun _ => one_pos, fun _ => continuous_id,
    fun _ => strictMono_id, fun f hf => ?_⟩
  -- Clamp into the cube, so that `f ∘ clamp` is continuous on all of `ℝ`.
  set c : ℝ → (Fin 1 → ℝ) := fun t _ => (projIcc (0 : ℝ) 1 zero_le_one t : ℝ) with hc
  have hc_cont : Continuous c :=
    continuous_pi fun _ => continuous_subtype_val.comp continuous_projIcc
  have hc_maps : ∀ t, c t ∈ Icc (0 : Fin 1 → ℝ) 1 := fun t =>
    ⟨fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.1,
     fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.2⟩
  refine ⟨fun t => f (c t) / 3, (hf.comp_continuous hc_cont hc_maps).div_const 3, ?_⟩
  intro x hx
  have hx0 : x 0 ∈ Icc (0 : ℝ) 1 := ⟨hx.1 0, hx.2 0⟩
  have hcx : c (x 0) = x := by
    funext i
    obtain rfl : i = 0 := Subsingleton.elim i 0
    simp [hc, projIcc_of_mem _ hx0]
  simp only [Fin.sum_univ_one, one_mul, id, hcx, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, nsmul_eq_mul]
  push_cast
  ring

/-- Kolmogorov's form at `n = 2`: the five-term statement that settles the continuous
form of Hilbert's 13th problem. Recorded so the indexing is visibly right: `2 * 2 + 1 = 5`. -/
example :
    ∃ φ : Fin 5 → Fin 2 → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin 2 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : Fin 5 → ℝ → ℝ, (∀ q, Continuous (Φ q)) ∧
          ∀ x ∈ Icc (0 : Fin 2 → ℝ) 1, f x = ∑ q, Φ q (∑ p, φ q p (x p)) :=
  kolmogorov_arnold 2

end KolmogorovArnold
