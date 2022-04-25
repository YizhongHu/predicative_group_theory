# Group Theory
- [What are we modeling?](#what-are-we-modeling)
- [File Structure](#file-structure)
- [List of Results](#list-of-results)
- [Todo](#todos)
## What are we modeling?

Group theory is a way of connecting and generalizing basic structures in mathematics and nature, especially those seen in 
numbers sets like the integers, geometry, and polynomials. As such, it holds an important role, both in abstract algebra
and a wide array of mathematics. With this in mind, we have two goals:
- Model the notion of a group, and generate different groups using Forge.
- Show basic properties and theorems of groups hold for small-ordered finite groups.

## File Structure
Definitions<br/>
- [Group Definitions](https://github.com/YizhongHu/final_project/blob/master/group-defs.frg)
  * [Subgroups](https://github.com/YizhongHu/final_project/blob/master/subgroups.frg)
  * [Generators](https://github.com/YizhongHu/final_project/blob/master/generators.frg)
  * [Homomorphisms](https://github.com/YizhongHu/final_project/blob/master/homomorphisms.frg)
 
Propositions, Lemmas, and Theorems<br/>
- [Basic Propositions](https://github.com/YizhongHu/final_project/blob/master/basic-propositions.frg)

Testing<br/>
- [Tests](https://github.com/YizhongHu/final_project/blob/master/group-tests.frg)

## Visualizers
To make understanding Forge's output easier, we've included two visualizers:
- [Cayley Table Visualizer](https://github.com/YizhongHu/final_project/blob/master/visualization/group-viz.js)<br/>
  This visualizer displays the Cayley table of all groups in the instance. The output is read as the cell in row *i* 
  and column *j* is *i ⬝ j*. At the top of the script, there are two variables the user can manually change: the 
  `DISPLAY_TYPE` and `COLOR_SCHEME` variables. Setting the former to `"colors"` removes the letters and replaces them 
  with colored rectangles, where each element has a unique color. Changing `COLOR_SCHEME` to `"normal"`, `"pastel"`, 
  `"ruby"`, or `"sandstone"` changes the color scheme. The following are some example outputs:<br/>
 <p align="center">
  <img src="visualization/CayleyTableEx.png" alt="The Cayley Table of the Group (C__2 x C__2)" width="200"/>
  <img src="visualization/TwoColorEx.png" alt="Two Groups as Colored Cayley Tables" width="100"/>
 <p/>
 
- [Cayley Tile Visualizer](https://github.com/YizhongHu/final_project/blob/master/visualization/tiling-viz.js)<br/>
  This visualizer displays a tiling of the colored Cayley table. Specifically, the colored Cayley table is reflected twice 
  to get a 2-table-by-2-table block, which is then translated across the plane. The user can manually change the `COLOR_SCHEME` 
  variable to change the color scheme, and the `SCALE` variable to zoom in and out. The following are some cool example outputs:<br/>
  <p align="center">
   <img src="visualization/ExampleTiling1.png" alt="Some Tiling of Group of Order 4" width="200"/>
  <img src="visualization/ExampleTiling2.png" alt="Some Tiling of Group of Order 8" width="200"/>
  <img src="visualization/ExampleTiling3.png" alt="Some Tiling of Group of Order 8" width="200"/>
 <p/>
  

## List of Results
The following is a list of propositions, lemmas, and theorems that we've "proved" to hold (at least for finite
groups of low order). Let *G* be a group, *H* a subgroup, *g*, *gᵢ* ∈ *G*, *h*, *hᵢ* ∈ *H*.

### Small propositions
- *G* has only one identity element.
- The identity element commutes.
- For all *g*, *g⁻¹* is unique.
- The inverse of *g* commutes with *g*.
- All subgroups are groups.
- All subgroups are closed.
- The identity of *G* is in *H*.
- If *h ∈ H*, then *h⁻¹ ∈ H*.
- *G* and *{id}* are subgroups of *G*.

### Lemmas
- All cyclic groups are abelian.

### Theorems
- Lagrange's Theorem: |H| divides |G|
## TODOs
Updated 4.23.22
- group-defs.frg
  * [ ] symmetric pred
  * [ ] permutation pred
  * [ ] (maybe) simpler cyclic pred
  * [ ] visualization for Cayley table
- subgroups.frg
  * [ ] write todo list for subgroups.frg
- generators.frg
  * [ ] tests + examples
  * [ ] visualization for Cayley graph
- homomorphisms.frg
  * [ ] fix inj <=/=> ker = {id} issue
  * [ ] tests + examples
  * [ ] visualization
  * [ ] look into showable theorems
- overall
  * [ ] think about optimization?
  * [ ] dip our toes into rings?
  * [ ] refactor and fix tests

<!-- - [x] Write predicates representing the group axioms: identity, inverse, associativity. Then write
   predicates that represent useful properties: abelian, cyclic, symmetric, permutation groups
- [x] Simple propositions/preds that we can show hold true:
    a. The identity element is unique
    b. Each element has only one inverse
    c. If g, h ∈ G, then (gh)⁻¹ = h⁻¹g⁻¹
    d. If g ∈ G, then (g⁻¹)⁻¹ = g
- [ ] [If we have time] homomorphisms - a lot comes out of group isomorphisms
- [x] Define subgroups
- [x] Simple propositions/preds that we can show hold true for subgroups:
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
      exists a subgroup S ⊆ G such that |S| = pⁿ -->
