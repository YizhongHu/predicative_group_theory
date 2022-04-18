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

-- The order of a group: The number of distinct elements in a group
fun order[G: Group]: Int {
    #{G.elements}
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

------------------------------------------------------

-- A generating set of a group is a subset of the group set
-- such that every element of the group can be expressed as
-- a combination (under the group operation) of finitely many
-- elements of the subset and their inverses.
one sig Generator {
    generatingSet: set Group->Element
}

-- Constrains the validity of a generating set
pred validGenerator[G: Group] {
    -- The generating set is a subset of the group
    G.(Generator.generatingSet) in G.elements
    -- Every element can be obtained by chaining generator operations (left operations)
    -- from the identity
    let id = identity[G] | {
        G.elements = id.(^((Generator.generatingSet[G]).(G.table)))
    }
}

// run {
//     all G: Group | {
//         axioms[G]
//         validGenerator[G]
//     }
// } for exactly 1 Group, exactly 3 Element

pred wellformed {
    all G: Group | {
        axioms[G]
        validGenerator[G]
    }
}

-- Cyclic group is a group with one generator
pred cyclic[G: Group] {
    one Generator.generatingSet[G]
    // let id = identity[G] | {
    //     some gen: G.elements | {
    //         G.elements in id.^(gen.(G.table))
    //     }
    // }
}

// run {
//     all G: Group | {axioms[G] and cyclic[G]}
// } for exactly 1 Group, exactly 3 Element

test expect {
    cyclicGroupsExist: {{wellformed} =>{
        some G: Group | cyclic[G]
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder4Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 4}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder5Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 5}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder6Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 6}
    }} for exactly 1 Group, 6 Element is sat

    cyclicGroupsAreAbelian: {{wellformed} => {
        all G: Group | { cyclic[G] => abelian[G] }
    }} for exactly 1 Group, 6 Element is theorem
}


---------------------------------------------------


pred subgroup[H: Group, G: Group] {
    H.elements in G.elements
    H.table in G.table
    closed[H]
    haveIdentity[H]
}