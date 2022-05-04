const d3 = require('d3')
d3.selectAll("svg > *").remove();
var lineGenerator = d3.line();
// Can display elements as letters or colors
const DISPLAY_TYPE = "letters"; //"colors" or "letters"
const BOX_STROKE = 0; //stroke around each table cell

const quotientColors = ["#ffadad", "#ffd6a5", "#fdffb6", "#caffbf", "#9bf6ff", "#a0c4ff", "#bdb2ff", "#ffc6ff"]
// Element String -> ResidueClass String
const resMap = {}

function printValue(row, col, yoffset, value) {
    d3.select(svg)
        .append("text")
        .style("fill", "black")
        .attr("x", (row + 1.5) * 40)
        .attr("y", (col + 2) * 30 + yoffset)
        .text(value);
}
residues.tuples().forEach((tuple) => {
    let m = tuple.atoms()[0].toString();
    let d = tuple.atoms()[1].toString();
    resMap[d] = m;
});
// optimization? what does that mean?
elCount = 0
for (z = 0; z <= 20; z++) {
    if (Element.atom("Element" + z) != null)
        elCount++
}
rcCount = 0
for (d = 0; d <= 20; d++) {
    if (ResidueClass.atom("Element" + d) != null)
        rcCount++
}

function printValue(value, sx, sy) {
    d3.select(svg)
        .append("text")
        .style("fill", "black")
        .attr("x", sx)
        .attr("y", sy)
        .text(value);
}

// residue classes -> coords
const posMapX = {}
const posMapY = {}

residueCount = Object.keys(resMap).length

let theta = 2 * 3.14 / rcCount;
const midx = 200
const midy = 170
function printResidue(res, placed, eltNum) {
    x = 120 * Math.cos(theta * placed) + midx
    y = 120 * Math.sin(theta * placed) + midy
    posMapX[res] = x
    posMapY[res] = y
    //Print circle
    d3.select(svg)
        .append('circle')
        .attr('cx', x)
        .attr('cy', y)
        .attr('r', 50)
        .attr('stroke', 'black')
        .attr('fill', quotientColors[placed]);


    // Print inner elements
    var splaced = 0
    for (c = 0; c <= 20; c++) {
        if (resMap["Element" + c] == "Element" + eltNum) {
            sx = x + (30 * Math.cos(splaced * 2 * 3.14 / ((elCount - rcCount) / rcCount))) - 5
            sy = y + (30 * Math.sin(splaced * 2 * 3.14 / ((elCount - rcCount) / rcCount))) + 5
            printValue(intToABC(c), sx, sy)
            splaced++
        }
    }

}
// residue classes -> color
const colorMap = {}

//Print residue classes (circles)
var placed = 0
for (b = 0; b <= 20; b++) {
    if (ResidueClass.atom("Element" + b) != null) {
        printResidue(ResidueClass.atom("Element" + b), placed, b)
        colorMap[ResidueClass.atom("Element" + b)] = quotientColors[placed]
        placed++
    }
}


function drawArrow(startx, starty, endx, endy, color, disp) {
    midpointX = (startx + endx) / 2
    midpointY = (starty + endy) / 2
    startx = ((midpointX - startx) * 0.5) + startx
    starty = ((midpointY - starty) * 0.5) + starty
    endx = ((midpointX - endx) * 0.5) + endx
    endy = ((midpointY - endy) * 0.5) + endy
    var slopex = 1
    if (startx < midx)
        slopex = -1
    var slopey = -1
    if (starty < midy)
        slopey = 1
    startx += slopex * disp
    starty += slopey * disp
    endx += slopex * disp
    endy += slopey * disp
    points = [
        [startx, starty],
        [endx, endy]
    ];
    var pathData = lineGenerator(points);
    d3.select(svg)
        .append('path')
        .attr('d', pathData)
        .attr('stroke', color)
        .attr('stroke-width', 10)
    d3.select(svg)
        .append('circle')
        .attr('cx', endx)
        .attr('cy', endy)
        .attr('r', 15)
        .attr('stroke', 'transparent')
        .attr('fill', color);
}

// draw arrows between residue classes 
function drawQTable() {
    var done = 0
    for (j = 0; j <= 20; j++) {
        if (ResidueClass.atom("Element" + j) != null) {
            for (k = 0; k <= 20; k++) {
                if (ResidueClass.atom("Element" + k) != null) {
                    let JR = ResidueClass.atom("Element" + j);
                    let KR = ResidueClass.atom("Element" + k);
                    let sx = posMapX[JR]
                    let sy = posMapY[JR]
                    color = colorMap[KR]
                    prod = QuotientGroup.atom("QuotientGroup0")
                        .table[JR][KR]
                    ex = posMapX[prod]
                    ey = posMapY[prod]
                    if (JR != prod) { //dont draw identity
                        drawArrow(sx, sy, ex, ey, color, done)
                    } else {
                        printValue("identity", posMapX[KR] - 25, posMapY[KR] - 60)
                    }
                }

            }
            done += 5
        }
    }
}
drawQTable()
function intToABC(int) {
    abc = "abcdefghijklmnopqrstuvwxyz";
    return abc.charAt(int)
}

function intToColor(int) {
    colors = [RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET, PINK];
    return colors[int]
}



function printRect(row, col, yoffset, value) {
    d3.select(svg)
        .append('rect')
        .attr('x', (row + 1.7) * 30)
        .attr('y', (col + 1.36) * 30 + yoffset)
        .attr('width', 30)
        .attr('height', 30)
        .attr('stroke-width', BOX_STROKE)
        .attr('stroke', 'black')
        .attr('fill', value);
}

function printValueG(row, col, yoffset, value) {
    d3.select(svg)
        .append("text")
        .style("fill", "black")
        .attr("x", (row + 1.5) * 40)
        .attr("y", (col + 2) * 30 + yoffset)
        .text(value);
}

function printGroup(groupAtom, yoffset) {
    if (DISPLAY_TYPE == "letters")
        bg = 'transparent'
    if (DISPLAY_TYPE == "colors")
        bg = 'transparent'
    d3.select(svg)
        .append('rect')
        .attr('x', 50)
        .attr('y', yoffset + 50)
        .attr('width', 300)
        .attr('height', 300)
        .attr('stroke-width', 2)
        .attr('stroke', 'black')
        .attr('fill', bg);
    if (DISPLAY_TYPE == "letters") {
        // print table headers
        for (r = 0; r <= 20; r++) {
            if (Element.atom("Element" + r) != null)
                if (ResidueClass.atom("Element" + r) == null)
                    printValueG(r, 0.4, yoffset - 30,
                        intToABC(Element.atom("Element" + r).toString()
                            .slice(-1)))
        }
        for (r = 0; r <= 20; r++) {
            if (Element.atom("Element" + r) != null)
                if (ResidueClass.atom("Element" + r) == null)
                    printValueG(-0.8, r, yoffset + 10,
                        intToABC(Element.atom("Element" + r).toString()
                            .slice(-1)))
        }
    }
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= 20; r++) {
        for (c = 0; c <= 20; c++) {
            if (Element.atom("Element" + r) != null) {
                if (Element.atom("Element" + c) != null) {
                    if (ResidueClass.atom("Element" + r) == null) {
                        if (ResidueClass.atom("Element" + c) == null) {
                            if (DISPLAY_TYPE == "letters") {
                                val = intToABC(groupAtom
                                    .table[Element.atom("Element" + r)][Element.atom("Element" + c)]
                                    .toString().slice(-1))
                                printValueG(r, c, yoffset + 10, val)
                            }
                            if (DISPLAY_TYPE == "colors") {
                                // var val = 'black'
                                prod = groupAtom
                                    .table[Element.atom("Element" + r)][Element.atom("Element" + c)].toString()
                                // printValue(colorMap[ResidueClass.atom("Element"+p)], 100, 100+p*10)
                                var val = colorMap[Element.atom(resMap[prod])]
                                printRect(r, c, yoffset + 10, val)
                            }
                        }
                    }
                }
            }
        }
    }
}

var offset = 320
for (b = 0; b <= 10; b++) {
    if (Group.atom("Group1") != null)
        if (QuotientGroup.atom("Group1") == null) {
            printGroup(Group.atom("Group1"), offset)
        }
}