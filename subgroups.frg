#lang forge
open "group-defs.frg"
/*------------------------------ Subgroups ------------------------------*/
/*-------------- Cosets, Normal Subgroups, Quotient Groups --------------*/
/* Here, we define a subgroup of a group, and introduce the notion of    */
/* cosets, normal subgroups, and quotient groups, which allow us to      */
/*    compare applications of Lagrange's Theorem to proofs of it.        */

-- We'll let H be a subset of G if all elements of H are in G and H uses
-- the operation of G.
pred subset[H: Group, G: Group] {
    some H.elements -- non-trivial subset!
    H.elements in G.elements
    H.table in G.table
}

-- A subgroup H of a group G is a group whose elements are all in G and
-- whose operation (values of Cayley table) is identical to that of G.
pred subgroup[H: Group, G: Group] {
    subset[H, G]
    closed[H]
    haveInverse[H]
}

-- Be careful: may not work if not enough Int,
-- e.g., by default !divides[2, 8], unless Int is
-- set up to like 10
pred divides[a: Int, b: Int] {
    a <= b
    a > 0
    some c: Int | {
        c > 0 and c <= b
        multiply[a, c] = b
    }
}

-- Lagrange's Theorem: For H a subgroup of G, the order of H divides the
-- order of G.
test expect {
    LagrangesTheorem: { all G, H: Group | {
        {axioms[G] and subgroup[H, G]} => {divides[order[H], order[G]]}}
        } for exactly 2 Group, 7 Element is theorem
}

/*-------------------------------- Cosets --------------------------------*/
/*       The left coset of a subgroup H of G and some element a is        */
/*          aH = {ah : h in H}. The right coset is similar: Ha.           */

-- This function assumes: a is an element of G and H is a subgroup of G
fun leftCoset[a : Element, H, G : Group]: Element {
    {g : G.elements | all h : H.elements | G.table[a, h] = g}
}

-- This function assumes: a is an element of G and H is a subgroup of G
fun rightCoset[a: Element, H, G: Group]: Element {
    {g : G.elements | all h : H.elements | G.table[h, a] = g}
}

/*---------------------------- Normal Subgroups ----------------------------*/
/*   A normal subgroup of a group is one in which for all h ∈ H and g ∈ G,  */
/*                                ghg⁻¹ ∈ N.                                */
/* There are many equivalent definitions for normal subgroups, but we find  */
/*    comparing the left and right cosets to be a well-suited balance of    */
/*  efficient and relevant. Specifically, the coset definition of a normal  */
/*   subgroup is: a subgroup H of G is normal if and only if forall a ∈ G,  */
/*                                 aH = Ha.                                 */
// pred normalSubgroup[H, G: Group] {
//     subgroup[H, G]
//     all a: G.elements | {
//         leftCoset[a, H, G] = rightCoset[a, H, G]
//     }
// }

pred normalSubgroup[H, G: Group] {
    subgroup[H, G]
    all g : G.elements | all h : H.elements {
        G.table[G.table[g, h], rightInverse[g, G]] in H.elements
    }
}

-- A simple group has only normal groups as subsets
pred simple[G : Group] {
    all H : Group | {
        subgroup[H, G] => normalSubgroup[H, G]
    }
}

// sig QuotientGroup extends Group {
//     cosets: set Element -> Element
// }


// pred validLeftQuotientGroup[Q: QuotientGroup, H: Group, G: Group] {
//     subgroup[H, G]
//     subgroup[Q, G]
//     all q: Q.elements | {
//         leftCoset[q, H] = Q.cosets[q]
//     }
// }

// run {
//     some Q: QuotientGroup, H: Group, G: Group | {
//         axioms[G]
//         validLeftQuotientGroup[Q, H, G]
//     }
// } for exactly 3 Group, 6 Element

// run {
//     all G: Group | axioms[G] and not abelian[G]
// } for exactly 1 Group, exactly 6 Element