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