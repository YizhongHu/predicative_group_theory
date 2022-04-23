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

run {
    all G : Group | axioms[G]
    all hom : Homomorphism | validHomomorphism[hom] and injective[hom] and (order[hom.domain] = 3) and !isomorphism[hom]
} for exactly 1 Homomorphism, exactly 2 Group, 10 Element

run {
    all G : Group | axioms[G]
    all hom : Homomorphism | validHomomorphism[hom] and !endomorphism[hom] and !trivialMap[hom]
} for exactly 1 Homomorphism, exactly 2 Group, 10 Element