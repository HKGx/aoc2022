const inputFile = await Deno.readTextFile("inputs/day1.txt");

const sumInventory = (inv: string) =>
  inv
    .split("\n")
    .filter((s) => s.trim())
    .map((s) => parseInt(s, 10))
    .reduce((acc, val) => acc + val);

const elfs = inputFile
  .split("\n\n")
  .map(sumInventory)
  .sort((a, b) => b - a);

const [biggest, sndBiggest, thdBiggest] = elfs;

console.log("Biggest is", biggest);
console.log("Top thre sum:", biggest + sndBiggest + thdBiggest);
