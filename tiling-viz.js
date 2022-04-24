const d3 = require('d3')
d3.selectAll("svg > *").remove();

/* This script tiles the colored Cayley table of Group0. */

// Can display elements as letters or colors
const COLOR_SCHEME = "pastel"; //"normal", "pastel", "ruby", "sandstone"

if(COLOR_SCHEME == "normal") {
    RED = "#df4772";
    ORANGE = "#ff9500";
    YELLOW = "#f6ff00";
    GREEN = "#d5f2d5";
    BLUE = "#1ee7f7";
    INDIGO = "#1e2df7";
    VIOLET = "#bb0fe2";
    PINK = "#ff0ba1";
}
if(COLOR_SCHEME == "pastel") {
    // pastel color scheme
    RED = "#fde4cf";
    ORANGE = "#ffcfd2";
    YELLOW = "#f1c0e8";
    GREEN = "#cfbaf0";
    BLUE = "#a3c4f3";
    INDIGO = "#90dbf4";
    VIOLET = "#8eecf5";
    PINK = "#98f5e1";
}
if(COLOR_SCHEME == "ruby") {
// ruby color scheme
    RED = "#590d22";
    ORANGE = "#800f2f";
    YELLOW = "#a4133c";
    GREEN = "#c9184a";
    BLUE = "#ff4d6d";
    INDIGO = "#ff758f";
    VIOLET = "#ff8fa3";
    PINK = "#ffb3c1";
}
if(COLOR_SCHEME == "sandstone") {
    // sandstone color scheme
    RED = "#ff8800";
    ORANGE = "#ff9500";
    YELLOW = "#ffa200";
    GREEN = "#ffaa00";
    BLUE = "#ffb700";
    INDIGO = "#ffc300";
    VIOLET = "#ffd000";
    PINK = "#ffdd00";
}

function getNumEls() {
    count = 0
    for(i = 0; i <= 25; i++){
        if(Element.atom("Element"+i) != null)
            count++
    }
    return count
}
numEls = getNumEls()
function intToABC(int) {
    abc = "abcdefghijklmnopqrstuvwxyz";
    return abc.charAt(int)
}

function intToColor(int) {
    colors = [RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET, PINK];
    return colors[int]
}

function printRect(row, col, yoffset, xoffset, value) {
    d3.select(svg)
    .append('rect')
    .attr('x', (row)*30 + xoffset)
    .attr('y', (col)*30 + yoffset)
    .attr('width', 30)
    .attr('height', 30)
    .attr('stroke-width', 2)
    .attr('fill', value);
}

function printGroupUL(groupAtom, yoffset, xoffset) {
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= numEls; r++) {
        for (c = 0; c <= numEls; c++) {
          if(Element.atom("Element"+r) != null) {
            if(Element.atom("Element"+c) != null) {
                val = intToColor(groupAtom
                    .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                    .toString().slice(-1))
                printRect(r, c, yoffset, xoffset, val)
            }
          }
        }
    }
}

function printGroupLL(groupAtom, yoffset, xoffset) {
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= numEls; r++) {
        for (c = 0; c <= numEls; c++) {
          if(Element.atom("Element"+r) != null) {
            if(Element.atom("Element"+c) != null) {
                val = intToColor(groupAtom
                    .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                    .toString().slice(-1))
                printRect(numEls - r - 1, c, yoffset, xoffset, val)
            }
          }
        }
    }
}

function printGroupUR(groupAtom, yoffset, xoffset) {
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= numEls; r++) {
        for (c = 0; c <= numEls; c++) {
          if(Element.atom("Element"+r) != null) {
            if(Element.atom("Element"+c) != null) {
                val = intToColor(groupAtom
                    .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                    .toString().slice(-1))
                printRect(r, numEls-c-1, yoffset, xoffset, val)
            }
          }
        }
    }
}

function printGroupLR(groupAtom, yoffset, xoffset) {
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= numEls; r++) {
        for (c = 0; c <= numEls; c++) {
          if(Element.atom("Element"+r) != null) {
            if(Element.atom("Element"+c) != null) {
                val = intToColor(groupAtom
                    .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                    .toString().slice(-1))
                printRect(numEls-r-1, numEls-c-1, yoffset, xoffset, val)
            }
          }
        }
    }
}



var yoffset = 0
var xoffset = 0
for(b = 0; b <= 5; b++) {  
    xoffset = 0
    for(t = 0; t <= 5; t++){
        // upper left
        if(b % 2 == 0 && t % 2 == 0)
            printGroupUL(Group.atom("Group0"), yoffset, xoffset) 
        // lower left
        if (b % 2 == 1 && t % 2 == 0) 
            printGroupLL(Group.atom("Group0"), yoffset, xoffset) 
        // upper right
        if (b % 2 == 0 && t % 2 == 1)
            printGroupUR(Group.atom("Group0"), yoffset, xoffset) 
        // lower right
        if (b % 2 == 1 && t % 2 == 1)
            printGroupLR(Group.atom("Group0"), yoffset, xoffset) 


        xoffset = xoffset + 30 * numEls
    }
  yoffset = yoffset + 30 * numEls
  xoffset = 0
}