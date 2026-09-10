/-
Copyright (c) 2026 George A. Constantinides. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: George A. Constantinides (selection, specification), Claude (formalisation, proof)
-/
import KolmogorovArnold.Theorem

/-!
# The Target statements agree with the library

`Target/Roof.lean` states the three theorems this development exists to prove, fixed and read
before any layer was built, and keeps them as a statement surface — the strongest with `sorry`,
the arrangement `lean-misc-math` uses for a Palomar Challenge. `KolmogorovArnold/Theorem.lean`
proves them. Two copies of a statement can drift apart; each `example` below ascribes a type
**copied by hand from `Target/Roof.lean`** to the theorem the library ships, so that a library
statement that has moved away from the fixed target fails to build here.

The limit of that is worth stating: this module never reads `Target/Roof.lean`, so an edit made
there and nowhere else is invisible here, and an identical wrong edit in both places would pass.
What it catches is the library drifting from the target it was built toward. Every `example`
must elaborate and none may use `sorry`, since each asserts a real theorem of the library.

Outside `KolmogorovArnold/` on purpose, like `Target/Roof.lean`, so it reaches neither the audit
nor the three checks; build it with `lake build TargetTypeCheck`.
-/

open Set

example : ∀ n : ℕ,
    ∃ (lam : Fin n → ℝ) (ψ : Fin (2 * n + 1) → ℝ → ℝ),
      (∀ p, 0 < lam p) ∧
      (∀ q, Continuous (ψ q)) ∧
      (∀ q, StrictMono (ψ q)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ g : ℝ → ℝ, Continuous g ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, g (∑ p, lam p * ψ q (x p)) :=
  KolmogorovArnold.kolmogorov_arnold_lorentz_sprecher

example : ∀ n : ℕ,
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      (∀ q p, Monotone (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : ℝ → ℝ, Continuous Φ ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ (∑ p, φ q p (x p)) :=
  KolmogorovArnold.kolmogorov_arnold_lorentz

example : ∀ n : ℕ,
    ∃ φ : Fin (2 * n + 1) → Fin n → ℝ → ℝ,
      (∀ q p, Continuous (φ q p)) ∧
      ∀ f : (Fin n → ℝ) → ℝ, ContinuousOn f (Icc 0 1) →
        ∃ Φ : Fin (2 * n + 1) → ℝ → ℝ, (∀ q, Continuous (Φ q)) ∧
          ∀ x ∈ Icc (0 : Fin n → ℝ) 1, f x = ∑ q, Φ q (∑ p, φ q p (x p)) :=
  KolmogorovArnold.kolmogorov_arnold
