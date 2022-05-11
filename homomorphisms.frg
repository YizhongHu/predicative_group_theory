#lang forge
open "group-defs.frg"
open "generators.frg"
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
        phi in G.elements -> H.elements

    -- All elements of the domain are mapped.
        all g : G.elements | some g.phi

    -- The mapping maintains algebraic structure.
        all g1, g2 : G.elements | {
            phi[G.table[g1, g2]] = H.table[phi[g1], phi[g2]]
        }
    }
}

-- An injective (or one-to-one) homomorphism is one such that each input has a unique output. 
pred injective[hom: Homomorphism] {
    let H = hom.codomain, phi = hom.mapping | {
        all h : H.elements | lone phi.h
    }
}

-- A surjective (or onto) homomorphism is one such that each element of the codomain is in
-- image of the homomorphism.
pred surjective[hom: Homomorphism] {
    let H = hom.codomain, phi = hom.mapping | {
        all h : H.elements | some phi.h
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
    let H = hom.codomain, phi = hom.mapping | phi.(identity[H])
}

-- The image of a homomorphism is the set of elements of the codomain which are
-- hit by the mapping of the domain onto the codomain.
fun image[hom: Homomorphism] : Element {
    let G = hom.domain, phi = hom.mapping | (G.elements).phi
}

-- The trivial map is the homomorphism that maps all elements of the domain to the
-- identity of the codomain.
pred trivialMap[hom: Homomorphism] {
    image[hom] = identity[hom.codomain]
}
