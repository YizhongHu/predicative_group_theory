#lang forge
open "group-defs.frg"
open "generators.frg"
open "subgroups.frg"
example TrvialGroup is {properlyGenerated} for {
    Group = `G0
    Element = `E0
    elements = `G0-> `E0
    table = `G0->`E0->`E0->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E0
}

example CyclicGroupOfOrder2 is {properlyGenerated} for {
    Group = `G0
    Element = `E0 + `E1
    elements = `G0-> `E0 + `G0 -> `E1
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1
}

example CyclicGroupOfOrder3 is {properlyGenerated} for {
    Group = `G0
    Element = `E0 + `E1 + `E2
    elements = `G0-> `E0 + `G0 -> `E1 + `G0 -> `E2
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E2 
          + `G0->`E0->`E2->`E2 + `G0->`E1->`E2->`E0 + `G0->`E2->`E2->`E1 + `G0->`E2->`E0->`E2 
          + `G0->`E2->`E1->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1
}

example C2byC2 is {properlyGenerated} for {
    Group = `G0
    Element = `E0 + `E1 + `E2 + `E3
    elements = `G0-> `E0 + `G0 -> `E1 + `G0 -> `E2 + `G0 -> `E3
    table = `G0->`E0->`E0->`E0 + `G0->`E0->`E1->`E1 + `G0->`E0->`E2->`E2 + `G0->`E0->`E3->`E3
          + `G0->`E1->`E0->`E1 + `G0->`E1->`E1->`E0 + `G0->`E1->`E2->`E3 + `G0->`E1->`E3->`E2 
          + `G0->`E2->`E0->`E2 + `G0->`E2->`E1->`E3 + `G0->`E2->`E2->`E0 + `G0->`E2->`E3->`E1 
          + `G0->`E3->`E0->`E3 + `G0->`E3->`E1->`E2 + `G0->`E3->`E2->`E1 + `G0->`E3->`E3->`E0

    Generator = `Generator0
    generatingSet = `Generator0->`G0->`E1 + `Generator0->`G0->`E2
}

test expect {
    cayleyGraphEdgeUnique: {{properCayley} => {all G: Group | {
        all g1, g2: G.elements | lone gen: Generator.generatingSet[G] | {
            g1->gen->g2 in (Generator.graph[G])
        }
    }}} for exactly 1 Group, 6 Element is theorem

    cayleyGraphConnected: {{properCayley} => {all G: Group | {
        let generator = (Generator.generatingSet[G]) | {
            let edges = {g1, g2: G.elements | some gen: generator | g1->gen->g2 in (Generator.graph[G])} | {
                ((G.elements)->(G.elements) - iden) in ^(edges + (~edges))
            }
        }
    }}} for exactly 1 Group, 6 Element is theorem
}

// run {
//     properlyGenerated
//     some G: Group | {
//         cyclic[G]
//         not cyclicAlternative[G]
//     }
// } for exactly 1 Group, 6 Element 

test expect {
    -- This is a test for generating set
    cyclicDefinitionsEquivalentForward: {{properlyGenerated} => {all G: Group | {
        cyclicAlternative[G] => cyclic[G]
    }}} for exactly 1 Group, 6 Element is theorem

    -- Unfortunately the other direction does not satisfy
    cyclicDefinitionsEquivalentBackward: {
        properlyGenerated
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
    cyclicGroupsExist: {{properlyGenerated} =>{
        some G: Group | cyclic[G]
    }} for exactly 1 Group, 6 Element is sat
    trivialGroupCyclic: {{properlyGenerated} =>{
        all G: Group | cyclic[G]
    }} for exactly 1 Group, 1 Element is theorem
    cyclicGroupsOrder4Exist: {{properlyGenerated} =>{
        some G: Group | {cyclic[G] and order[G] = 4}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder5Exist: {{properlyGenerated} =>{
        some G: Group | {cyclic[G] and order[G] = 5}
    }} for exactly 1 Group, 6 Element is sat
    cyclicGroupsOrder6Exist: {{properlyGenerated} =>{
        some G: Group | {cyclic[G] and order[G] = 6}
    }} for exactly 1 Group, 6 Element is sat
}

-- Tests divide predicate
test expect {
    trivialFactors: {all pos: Int | {pos > 0} => {divides[pos, pos] and divides[1, pos]}} is sat
    ThreeDividesSix: {divides[3, 6]} is sat
    TwoDoesNotDivideFive: {divides[2, 5]} is unsat
}