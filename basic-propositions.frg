#lang forge
open "group-defs.frg"
open "subgroups.frg"
/* ---------------------------- Basic Group Propositions --------------------------- */
/* Here, we show some basic properties of groups that come directly from the axioms. */

test expect {
    -- Every group has only one identity.
    identityUnique: {
            all G: Group | {axioms[G] => one identity[G]}
        } for exactly 1 Group, 6 Element is theorem 

    -- The identity commutes, i.e. i * g = g * i = g.
    identityCommutes: {
        all G: Group | all g : G.elements | {
            axioms[G] => G.table[identity[G], g] = G.table[g, identity[G]]
        }} for exactly 1 Group, 6 Element is theorem

    -- Every element of G has only one inverse.
    inverseUnique: {
        all G: Group | {
            axioms[G] => {all g: G.elements | one rightInverse[g, G]}
    }} for exactly 1 Group, 6 Element is theorem

    -- The inverse commutes, i.e. the left inverse is the same element as the
    -- right inverse.
    inverseCommutes: { 
        all G: Group | {axioms[G] => {
            all g: G.elements | rightInverse[g, G] = leftInverse[g, G]
    }}} for exactly 1 Group, 6 Element is theorem

    -- Can run with 8 Elements, takes 30 minutes on our computer
    -- Trust us when we say it is sat
    -- Any cyclic group is abelian.
    -- NOTE: failing temporarily, since cyclic not defined in group-defs.frg yet
    cyclicGroupsAreAbelian: {
        all G: Group | {(axioms[G] and cyclic[G]) => abelian[G]}
    } for exactly 1 Group, 6 Element is theorem

    -- A subgroup of a group is also abides by the group axioms.
    subgroupIsGroup: { all G, H: Group | {
        {axioms[G] and subgroup[H, G]} => axioms[H]
    }} for exactly 2 Group, 6 Element is theorem

}

--TODO here:
--Simple propositions/preds that we can show hold true for subgroups: Let H be a subgroup.

-- For each h₁, h₂ ∈ H, h₁h₂ ∈ H b. 
-- e ∈ H c. 
-- if h ∈ H, then h⁻¹ ∈ H d. 
-- G and {e} are subgroups
