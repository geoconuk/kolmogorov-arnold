/-
Copyright (c) 2026 George A. Constantinides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: George A. Constantinides (selection, specification), Claude (formalisation, proof)
-/
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.Order.ProjIcc
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Fin.VecNotation

/-!
# The Kolmogorov–Arnold representation theorem — statement surface

**This file is the target, not a result.** It states the theorems this development exists to
prove, and the one that carries the content is `sorry`. It lives outside the audited library
on purpose — the same arrangement `lean-misc-math` uses for a Palomar Challenge — so that the
audit stays green and meaningful while the layers are built, and so that the statements are
fixed, read and read back *before* several thousand lines are built toward them. When Layer 6
closes the `sorry` these statements move into the library with their proofs; this file then
becomes the Challenge.

Three statements, each implying the next, named for who is credited with the *statement*
(not for the proof route): the Lorentz–Sprecher form, which the proof will establish;
Lorentz's form; and Kolmogorov's, which carries the plain name because it is the theorem as
proved in 1957 and as usually cited. The two implications are proved here, and they are the
whole content of "stronger" at the level of theorems — all three are true, so as closed
propositions they are equivalent, and no claim of strictness between them is made or could be.
What *is* shown, in the sanity checks, is that each refinement is a genuine extra demand on
the inner functions: at `n = 1` there is an inner family that witnesses Kolmogorov's form but
not Lorentz's, and one that witnesses Lorentz's but is not of Lorentz–Sprecher shape.

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
satisfiability witness for hypotheses, of which there are none. Two further `example`s
separate the forms at the level of witnesses: the inner family `(t, 1 − t, 0)` witnesses
Kolmogorov's form but not Lorentz's (a single `Φ` would force `f(0) = f(1)`), and `(t, t, −t)`
witnesses Lorentz's form but is not `λ_p ψ_q` with `λ_p > 0` and `ψ_q` increasing. So the
single outer function and the factored increasing inner functions are each a real constraint,
not a rewording.

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

/-- **Lorentz's form asks more of the inner functions than Kolmogorov's.** At `n = 1` the
inner family `(t, 1 − t, 0)` witnesses Kolmogorov's form — take `Φ₀ = f ∘ clamp` and
`Φ₁ = Φ₂ = 0` — but no single outer function works with it: `Φ(x) + Φ(1 − x) + Φ(0)` takes the
same value at `x = 0` and at `x = 1`, so it cannot represent `f x = x₀`. -/
example : ∃ φ : Fin 3 → Fin 1 → ℝ → ℝ,
    (∀ q p, Continuous (φ q p)) ∧
    (∀ f : (Fin 1 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
      ∃ Φ : Fin 3 → ℝ → ℝ, (∀ q, Continuous (Φ q)) ∧
        ∀ x ∈ Icc (0 : Fin 1 → ℝ) 1, f x = ∑ q, Φ q (∑ p, φ q p (x p))) ∧
    ¬ (∀ f : (Fin 1 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
      ∃ Φ : ℝ → ℝ, Continuous Φ ∧
        ∀ x ∈ Icc (0 : Fin 1 → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p))) := by
  refine ⟨fun q _ t => if q = 0 then t else if q = 1 then 1 - t else 0, ?_, ?_, ?_⟩
  · intro q p
    dsimp only
    split_ifs <;> fun_prop
  · intro f hf
    set c : ℝ → (Fin 1 → ℝ) := fun t _ => (projIcc (0 : ℝ) 1 zero_le_one t : ℝ) with hc
    have hc_cont : Continuous c :=
      continuous_pi fun _ => continuous_subtype_val.comp continuous_projIcc
    have hc_maps : ∀ t, c t ∈ Icc (0 : Fin 1 → ℝ) 1 := fun t =>
      ⟨fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.1,
       fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.2⟩
    refine ⟨fun q t => if q = 0 then f (c t) else 0, ?_, ?_⟩
    · intro q
      by_cases hq : q = 0
      · simp only [hq, if_true]
        exact hf.comp_continuous hc_cont hc_maps
      · simp only [hq, if_false]
        exact continuous_const
    · intro x hx
      have hx0 : x 0 ∈ Icc (0 : ℝ) 1 := ⟨hx.1 0, hx.2 0⟩
      have hcx : c (x 0) = x := by
        funext i
        obtain rfl : i = 0 := Subsingleton.elim i 0
        simp [hc, projIcc_of_mem _ hx0]
      rw [Finset.sum_ite_eq' Finset.univ (0 : Fin 3)]
      simp [hcx]
  · intro h
    obtain ⟨Φ, -, hΦ⟩ := h (fun x => x 0) (continuous_apply 0).continuousOn
    have h0 := hΦ (fun _ => 0) ⟨fun _ => le_rfl, fun _ => zero_le_one⟩
    have h1 := hΦ (fun _ => 1) ⟨fun _ => zero_le_one, fun _ => le_rfl⟩
    simp +decide [Fin.sum_univ_three] at h0 h1
    linarith

/-- **The Lorentz–Sprecher form asks more again.** At `n = 1` the inner family `(t, t, −t)`
witnesses Lorentz's form — a single `Φ` serves every `f` — but it is not of the shape
`λ_p ψ_q` with `λ_p > 0` and `ψ_q` strictly increasing, since `−t` is decreasing. -/
example : ∃ φ : Fin 3 → Fin 1 → ℝ → ℝ,
    (∀ q p, Continuous (φ q p)) ∧
    (∀ f : (Fin 1 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
      ∃ Φ : ℝ → ℝ, Continuous Φ ∧
        ∀ x ∈ Icc (0 : Fin 1 → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p))) ∧
    ¬ ∃ (lam : Fin 1 → ℝ) (ψ : Fin 3 → ℝ → ℝ),
        (∀ p, 0 < lam p) ∧ (∀ q, StrictMono (ψ q)) ∧ ∀ q p t, φ q p t = lam p * ψ q t := by
  refine ⟨fun q _ t => if q = 2 then -t else t, ?_, ?_, ?_⟩
  · intro q p
    dsimp only
    split_ifs <;> fun_prop
  · intro f hf
    set c : ℝ → (Fin 1 → ℝ) := fun t _ => (projIcc (0 : ℝ) 1 zero_le_one t : ℝ) with hc
    have hc_cont : Continuous c :=
      continuous_pi fun _ => continuous_subtype_val.comp continuous_projIcc
    have hc_maps : ∀ t, c t ∈ Icc (0 : Fin 1 → ℝ) 1 := fun t =>
      ⟨fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.1,
       fun _ => (projIcc (0 : ℝ) 1 zero_le_one t).2.2⟩
    -- `Φ t = (f(clamp(max t 0)) − f(0)/3) / 2`: equal to `f(0)/3` for `t ≤ 0`, and on `[0,1]`
    -- `2Φ(t) + Φ(−t) = (f(t) − f(0)/3) + f(0)/3 = f(t)`.
    set f0 : ℝ := f (fun _ => 0) with hf0
    refine ⟨fun t => (f (c (max t 0)) - f0 / 3) / 2, ?_, ?_⟩
    · exact (((hf.comp_continuous hc_cont hc_maps).comp
        (continuous_id.max continuous_const)).sub continuous_const).div_const 2
    · intro x hx
      have hx0 : x 0 ∈ Icc (0 : ℝ) 1 := ⟨hx.1 0, hx.2 0⟩
      have hcx : c (x 0) = x := by
        funext i
        obtain rfl : i = 0 := Subsingleton.elim i 0
        simp [hc, projIcc_of_mem _ hx0]
      have hc0 : c 0 = fun _ => 0 := by
        funext i
        simp [hc]
      have hpos : max (x 0) 0 = x 0 := max_eq_left hx0.1
      have hneg : max (-(x 0)) 0 = 0 := max_eq_right (neg_nonpos.mpr hx0.1)
      simp +decide only [Fin.sum_univ_three, Fin.sum_univ_one, if_true, if_false,
        Fin.isValue]
      rw [hpos, hneg, hcx, hc0, ← hf0]
      ring
  · rintro ⟨lam, ψ, hlam, hψ, h⟩
    have e0 : -(0 : ℝ) = lam 0 * ψ 2 0 := by simpa using h 2 0 0
    have e1 : -(1 : ℝ) = lam 0 * ψ 2 1 := by simpa using h 2 0 1
    have hmono : ψ 2 0 < ψ 2 1 := hψ 2 zero_lt_one
    have hl : 0 < lam 0 := hlam 0
    rw [neg_zero] at e0
    linarith [mul_lt_mul_of_pos_left hmono hl]

end KolmogorovArnold
