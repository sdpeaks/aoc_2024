import fs from "node:fs";

// Leer archivo
let data = "";
try {
  data = fs.readFileSync("input", "utf8");
} catch (err) {
  console.log(err);
}
const input = data.split("\n").filter((line) => line);
const xLength = input[0].length;
const yLength = input.length;

// PART 1
const textPart1 = "XMAS";

const directions = [
  { dx: 1, dy: 0 },
  { dx: -1, dy: 0 },
  { dx: 0, dy: 1 },
  { dx: 0, dy: -1 },
  { dx: 1, dy: 1 },
  { dx: -1, dy: 1 },
  { dx: -1, dy: -1 },
  { dx: 1, dy: -1 },
];

function checkBoundaries(x, y) {
  return !(x >= 0 && y >= 0 && x < xLength && y < yLength);
}

function matchFromCurrentPointPart1(matrix, x, y, { dx, dy }, text) {
  for (let i = 0; i < text.length; i++) {
    const newX = x + dx * i;
    const newY = y + dy * i;
    if (checkBoundaries(newX, newY) || matrix[newY][newX] !== text[i]) {
      return false;
    }
  }
  return true;
}

let counterPart1 = 0;
for (let y = 0; y < yLength; y++) {
  for (let x = 0; x < xLength; x++) {
    if (input[y][x] !== "X") continue;
    for (const direction of directions) {
      if (matchFromCurrentPointPart1(input, x, y, direction, textPart1)) {
        counterPart1++;
      }
    }
  }
}
console.log(`Part 1: ${counterPart1}`);
