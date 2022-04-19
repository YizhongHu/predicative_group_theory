#lang forge
/*------------------------- Group Definitions ---------------------------*/
/*   This file defines a group and basic properties about the groups.    */
sig Element {}
sig Group { 
    elements: set Element,
    table: func Element -> Element -> Element
}
 /*--------------------------- Group Axioms ---------------------------*/
-- Axiom 1: Identity
-- For any group G, g ∈ G, there exists an element, id, such that id * g = g.
-- This is called the identity element of G.
fun identity[G: Group]: Element {
    {id: G.elements | {
        all g: G.elements | {
            id->g->g in G.table
            }
        }
    }
}

pred haveIdentity[G: Group] {
    some identity[G]
}

-- Axiom 2: Inverse
-- For any group G, for all elements g ∈ G, there exists a g⁻¹ ∈ G such that g * g⁻¹ = id.
-- The element g⁻¹ is called the inverse of g.
fun rightInverse[g: Element, G: Group]: Element {
    let id = identity[G] | {
        {rInv: G.elements | {g -> rInv -> id in G.table}}
    }
}

fun leftInverse[g: Element, G: Group]: Element {
    let id = identity[G] | {
        {lInv: G.elements | {lInv -> g -> id in G.table}}
    }
}

pred haveInverse[G: Group] {
    all g: G.elements | some rightInverse[g, G]
}

-- Axiom 3: Associativity
-- For all elements g₁, g₂, g₃ ∈ G, it holds that g₁ * (g₂ * g₃) = (g₁ * g₂) * g₃.
pred associativity[G: Group] {
    all g1, g2, g3: G.elements | {
        G.table[G.table[g1, g2], g3] = G.table[g1, G.table[g2, g3]]
    }
}

-- Axiom 4: (Usually Implied) Closedness
-- For all elements g₁, g₂ ∈ G, g₁ * g₂ ∈ G
pred closed[G: Group] {
    G.table in G.elements->G.elements->G.elements
}
 /*--------------------------------------------------------------------*/
  
pred axioms[G: Group] {
    closed[G]
    haveIdentity[G]
    haveInverse[G]
    associativity[G]
}

 /*---------------------- Basic Group Properties -----------------------*/
-- The order of a group is the number of distinct elements in the group.
fun order[G: Group]: Int {
    #{G.elements}
}

-- An abelian group is a commutative group, i.e. g₁ * g₂ = g₂ * g₁.
pred abelian[G: Group] {
    all g1, g2 : G.elements | G.table[g1, g2] = G.table[g2, g1]
}

// pred cyclic[G: Group] {
//     --there's gotta be a better way to write cyclic than with the generators sig
//     // some g : G.elements | all g2 : G.elements - g | {
//     //     g2 in g.(^...) --g2 reachable from G.table[g, g], or something like that
//     // }
// }

pred symmetric[G: Group] {
}

pred permutation[G: Group] {
    --check if it's a permutation group? i need to look at the wikipedia page
    -- before knowing if this is a good idea lol
}
/*--------------------------------------------------------------------*/
