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
fun rightInverse[g: Element, G: Group]: Element {
    let id = identity[G] | {
        {gInv: G.elements | {g -> gInv -> id in G.table}}
    }
}

fun leftInverse[g: Element, G: Group]: Element {
    let id = identity[G] | {
        {gInv: G.elements | {gInv -> g -> id in G.table}}
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

-- The order of a group: The number of distinct elements in a group
fun order[G: Group]: Int {
    #{G.elements}
}

-- An abelian group is a commutative group, i.e. g₁ * g₂ = g₂ * g₁.
pred abelian[G: Group] {
    all g1, g2 : G.elements | G.table[g1, g2] = G.table[g2, g1]
}

// limiting to 6 element groups for now?
test expect {
    identityUnique: { all G: Group | { axioms[G] => one identity[G] } } for exactly 1 Group, 6 Element is theorem 
    identityCommutes: {
        all G: Group | all g : G.elements | {
            axioms[G] => G.table[identity[G], g] = G.table[g, identity[G]]
            }} for exactly 1 Group, 6 Element is theorem
    
    inverseUnique: { all G: Group | { axioms[G] => {
        all g: G.elements | one rightInverse[g, G]
    }}} for exactly 1 Group, 6 Element is theorem
    inverseCommutes: { all G: Group | { axioms[G] => {
        all g: G.elements | rightInverse[g, G] = leftInverse[g, G]
    }}} for exactly 1 Group, 6 Element is theorem
}

------------------------------------------------------

-- A generating set of a group is a subset of the group set
-- such that every element of the group can be expressed as
-- a combination (under the group operation) of finitely many
-- elements of the subset and their inverses.
one sig Generator {
    generatingSet: set Group->Element,
    graph: pfunc Group->Element->Element->Element
}

-- Constrains the validity of a generating set
pred validGenerator[G: Group] {
    let id = identity[G], generator = (Generator.generatingSet[G]) | {
        -- Every element can be obtained by chaining generator operations (left operations)
        -- from the identity
        G.elements = id.(^(generator.(G.table)))

        -- ensure that it is a minimal generating set
        -- i.e. A generator cannot reach anther generator through some series of generator
        -- operations
        no gen: generator | {
            some (((generator - gen)->gen) & ^((generator - gen).(G.table)))
        }

        -- Constrain the Cayley Graph
        Generator.graph[G] = (generator->G.elements->G.elements & G.table)
    }
}

pred wellformed {
    all G: Group | {
        axioms[G]
        validGenerator[G]
    }
}

// run {
//     wellformed
// } for exactly 1 Group, exactly 2 Element

example TrvialGroup is {wellformed} for {
    Group = `G0
    Element = `E0
    elements = `G0-> `E0
    table = `G0->`E0->`E0->`E0

    Generator = `Generator0
}

example CyclicGroupOfOrder2 is {wellformed} for {
    Group = `G0
    Element = `E0 + `E1
    elements = `G0-> `E0 + `G0 -> `E1
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1
    graph = `Generator0->`G0->`E1->`E0->`E1 + `Generator0->`G0->`E1->`E1->`E0 
}

example CyclicGroupOfOrder3 is {wellformed} for {
    Group = `G0
    Element = `E0 + `E1 + `E2
    elements = `G0-> `E0 + `G0 -> `E1 + `G0 -> `E2
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E2 
          + `G0->`E0->`E2->`E2 + `G0->`E1->`E2->`E0 + `G0->`E2->`E2->`E1 + `G0->`E2->`E0->`E2 
          + `G0->`E2->`E1->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1
    graph = `Generator0->`G0->`E1->`E0->`E1 + `Generator0->`G0->`E1->`E1->`E2 +    
            `Generator0->`G0->`E1->`E2->`E0 
}

example C2byC2 is {wellformed} for {
    Group = `G0
    Element = `E0 + `E1 + `E2 + `E3
    elements = `G0-> `E0 + `G0 -> `E1 + `G0 -> `E2 + `G0 -> `E3
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E0->`E2->`E2 + `G0->`E0->`E3->`E3
          + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E0 + `G0->`E1->`E2->`E3 + `G0->`E1->`E3->`E2 
          + `G0->`E2->`E0->`E2 + `G0->`E2->`E1->`E3 + `G0->`E2->`E2->`E0 + `G0->`E2->`E3->`E1 
          + `G0->`E3->`E0->`E3 + `G0->`E3->`E1->`E2 + `G0->`E3->`E2->`E1 + `G0->`E3->`E3->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1 + `Generator0->`G0->`E2
    graph = `Generator0->`G0->`E1->`E0->`E1 + `Generator0->`G0->`E1->`E1->`E0 +               
            `Generator0->`G0->`E1->`E2->`E3 + `Generator0->`G0->`E1->`E3->`E2 + 
            `Generator0->`G0->`E2->`E0->`E2 + `Generator0->`G0->`E2->`E1->`E3 + 
            `Generator0->`G0->`E2->`E2->`E0 + `Generator0->`G0->`E2->`E3->`E1
}


test expect {
    cayleyGraphEdgeUnique: {{wellformed} => {all G: Group | {
        all g1, g2: G.elements | lone (Generator.graph[G]).g1.g2
    }}} for exactly 1 Group, 6 Element is theorem

    cayleyGraphConnected: {{wellformed} => {all G: Group | {
        let generator = (Generator.generatingSet[G]) | {
            let edges = generator.(Generator.graph[G]) | {
                ((G.elements)->(G.elements) - iden) in ^(edges + (~edges))
            }
        }
    }}} for exactly 1 Group, 6 Element is theorem
}

-- Cyclic group is a group with one generator
pred cyclic[G: Group] {
    let id = identity[G] | {
        some gen: G.elements | {
            G.elements in id.^(gen.(G.table))
        }
    }
}
-- An alternative definition of cyclic groups
pred cyclicAlternative[G: Group] {
    one Generator.generatingSet[G]
}

// run {
//     wellformed
//     some G: Group | {
//         cyclic[G]
//         not cyclicAlternative[G]
//     }
// } for exactly 1 Group, 6 Element 

test expect {
    -- This is a test for generating set
    cyclicDefinitionsEquivalentForward: {{wellformed} => {all G: Group | {
        cyclicAlternative[G] => cyclic[G]
    }}} for exactly 1 Group, 6 Element is theorem

    -- Unfortunately the other direction does not satisfy
    cyclicDefinitionsEquivalentBackward: {
        wellformed
        some G: Group | {
            cyclic[G]
            not cyclicAlternative[G]
        }
    } for exactly 1 Group, 6 Element is sat
}

// run {
//     all G: Group | {axioms[G] and cyclic[G]}
// } for exactly 1 Group, exactly 3 Element

test expect {
    cyclicGroupsExist: {{wellformed} =>{
        some G: Group | cyclic[G]
    }} for exactly 1 Group, 6 Element is sat
    trivialGroupCyclic: {{wellformed} =>{
        all G: Group | cyclic[G]
    }} for exactly 1 Group, 1 Element is theorem
    cyclicGroupsOrder4Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 4}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder5Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 5}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder6Exist: {{wellformed} =>{
        some G: Group | {cyclic[G] and order[G] = 6}
    }} for exactly 1 Group, 6 Element is sat

    -- Can run with 8 Elements, takes 30 minutes on our computer
    -- Trust us when we say it is sat
    cyclicGroupsAreAbelian: {{wellformed} => {
        all G: Group | { cyclic[G] => abelian[G] }
    }} for exactly 1 Group, 6 Element is theorem
}


---------------------------------------------------


pred subgroup[H: Group, G: Group] {
    H.elements in G.elements
    H.table in G.table
    closed[H]
    identity[G] in H.elements
}

// test expect {
//     subgroupIsGroup: { all G, H: Group | {
//         { axioms[G] and subgroup[H, G]} => { axioms[H] }
//     }} for exactly 2 Group, 6 Element is theorem
// }

pred divides[a: Int, b: Int] {
    a <= b
    a > 0
    some c: Int | {
        c > 0 and c <= b
        multiply[a, c] = b
    }
}

test expect {
    trivialFactors: {all pos: Int | {pos > 0} => {divides[pos, pos] and divides[1, pos]}} is sat
    ThreeDividesSix: {divides[3, 6]} is sat
    TwoDoesNotDivideFive: {divides[2, 5]} is unsat
}

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