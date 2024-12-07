import fs from "node:fs";

let data = "";
try {
  data = fs.readFileSync("input", "utf8");
} catch (err) {
  console.log(err);
}
const input = data.split("\n").filter((line) => line);
const xLength = input[0].length;
const yLength = input.length;

const directionsPart2 = [
  [
    { dx: -1, dy: -1 },
    { dx: 1, dy: 1 },
  ],
  [
    { dx: 1, dy: -1 },
    { dx: -1, dy: 1 },
  ],
];

function checkBoundaries(x, y) {
  return x >= 0 && y >= 0 && x < xLength && y < yLength;
}

function isMAgainstS(a, b) {
  return (a === "M" && b === "S") || (a === "S" && b === "M");
}

function matchFromCurrentPointPart2(matrix, x, y, directions) {
  let validDiagonals = 0;

  for (const direction of directions) {
    const end1 = { x: x + direction[0].dx, y: y + direction[0].dy };
    const end2 = { x: x + direction[1].dx, y: y + direction[1].dy };

    if (!checkBoundaries(end1.x, end1.y) || !checkBoundaries(end2.x, end2.y)) {
      continue;
    }

    const char1 = matrix[end1.y][end1.x];
    const char2 = matrix[end2.y][end2.x];

    if (isMAgainstS(char1, char2)) {
      validDiagonals++;
    }
  }

  return validDiagonals === 2;
}

let counterPart2 = 0;
for (let y = 0; y < yLength; y++) {
  for (let x = 0; x < xLength; x++) {
    if (input[y][x] !== "A") continue;

    if (matchFromCurrentPointPart2(input, x, y, directionsPart2)) {
      counterPart2++;
    }
  }
}

console.log(`Part 2: ${counterPart2}`);
