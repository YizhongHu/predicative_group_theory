#lang forge
open "group-defs.frg"

/* -------------------------- Generators and Cayley Graphs ------------------------- */
/* Here, we define what a generating set of a group is, and use that to define and   */
/*                show properies of corresponding Cayley graphs.                     */

-- thought: todo, rework cayley graph to be more explicit -ian

-- A generating set of a group is a subset S of the group G
-- such that every element of G can be expressed as
-- a combination (under the group operation) of finitely many
-- elements of S and their inverses.
one sig Generator {
    ident: func Group->Element,
    generatingSet: set Group->Element,
    graph: pfunc Group->Element->Element->Element
}

-- Constrains the validity of a generating set: A generating set here is a subset of the
-- group elements with minimal (no redundancies) generation.
pred validGenerator[G: Group] {
    let id = Generator.ident[G], generator = (Generator.generatingSet[G]) | {
        -- Valid identity
        id = identity[G]

        -- generator is a subset of the group
        generator in G.elements

        -- Every element can be obtained by chaining generator operations (left operations)
        -- from the identity
        G.elements = id.(^(generator.(G.table)))

        -- ensure that it is a minimal generating set
        -- i.e. A generator cannot reach anther generator through some series of generator
        -- operations
        no gen: generator | {
            some (((generator - gen)->gen) & ^((generator - gen).(G.table)))
        }
    }
}

pred generatorRepresentation[G: Group] {
    let id = Generator.ident[G], generator = (Generator.generatingSet[G])| {
        -- Constrain the Cayley Graph
        Generator.graph[G] = (G.elements->generator->G.elements & G.table)
    }
}

pred properlyGenerated {
    all G: Group | {
        axioms[G]
        validGenerator[G]
    }
}

pred properCayley {
    properlyGenerated
    all G: Group | generatorRepresentation[G]
}

-- A cyclic group is a group that can be expressed with one generator.
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


/* -------------------------- Cayley Graphs ------------------------- */
/* An element node is a node of a Cayley graph representing an        */
/* element of the group. We distinguish this sig from the Element     */
/* sig in order to avoid retroactive definitions and let the graph    */
/* be independent, for reasons to come.                               */
sig ElementNode {
    elt: one Element,
    neighbors: set ElementNode
}

pred wellFormedCayleyGraph[G : Group] {
    -- Every element has exactly one element node.
    all e : Element | some en : ElementNode | {en.elt = e}
    #Element = #ElementNode
    -- Two element nodes n1 and n2 are connected if and only if their elements are such
    -- that n1 * s = n2 for some s in the generating set.
    all n1, n2 : ElementNode {
        n1->n2 in neighbors iff {some s : Generator.generatingSet[G] | G.table[n1.elt, s] = n2.elt}
    }
}
/* ----------------------- Graph Theory Tools ------------------------- */
/* We need to first develop some graph theoretic tools before we can    */
/*                              move on.                                */

-- Two nodes are path connected if there is a sequence of edges that bridges
-- one node to the other.
pred pathConnected[en1, en2 : ElementNode] {
    reachable[en1, en2, neighbors, ~neighbors]
}

-- A graph is connected if all points are path connected to each other point.
pred connected {
    all disj en1, en2 : ElementNode | pathConnected[en1, en2]
}

pred adjacent[en1, en2 : ElementNode] {
    en1->en2 in neighbors or en2->en1 in neighbors
}
//------ Kuratowski's Theorem ------//
-- A graph is not planar iff it has a
-- K₅ or a K₃₃ subgraph.
pred k5Subgraph {
    some disj en1, en2, en3, en4, en5 : ElementNode {
        adjacent[en1, en2]
        adjacent[en1, en3]
        adjacent[en1, en4]
        adjacent[en1, en5]
        adjacent[en2, en3]
        adjacent[en2, en4]
        adjacent[en2, en5]
        adjacent[en3, en4]
        adjacent[en3, en5]
        adjacent[en4, en5]
    }
}

pred k33Subgraph {
    some disj enA1, enA2, enA3, enB1, enB2, enB3 : ElementNode {
        adjacent[enA1, enB1]
        adjacent[enA1, enB2]
        adjacent[enA1, enB3]
        adjacent[enA2, enB1]
        adjacent[enA2, enB2]
        adjacent[enA2, enB3]
        adjacent[enA3, enB1]
        adjacent[enA3, enB2]
        adjacent[enA3, enB3]
    }
}

pred planar {
    !k5Subgraph
    !k33Subgraph
}

run {
    all G : Group | {
        properlyGenerated
        wellFormedCayleyGraph[G]
        !planar
}} for exactly 1 Group, 8 Element, 8 ElementNode