<img align="right" width="80" height="80" src="https://www.pngpix.com/wp-content/uploads/2016/07/PNGPIX-COM-Rubiks-Cube-Transparent-PNG-Image.png" alt="Rubik's Cube">

# Group Theory
- [What are we modeling?](#what-are-we-modeling)
- [File Structure](#file-structure)
- [Overview](#overview)
- [Visualizers](#visualizers)
- [List of Results](#list-of-results)
- [Todo](#todos)
<img align="right" width="80" height="50" src="https://pluspng.com/img-png/frog-png-hd-frog-png-image-free-download-image-frogs-image-43154-png-frogs-free-2010.png" alt="Froggy :D">

## What are we modeling?

Group theory is a way of connecting and generalizing basic structures in mathematics and nature, especially those seen in 
numbers sets like the integers, geometry, and polynomials. As such, it holds an important role, both in abstract algebra
and a wide array of mathematics. With this in mind, we have two goals:
- Model the notion of a group, and generate different groups using Forge.
- Show basic properties and theorems of groups hold for small-ordered finite groups.

<img align="right" width="80" height="80" src="https://cdn.onlinewebfonts.com/svg/img_131922.png" alt="File Structure">

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

## Overview
### Groups
A **group** (`Group`) is a set (of `Element`) together with a binary operation that acts on the set which satisfies three axioms:
- Identity: (`haveIdentity`) The group contains an element *e* such that for all *g* in the group, *ge = eg = G*.
- Inverse: (`haveInverse`) Each element in the group has an inverse, i.e. for each element *g*, there is a *g^^-1^^* such that 
  *gg^^-1^^ = 1*.
- Associativity: (`associativity`) For all elements g₁, g₂, g₃ ∈ G, it holds that g₁(g₂g₃) = (g₁g₂)g₃.
These axioms bestow a sense of structure to the set. Some common examples of finite groups are the set of integers modulo some number with 
addition, the set of permutations of a set with the operation of doing one permutation after the other, and the set of symmetries of a 
polygon. We'll quickly define some terminology that will prove useful:

<div align="center">
 
| Term        | Forge Pred |                                       Definition                                         | Example                 |
| :---        |    :----:  | :----:                                                                                   |              ---:       |
| Abelian     | `abelian`  | An abelian group is a commutative group, <br/>i.e. g₁ * g₂ = g₂ * g₁ for all g₂, g₁.          | Integers mod 5, +       |
| Cyclic      | `cyclic`   | A cyclic group is a group that can be generated<br/> by one element.                          | Integers mod 5, +       |
| Order       | `order`    | The order of a group *G* (denoted *\|G\|*) is the<br/> number of elements in the group's set. | \|Integers mod 5\| = 5  |
| todo  | ... | ... | ... |
 
</div>

#### Subgroups
talk about what a subgroup is, why useful, how we define in forge : )

#### Generators
talk about generators and Cayley graphs

#### Homomorphisms
A natural next step when dealing with groups might be wondering how different (or secretly the same!) groups relate to each other. This is 
the motivation behind homomorphisms. A **group homomorphism** is a map between two groups which maintains the 
algebraic structure of the domain. Formally, for groups G and H, φ: G → H such that for g₁, g₂ ∈ G, φ(g₁ ⋆ g₂) = φ(g₁) ⬝ φ(g₂). We can classify
homomorphisms based on how they relate their domain and codomain:

<div align="center">

| Term           | Forge Pred    | Definition    |
| :---           |    :----:     |         :---: |
| Monomorphism   | `injective`   | A monomorphism is an injective homomorphism, i.e. one that guarentees<br/> a 1-to-1 mapping.                |
| Epimorphism    | `surjective`  | An epimorphism is a surjective homomorphism, i.e. one such that the <br/> codomain is the image of the map. |
| Isomorphism    | `isomorphism` | An isomorphism is an injective and surjective homomorphism. If there<br/> exists an isomorphism between two groups, then those groups are equal, up to notaion.                                                                                                         |
| Endomorphism   | `endomorphism`| An endomorphism is a homomorphism from a group onto itself.                                                 |
| Automorphism   | `automorphism`| An automorphism is a bijective endomorphism.                                                                |

</div>
 
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
  * [x] visualization for Cayley table
- subgroups.frg
  * [ ] write todo list for subgroups.frg  :)
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
