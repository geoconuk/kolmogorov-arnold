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

Three statements, in decreasing strength. The first is the form the proof route (Kahane's
Baire-category argument) actually produces; the other two are the forms the literature
cites, and are derived from it here.

## Informal statement

Fix `n`. Write `[0,1]ⁿ` for the closed unit cube.

**Strong form** (`kolmogorov_arnold_lorentz`). There are positive constants `λ₁, …, λₙ` and
continuous strictly increasing functions `ψ₀, …, ψ₂ₙ : ℝ → ℝ`, all depending only on `n`,
such that every function `f` continuous on `[0,1]ⁿ` can be written
`f(x) = ∑_{q=0}^{2n} g(∑_{p=1}^{n} λ_p ψ_q(x_p))` on the cube, for some continuous
`g : ℝ → ℝ` depending on `f`.

**Lorentz form** (`kolmogorov_arnold`). There are continuous `φ_{q,p} : ℝ → ℝ`
(`q = 0, …, 2n`; `p = 1, …, n`) depending only on `n` such that every `f` continuous on
`[0,1]ⁿ` is `f(x) = ∑_{q=0}^{2n} Φ(∑_{p=1}^{n} φ_{q,p}(x_p))` on the cube for some continuous
`Φ : ℝ → ℝ`.

**Kolmogorov's form** (`kolmogorov_arnold_original`). As above but with `2n + 1` outer
functions: `f(x) = ∑_{q=0}^{2n} Φ_q(∑_{p=1}^{n} φ_{q,p}(x_p))`.

In every form the inner functions are quantified **before** `f`: one family serves every
`f`. That is the content of the theorem, and it is what distinguishes these statements from
the weaker `∀ f, ∃ φ` form that the `lean-eval` benchmark poses.

The statements are made for every `n`. The literature states `n ≥ 2`; the cases `n = 0`
and `n = 1` are true and trivial (`n = 1`: take every inner function to be the identity and
`g = f/3`), and the sanity checks below prove `n = 1` directly.

## Source

A. N. Kolmogorov, *On the representation of continuous functions of several variables by
superposition of continuous functions of one variable and addition*, Dokl. Akad. Nauk SSSR
114 (1957) 953–956 — Kolmogorov's form. G. G. Lorentz, *Metric entropy, widths, and
superpositions of functions*, Amer. Math. Monthly 69 (1962) 469–485 — single outer function.
J.-P. Kahane, *Sur le théorème de superposition de Kolmogorov*, J. Approx. Theory 13 (1975)
229–234 — the Baire-category proof, which yields the strong form. The `n = 2` instance of the
strong form is stated as `f(x,y) = ∑_{k=1}^{5} h(φ_k(x) + √2 φ_k(y))` in S. Dzhenzher and
A. Skopenkov, *A structured proof of Kolmogorov's Superposition Theorem*, arXiv:2105.00408.

Departures from the sources, all strengthenings and all deliberate: the inner functions are
stated as continuous on all of `ℝ` rather than on `[0,1]` (extend linearly); the outer
function is continuous on `ℝ` rather than on a compact interval (Tietze); strict
monotonicity of the `ψ_q` in the strong form is not part of the theorem as usually cited
(neither the headline statement nor Dzhenzher–Skopenkov claim it; Sprecher's refinement does)
and is included because the Baire route delivers it — strictly increasing functions are
comeagre among increasing ones.

## Provenance

Result selected by George A. Constantinides. The target form was fixed by him against the
sources above; the Lean statements were written by Claude and had a blind read-back before
his read. Nothing here is proved except the two derivations and the sanity checks;
`kolmogorov_arnold_lorentz` is `sorry` until Layer 6.

## Sanity checks

The derivations `kolmogorov_arnold` and `kolmogorov_arnold_original` are themselves checks:
they show the strong form is strong enough to yield the forms that are cited. The `example`s
prove the `n = 1` case of the strong form outright, with no appeal to the `sorry`, which
demonstrates that the conjunction of conditions asked for in the conclusion is satisfiable
in a non-degenerate way — the guard an existence statement needs in place of a
satisfiability witness for hypotheses, of which there are none.

## Relation to Mathlib

Nothing in Mathlib states or approaches this theorem; see the survey in the plan. The
statements use only `Continuous`, `ContinuousOn`, `StrictMono`, `Set.Icc` on `Fin n → ℝ`,
and finite sums.
-/

open Set

namespace KolmogorovArnold

/-- **Kolmogorov–Arnold, strong form.** Positive constants `λ_p` and continuous strictly
increasing `ψ_q : ℝ → ℝ`, depending only on `n`, such that every `f` continuous on the cube
is `∑_q g (∑_p λ_p ψ_q (x_p))` for some continuous `g`. This is the form Kahane's proof
produces; it is `sorry` until Layer 6. -/
theorem kolmogorov_arnold_lorentz (n : ℕ) :
    ∃ (lam : Fin n → ℝ) (ψ : Fin (2 * n + 1) → ℝ → ℝ),
      (∀ p, 0 < lam p) ∧
      (∀ q, Continuous (ψ q)) ∧
      (∀ q, StrictMono (ψ q)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ g : ℝ → ℝ, Continuous g ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, g (∑ p, lam p * ψ q (x p)) := by
  sorry

/-- **Kolmogorov–Arnold, Lorentz form.** Continuous `φ_{q,p} : ℝ → ℝ` depending only on `n`
such that every `f` continuous on the cube is `∑_q Φ (∑_p φ_{q,p} (x_p))` for a single
continuous `Φ`. Derived from the strong form by `φ_{q,p} := λ_p • ψ_q`. -/
theorem kolmogorov_arnold (n : ℕ) :
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : ℝ → ℝ, Continuous Φ ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p)) := by
  obtain ⟨lam, ψ, -, hψc, -, h⟩ := kolmogorov_arnold_lorentz n
  exact ⟨fun q p t => lam p * ψ q t, fun q p => continuous_const.mul (hψc q), h⟩

/-- **Kolmogorov–Arnold, Kolmogorov's form.** As the Lorentz form but with `2n + 1` outer
functions `Φ_q`. This is the shape usually cited; it follows by taking every `Φ_q` to be the
Lorentz `Φ`. -/
theorem kolmogorov_arnold_original (n : ℕ) :
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : Fin (2 * n + 1) → ℝ → ℝ, (∀ q, Continuous (Φ q)) ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ q (∑ p, φ q p (x p)) := by
  obtain ⟨φ, hφ, h⟩ := kolmogorov_arnold n
  refine ⟨φ, hφ, fun f hf => ?_⟩
  obtain ⟨Φ, hΦ, hrep⟩ := h f hf
  exact ⟨fun _ => Φ, fun _ => hΦ, hrep⟩

/-! ## Sanity checks -/

/-- The `n = 1` case of the strong form, proved outright: every inner function the identity,
`λ = 1`, and `g = f ∘ clamp / 3`. Shows the conclusion's conjunction of conditions is
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

/-- Instantiating the cited form at `n = 2` gives the five-term statement of Hilbert's 13th
problem in its continuous form. Recorded so the indexing is visibly right: `2 * 2 + 1 = 5`. -/
example :
    ∃ φ : Fin 5 → Fin 2 → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin 2 → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : ℝ → ℝ, Continuous Φ ∧
          ∀ x ∈ Icc (0 : Fin 2 → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p)) :=
  kolmogorov_arnold 2

end KolmogorovArnold
