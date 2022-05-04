const d3 = require('d3')
d3.selectAll("svg > *").remove();

// Can display elements as letters or colors
const DISPLAY_TYPE = "colors"; //"colors" or "letters"
const COLOR_SCHEME = "normal"; //"normal", "pastel", "ruby", "sandstone"

if (COLOR_SCHEME == "normal") {
  RED = "#df4772";
  ORANGE = "#ff9500";
  YELLOW = "#f6ff00";
  GREEN = "#d5f2d5";
  BLUE = "#1ee7f7";
  INDIGO = "#1e2df7";
  VIOLET = "#bb0fe2";
  PINK = "#ff0ba1";
}
if (COLOR_SCHEME == "pastel") {
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
if (COLOR_SCHEME == "ruby") {
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
if (COLOR_SCHEME == "sandstone") {
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
    .attr("x", (row + 1.5) * 40)
    .attr("y", (col + 2) * 30 + yoffset)
    .text(value);
}

function printRect(row, col, yoffset, value) {
  d3.select(svg)
    .append('rect')
    .attr('x', (row + 1.7) * 30)
    .attr('y', (col + 1.36) * 30 + yoffset)
    .attr('width', 30)
    .attr('height', 30)
    .attr('stroke-width', 2)
    .attr('fill', value);
}

function printGroup(groupAtom, yoffset) {
  if (DISPLAY_TYPE == "letters")
    bg = GREEN
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
        printValue(r, 0.4, yoffset - 30,
          intToABC(Element.atom("Element" + r).toString()
            .slice(-1)))
    }
    for (r = 0; r <= 20; r++) {
      if (Element.atom("Element" + r) != null)
        printValue(-0.8, r, yoffset + 10,
          intToABC(Element.atom("Element" + r).toString()
            .slice(-1)))
    }
  }
  // print table elements (NOTICE THIS BREAKS IF #ELEMENTS > 10)
  for (r = 0; r <= 20; r++) {
    for (c = 0; c <= 20; c++) {
      if (Element.atom("Element" + r) != null) {
        if (Element.atom("Element" + c) != null) {
          if (DISPLAY_TYPE == "letters") {
            val = intToABC(groupAtom
              .table[Element.atom("Element" + r)][Element.atom("Element" + c)]
              .toString().slice(-1))
            printValue(r, c, yoffset + 10, val)
          }
          if (DISPLAY_TYPE == "colors") {
            val = intToColor(groupAtom
              .table[Element.atom("Element" + r)][Element.atom("Element" + c)]
              .toString().slice(-1))
            printRect(r, c, yoffset + 10, val)
          }


        }
      }
    }
  }
}

var offset = 0
for (b = 0; b <= 10; b++) {
  if (Group.atom("Group" + b) != null)
    printGroup(Group.atom("Group" + b), offset)
  offset = offset + 300
}