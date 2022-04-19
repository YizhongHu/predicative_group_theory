# Group Theory
- [What are we modeling?](#what-are-we-modeling)
- [File Structure](#files)
- [Todo](#todos)
## What are we modeling?

Group theory is a way of connecting and generalizing basic structures in mathematics and nature, especially those seen in 
numbers sets like the integers, geometry, and polynomials. As such, it holds an important role, both in abstract algebra
and a wide array of mathematics. With this in mind, we have two goals:
- Model the notion of a group, and generate different groups using Forge.
- Show basic properties and theorems of groups hold for small-ordered finite groups.

## Files
Definitions<br/>
- [Group Definitions](https://github.com/YizhongHu/final_project/blob/master/group-defs.frg)
  * [Subgroups](https://github.com/YizhongHu/final_project/blob/master/subgroups.frg)
  * [Generators] (https://github.com/YizhongHu/final_project/blob/master/generators.frg)
Propositions, Lemmas, and Theorems<br/>
- [Basic Propositions](https://github.com/YizhongHu/final_project/blob/master/basic-propositions.frg)
Testing<br/>
- [Tests](https://github.com/YizhongHu/final_project/blob/master/group-tests.frg)

## TODOs

- [x] Write predicates representing the group axioms: identity, inverse, associativity. Then write
   predicates that represent useful properties: abelian, cyclic, symmetric, permutation groups
- [ ] Simple propositions/preds that we can show hold true:
    a. The identity element is unique
    b. Each element has only one inverse
    c. If g, h ∈ G, then (gh)⁻¹ = h⁻¹g⁻¹
    d. If g ∈ G, then (g⁻¹)⁻¹ = g
- [ ] [If we have time] homomorphisms - a lot comes out of group isomorphisms
- [x] Define subgroups
- [ ] Simple propositions/preds that we can show hold true for subgroups:
    Let H be a subgroup
    a. For each h₁, h₂ ∈ H, h₁h₂ ∈ H
    b. e ∈ H
    c. if h ∈ H, then h⁻¹ ∈ H
    d. G and {e} are subgroups
- [ ] Theorems
  • Lagrange's Theorem: If H ⊂ G is a subgroup, then the order of H divides G, i.e. |H| | |G|
  • If G is a finite group of order p² for some prime number p, then G is abelian
  • If Sₙ is the permutation group of {1,...,n}, then for n ≥ 3, Sₙ is non-abelian
  • First Sylow Theorem: If G is a finite group such that pⁿ | |G| for a prime p, then there
      exists a subgroup S ⊆ G such that |S| = pⁿ