#lang forge
open "group-defs.frg"
open "generators.frg"
open "homomorphisms.frg"
open "subgroups.frg"

/* This file contains interesting/informative examples of instances for the visualizers. */

/* ------------------ group-viz.js ------------------ */


// Homomorphisms
run {
    all G : Group | axioms[G]
    all hom : Homomorphism | {
        validHomomorphism[hom]
        injective[hom]
        !kernel[hom] = identity[hom.domain]
    }
} for exactly 1 Homomorphism, exactly 2 Group, 9 Element
run {
    all G : Group | axioms[G]
    all hom : Homomorphism | validHomomorphism[hom] and injective[hom] and (order[hom.domain] = 3) and !isomorphism[hom]
} for exactly 1 Homomorphism, exactly 2 Group, 10 Element
run {
    all G : Group | axioms[G]
    all hom : Homomorphism | validHomomorphism[hom] and !endomorphism[hom] and !trivialMap[hom]
} for exactly 1 Homomorphism, exactly 2 Group, 10 Element



/* ------------------ tiling-viz.js ------------------ */




/* ------------------ quotient-viz.js ------------------ */
-- All instances should make Q isomorphic to C3
run {
    some disj G, N : Group | some Q : QuotientGroup {
        axioms[G]
        validQuotientGroup[Q, N, G]
        order[G] = 6
        !trivial[N]
        !trivial[Q]
        order[Q] = 3
    }
} for exactly 1 QuotientGroup, exactly 3 Group, 12 Element, 4 ResidueClass