#lang forge
open "group-defs.frg"
open "generators.frg"
open "subgroups.frg"

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
}

-- Tests divide predicate
test expect {
    trivialFactors: {all pos: Int | {pos > 0} => {divides[pos, pos] and divides[1, pos]}} is sat
    ThreeDividesSix: {divides[3, 6]} is sat
    TwoDoesNotDivideFive: {divides[2, 5]} is unsat
}