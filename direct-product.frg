#lang forge
open "group-defs.frg"

sig Pair extends Element {
    first: one Element, 
    second: one Element
}

sig DirectProductGroup extends Group {}

pred validDirectProduct[G, H: Group, K: DirectProductGroup] {
    -- All elements in K are pairs
    K.elements in Pair

    -- The elements in the K are all possible tuples of G and H
    all g: G.elements, h: H.elements | {
        some k: K.elements | {k.first = g and k.second = h}
    }
    k.elements.first in G.elements
    k.elements.second in H.elements

    -- All operations are defined element-wise
    all k1, k2: K.elements | {
        let k3 = K.table[k1][k2] | {
            G.table[k1.first][k2.first] = k3.first
            H.table[k1.second][k2.second] = k3.second
        }
    }
}

run {
    all G: Group | axioms[G]
    some disj G, H: Group, K: DirectProductGroup | {
        order[G] = 2
        order[H] = 2
        validDirectProduct[G, H, K]
    }
} for exactly 1 DirectProductGroup, exactly 3 Group

pred properDirectProduct {
    all G: Group | axioms[G]
    some disj G, H: Group, K: DirectProductGroup | {
        validDirectProduct[G, H, K]
    }
}

// test expect {
//     tupleOfIdentityIsIdentity: {{properDirectProduct} => {

//     }}
// }