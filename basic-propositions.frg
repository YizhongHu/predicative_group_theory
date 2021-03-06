#lang forge
open "group-defs.frg"
open "subgroups.frg"
open "generators.frg"
/* ---------------------------- Basic Group Propositions --------------------------- */
/* Here, we show some basic properties of groups that come directly from the axioms. */

-- Tests/Props about groups
test expect {
    -- Every group has only one identity.
    identityUnique: {
            all G : Group | {axioms[G] => one identity[G]}
        } for exactly 1 Group, 6 Element is theorem 

    -- The identity commutes, i.e. i * g = g * i = g.
    identityCommutes: {
        all G : Group | all g : G.elements | {
            axioms[G] => G.table[identity[G], g] = G.table[g, identity[G]]
        }} for exactly 1 Group, 6 Element is theorem

    -- Every element of G has only one inverse.
    inverseUnique: {
        all G : Group | {
            axioms[G] => {all g : G.elements | one rightInverse[g, G]}
    }} for exactly 1 Group, 6 Element is theorem

    -- The inverse commutes, i.e. the left inverse is the same element as the
    -- right inverse.
    inverseCommutes: { 
        all G : Group | {axioms[G] => {
            all g : G.elements | rightInverse[g, G] = leftInverse[g, G]
    }}} for exactly 1 Group, 6 Element is theorem

     //Can run with 8 Elements, takes 30 minutes on our computer
     //Trust us when we say it is sat ;)
    -- Any cyclic group is abelian.
    cyclicGroupsAreAbelian: {
        all G : Group | {(axioms[G] and cyclic[G]) => abelian[G]}
    } for exactly 1 Group, 6 Element is theorem
}

-- Tests/Props about subgroups
test expect {
    -- A subgroup of a group is also abides by the group axioms.
    -- WARNING: THIS TOOK 6 MINS TO RUN ON OUR COMPUTER
    subgroupIsGroup: { all G, H : Group | {
        {axioms[G] and subgroup[H, G]} => axioms[H]
    }} for exactly 2 Group, 6 Element is theorem

    -- The identity of G is in H.
    subgroupsIsClosed: { all G, H : Group | {
        {axioms[G] and subgroup[H, G]} => identity[G] in H.elements
    }} for exactly 2 Group, 6 Element is theorem

    -- The inverse of h is in H. (Implied by axioms)
    subgroupHasInverses: { all G, H : Group | {
        {axioms[G] and subgroup[H, G]} => {all h : H.elements | rightInverse[h, H] in H.elements}
    }} for exactly 2 Group, 6 Element is theorem

    -- Both trivial groups of G (G and {id}) are subgroups of G.
    groupIsSubgroup: { all G : Group | {
        axioms[G] => subgroup[G, G]
    }} for exactly 1 Group, 6 Element is theorem
    identityIsSubgroup: { all G : Group | some e : Group | {
        (axioms[G] and e.elements = identity[G]) => subgroup[e, G]
    }} for exactly 2 Group, 6 Element is theorem
}

-- tests for normal subgroups
test expect {
    GroupIsNormal: { -- G is a normal subgroup of G
        all G : Group {
            axioms[G] => normalSubgroup[G, G]
        }
    } for exactly 1 Group, 6 Element is theorem

    TrivialIsNormal: { -- {e} is a normal subgroup of G
        all G, H : Group {
            (axioms[G] and subgroup[H, G] and trivial[H]) => normalSubgroup[H, G]
        }
    } for exactly 2 Group, 6 Element is theorem

    A3inS3IsNormal: { -- Any normal subgroup of S3 is of order 3 or trivial
        all disj G, H : Group {
            {axioms[G]
            order[G] = 6
            !abelian[G] -- These three describe S???
            normalSubgroup[H, G]} => order[H] != 2
        }
    } for exactly 2 Group, exactly 6 Element is theorem

    AbelianImpliesDedekind: { -- Any abelian group is a Dedekind group
        all G : Group {
            abelian[G] => dedekind[G]
        }
    } for exactly 1 Group, 3 Element is theorem -- have to set element count really low (higher order)
}

-- Lagrange's Theorem: For H a subgroup of G, the order of H divides the
-- order of G.
test expect {
    LagrangesTheorem: { all G, H: Group | {
        {axioms[G] and subgroup[H, G]} => {divides[order[H], order[G]]}}
        } for exactly 2 Group, 7 Element is theorem
}