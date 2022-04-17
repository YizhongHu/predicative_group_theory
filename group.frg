#lang forge

sig Element {}

sig Group { 
    elements: set Element,
    table: func Element -> Element -> Element
}


fun identity[g: Group]: Element {
    {i: Group.elements | {
        all e: Group.elements | {
            i->e->e in g.table
        }
    }}
}

pred haveIdentity[g: Group] {
    some identity[g]
}


pred haveInverse[g: Group] {
    let id = identity[g] | {
        all e: Group.elements | {
            some einv: Group.elements | {
                e -> einv -> id in g.table
            }
        }
    }
}

pred associativity[g: Group] {
    all e1, e2, e3: g.elements | {
        // may only work with dot...
        g.table[g.table[e1, e2], e3] = g.table[e1, g.table[e2, e3]]
    }
}

pred closed[g: Group] {
    g.table in g.elements->g.elements->g.elements
}

pred axioms[g: Group] {
    closed[g]
    haveIdentity[g]
    haveInverse[g]
    associativity[g]
}

// test expect {
//     uniqueIdentity: { all g: Group | { axioms[g] => one identity[g] } } is theorem for exactly 1 Group, exactly 10 Element
// } 

run {
    all g: Group | axioms[g]
} for exactly 1 Group, exactly 3 Element


pred subgroup[s: Group, g: Group] {
    s.elements in g.elements
    s.table in g.table
    closed[g]
    haveIdentity[g]
}