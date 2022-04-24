const d3 = require('d3')
d3.selectAll("svg > *").remove();

// Can display elements as letters or colors
const DISPLAY_TYPE = "colors"; //"colors" or "letters"
const RED = "#df4772";
const ORANGE = "#ff9500";
const YELLOW = "#f6ff00";
const GREEN = "#d5f2d5";
const BLUE = "#1ee7f7";
const INDIGO = "#1e2df7";
const VIOLET = "#bb0fe2";
const PINK = "#ff0ba1";

function intToABC(int) {
    abc = "abcdefghijklmnopqrstuvwxyz";
    return abc.charAt(int)
}

function intToColor(int) {
    colors = [RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET, PINK];
    return colors[int]
}

function printValue(row, col, yoffset, value) {
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .attr("x", (row+1.5)*40)
    .attr("y", (col+2)*30 + yoffset)
    .text(value);
}

function printRect(row, col, yoffset, value) {
    d3.select(svg)
    .append('rect')
    .attr('x', (row+1.7)*30)
    .attr('y', (col+1.36)*30 + yoffset)
    .attr('width', 30)
    .attr('height', 30)
    .attr('stroke-width', 2)
    .attr('fill', value);
}

function printGroup(groupAtom, yoffset) {
  if(DISPLAY_TYPE == "letters")
    bg = GREEN
  if(DISPLAY_TYPE == "colors")
    bg = 'transparent'
  d3.select(svg)
    .append('rect')
    .attr('x', 50)
    .attr('y', yoffset+50)
    .attr('width', 300)
    .attr('height', 300)
    .attr('stroke-width', 2)
    .attr('stroke', 'black')
    .attr('fill', bg);
    if(DISPLAY_TYPE == "letters") {
      // print table headers
      for (r = 0; r <= 20; r++) {
          if(Element.atom("Element"+r) != null)
              printValue(r, 0.4, yoffset - 30,
              intToABC(Element.atom("Element"+r).toString()
              .slice(-1)))
      }
      for (r = 0; r <= 20; r++) {
          if(Element.atom("Element"+r) != null)
              printValue(-0.8, r, yoffset + 10,
              intToABC(Element.atom("Element"+r).toString()
              .slice(-1)))
      }
    }
    // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
    for (r = 0; r <= 20; r++) {
        for (c = 0; c <= 20; c++) {
          if(Element.atom("Element"+r) != null) {
            if(Element.atom("Element"+c) != null) {
              if(DISPLAY_TYPE == "letters") {
                val = intToABC(groupAtom
                          .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                          .toString().slice(-1))
                printValue(r, c, yoffset + 10, val)
              }
              if(DISPLAY_TYPE == "colors") {
                val = intToColor(groupAtom
                          .table[Element.atom("Element"+r)][Element.atom("Element"+c)]
                          .toString().slice(-1))
                printRect(r, c, yoffset + 10, val)
              }

              
            }
          }
        }
    }
}


var offset = 0
for(b = 0; b <= 10; b++) {  
  if(Group.atom("Group"+b) != null)
    printGroup(Group.atom("Group"+b), offset)  
  offset = offset + 300
}