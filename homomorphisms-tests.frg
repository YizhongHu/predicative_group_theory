#lang forge
open "group-defs.frg"
open "homomorphisms.frg"

test expect {
    -- There's an injective homomorphism from group of #3 to cyclic subgroup of #6.
    mod3toMod6Subg: {
        all G : Group | axioms[G]
        all hom : Homomorphism | {
            validHomomorphism[hom]
            injective[hom]
            (order[hom.domain] = 3) and (order[hom.codomain] = 6)
        }
    } for exactly 1 Homomorphism, exactly 2 Group, 9 Element is sat

    -- There's no injective homomorphism from group of #3 to cyclic subset of #5.
    noMod3toMod5Subg: {
        all G : Group | axioms[G]
        all hom : Homomorphism | {
            validHomomorphism[hom]
            injective[hom]
            (order[hom.domain] = 3) and (order[hom.codomain] = 5)
        }
    } for exactly 1 Homomorphism, exactly 2 Group, 8 Element is unsat
}
