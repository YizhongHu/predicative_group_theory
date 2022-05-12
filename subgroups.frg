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
    some c : Int | {
        c > 0 and c <= b
        multiply[a, c] = b
    }
}

/*-------------------------------- Cosets --------------------------------*/
/*       The left coset of a subgroup H of G and some element a is        */
/*          aH = {ah : h in H}. The right coset is similar: Ha.           */

-- This function assumes: a is an element of G and H is a subgroup of G
fun leftCoset[a: Element, H, G: Group]: Element {
    {g : G.elements | some h : H.elements | G.table[a, h] = g}
}

-- This function assumes: a is an element of G and H is a subgroup of G
fun rightCoset[a: Element, H, G: Group]: Element {
    {g : G.elements | some h : H.elements | G.table[h, a] = g}
}

/*---------------------------- Normal Subgroups ----------------------------*/
/*   A normal subgroup of a group is one in which for all h ∈ H and g ∈ G,  */
/*                                ghg⁻¹ ∈ H.                                */

pred normalSubgroup[H, G: Group] {
    subgroup[H, G]
    all g : G.elements | all h : H.elements {
        G.table[G.table[g, h], rightInverse[g, G]] in H.elements
    }
}

-- A simple group G is a group with only G and {id} as its normal subgroups
pred simple[G: Group] {
    all H : Group | {
        (subgroup[H, G] and !trivial[H] and H.elements != G.elements) =>
            !normalSubgroup[H, G]
    }
}

-- A Dedekind group has only normal groups as subgroups
pred dedekind[G: Group] {
    all H : Group | {
        subgroup[H, G] => normalSubgroup[H, G]
    }
}

/*----------------------------- Quotient Groups ------------------------------*/
/* Let G be a group, and N a normal subgroup of G. Our goal is to create a    */
/* new group from G without necessarily creating a subgroup. What we can do   */
/* is take N and all (left) cosets of N, and aggregate them into a new set Q. */
/* We can then define the operation on Q to be (aN)(bN) = (ab)N. This happens */
/* to bestow a group structure on Q, so long as N is normal.                  */

sig ResidueClass extends Element {
    residues: set Element
}

sig QuotientGroup extends Group {}

pred validQuotientGroup[Q: QuotientGroup, N: Group, G: Group] {
    normalSubgroup[N, G]             -- N is a normal subgroup of G
    Q.elements in ResidueClass       -- Quotient Group only has residues as els
    residues in ResidueClass->G.elements
    no r : ResidueClass | r in G.elements
    no r : ResidueClass | !(r in Q.elements)
    no G.elements & Q.elements    -- No element of G is a residue class 
    ResidueClass.residues in Element -- Residues only have elements (not other residues)
    all a : G.elements | {           -- Each residue corresponds to a coset
        some res : Q.elements {
            res.residues = leftCoset[a, N, G]
        }
    }
    all res : Q.elements | {           -- Each coset corresponds to a residue class
        some a : G.elements {
            res.residues = leftCoset[a, N, G]
        }
    }
    all r1, r2, r3 : ResidueClass | { -- Operation of Q defined by G
        r1->r2->r3 in Q.table iff {
            some e1 : r1.residues |
            some e2 : r2.residues |
            some e3 : r3.residues |
            e1->e2->e3 in G.table
        }
    }
    closed[Q]
}