#lang forge
open "group-defs.frg"
/*------------------------------ Subgroups ------------------------------*/
/*-------------- Cosets, Normal Subgroups, Quotient Groups --------------*/
/* Here, we define a subgroup of a group, and introduce the notion of    */
/* cosets, normal subgroups, and quotient groups, which allow us to      */
/*    compare applications of Lagrange's Theorem to proofs of it.        */

-- A subgroup H of a group G is a group whose elements are all in G and
-- whose operation (values of Cayley table) is identical to that of G.
pred subgroup[H: Group, G: Group] {
    H.elements in G.elements
    H.table in G.table
    closed[H]
    identity[G] in H.elements
}

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
    LagrangesTheorem: { all G, H: Group | {axioms[G] and subgroup[H, G]} => {
        divides[order[H], order[G]]
    }} for exactly 2 Group, 6 Element is theorem
}

sig QuotientGroup extends Group {
    cosets: set Element -> Element
}

fun leftCoset[g: Element, G: Group]: Element {
    (G.elements).(g.(G.table))
}

fun rightCoset[g: Element, G: Group]: Element {
    g.((G.elements).(G.table))
}

pred validLeftQuotientGroup[Q: QuotientGroup, H: Group, G: Group] {
    subgroup[H, G]
    subgroup[Q, G]
    all q: Q.elements | {
        leftCoset[q, H] = Q.cosets[q]
    }
}

run {
    some Q: QuotientGroup, H: Group, G: Group | {
        axioms[G]
        validLeftQuotientGroup[Q, H, G]
    }
} for exactly 3 Group, 6 Element

pred normalSubgroup[H, G: Group] {
    subgroup[H, G]
    all g1, g2: G.elements | {
        leftCoset[g2, H].(leftCoset[g1, H].(G.table)) = leftCoset[G.table[g1, g2], H]
    }
}

run {
    all G: Group | axioms[G] and not abelian[G]
} for exactly 1 Group, exactly 6 Element