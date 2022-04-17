#lang forge

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
pred haveInverse[G: Group] {
    let id = identity[G] | {
        all g: G.elements | {
            some gInv: G.elements | {
                g -> gInv -> id in G.table
            }
        }
    }
}

-- Axiom 3: Associativity
-- For all elements g₁, g₂, g₃ ∈ G, it holds that g₁ * (g₂ * g₃) = (g₁ * g₂) * g₃.
pred associativity[G: Group] {
    all g1, g2, g3: G.elements | {
        G.table[G.table[g1, g2], g3] = G.table[g1, G.table[g2, g3]]
    }
}
  /*--------------------------------------------------------------------*/
  
pred closed[G: Group] {
    G.table in G.elements->G.elements->G.elements
}

pred axioms[G: Group] {
    closed[G]
    haveIdentity[G]
    haveInverse[G]
    associativity[G]
}

-- An abelian group is a commutative group, i.e. g₁ * g₂ = g₂ * g₁.
pred abelian[G: Group] {
    all g1, g2 : G.elements | G.table[g1, g2] = G.table[g2, g1]
}

// limiting to 4 element groups for now?
test expect {
    uniqueIdentity: { all G: Group | { axioms[G] => one identity[G] } } for exactly 1 Group, 4 Element is theorem 
    identityCommutes: {
        all G: Group | all g : G.elements | {
            axioms[G] => G.table[identity[G], g] = G.table[g, identity[G]]
            }} for exactly 1 Group, 4 Element is theorem
}

// run {
//     all G: Group | axioms[G]
// } for exactly 1 Group, exactly 5 Element


pred subgroup[H: Group, G: Group] {
    H.elements in G.elements
    H.table in G.table
    closed[H]
    haveIdentity[H]
}