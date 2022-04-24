#lang forge
open "group-defs.frg"
/*------------------------- Group Homomorphisms ---------------------------*/
/*   A group homomorphism is a map between two groups which maintains the  */
/*     algebraic structure of the domain. Formally, for groups G and H,    */
/*       φ: G → H such that for g₁, g₂ ∈ G, φ(g₁ ⋆ g₂) = φ(g₁) ⬝ φ(g₂).     */
sig Homomorphism {
    domain: one Group,
    codomain: one Group,
    mapping: pfunc Element -> Element
}

pred validHomomorphism[hom: Homomorphism] {
    let G = hom.domain, H = hom.codomain, phi = hom.mapping | {
    -- The mapping is from elements of the domain to elements of the codomain.
        all e1, e2 : Element | e1->e2 in phi => (e1 in G.elements and e2 in H.elements)

    -- All elements of the domain are mapped.
        all g : G.elements | some h : H.elements | phi[g] = h

    -- The mapping maintains algebraic structure.
        all g1, g2 : G.elements | {
            phi[G.table[g1, g2]] = H.table[phi[g1], phi[g2]]
        }
    }
}

-- An injective (or one-to-one) homomorphism is one such that each input has a unique output. 
pred injective[hom: Homomorphism] {
    let G = hom.domain, phi = hom.mapping | {
        all g1, g2 : G.elements | {
            phi[g1] = phi[g2] => g1 = g2
        }
    }
}

-- A surjective (or onto) homomorphism is one such that each element of the codomain is in
-- image of the homomorphism.
pred surjective[hom: Homomorphism] {
    let G = hom.domain, H = hom.codomain, phi = hom.mapping | {
        all h : H.elements | {
            some g : G.elements | phi[g] = h
        }
    }
}

-- An isomorphism is a surjective and injective homomorphism. This can be thought of as a
-- relabeling of the elements of the domain; the domain and codomain are the same in all
-- but notation.
pred isomorphism[hom: Homomorphism] {
    injective[hom]
    surjective[hom]
}

-- An endomorphism is a homomorphism from a group to itself. 
pred endomorphism[hom: Homomorphism] {
    hom.domain = hom.codomain
}

-- An automorphism is an isomorphic map from a group to itself.
pred automorphism[hom: Homomorphism] {
    isomorphism[hom]
    endomorphism[hom]
}

-- The kernel of a homomorphism is the set of elements of the domain which are sent
-- to the identity of H.
fun kernel[hom: Homomorphism] : Element {
    let G = hom.domain, H = hom.codomain, phi = hom.mapping | {
        {g : G.elements | phi[g] = identity[H]}
    }
}

-- The image of a homomorphism is the set of elements of the codomain which are
-- hit by the mapping of the domain onto the codomain.
fun image[hom: Homomorphism] : Element {
    let G = hom.domain, H = hom.codomain, phi = hom.mapping | {
        {h : H.elements | {
            some g : G.elements | phi[g] = h
        }}
    }
}

-- The trivial map is the homomorphism that maps all elements of the domain to the
-- identity of the codomain.
pred trivialMap[hom: Homomorphism] {
    image[hom] = identity[hom.codomain]
}

-- Find two non-isomorphic groups
run {
    all G : Group | axioms[G] and order[G] = 6

    all G1, G2 : Group | {
        no hom : Homomorphism {
            hom.domain = G1
            hom.codomain = G2
            isomorphism[hom]
        }
    }

}for exactly 2 Group, exactly 1 Homomorphism, 6 Element

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
    
    -- Not working! Also note: second order quantification so v slow
    -- The preimage of the identity of the codomain is exactly the identity of the
    -- domain for all isomorphisms.
    // isomorphismIffTrivialKer: {
    //     all G : Group | axioms[G]
    //     all hom : Homomorphism | let G = hom.domain {
    //         validHomomorphism[hom] => {
    //             injective[hom] iff (kernel[hom] = identity[G])
    //         }
    //     }
    // } for exactly 1 Homomorphism, exactly 2 Group, 8 Element is theorem

}
// run {
//     all G : Group | axioms[G]
//     all hom : Homomorphism | {
//         validHomomorphism[hom]
//         injective[hom]
//         !kernel[hom] = identity[hom.domain]
//     }
// } for exactly 1 Homomorphism, exactly 2 Group, 9 Element
// run {
//     all G : Group | axioms[G]
//     all hom : Homomorphism | validHomomorphism[hom] and injective[hom] and (order[hom.domain] = 3) and !isomorphism[hom]
// } for exactly 1 Homomorphism, exactly 2 Group, 10 Element

// run {
//     all G : Group | axioms[G]
//     all hom : Homomorphism | validHomomorphism[hom] and !endomorphism[hom] and !trivialMap[hom]
// } for exactly 1 Homomorphism, exactly 2 Group, 10 Element