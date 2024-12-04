import re

with open("input", "r") as f:
    input = f.read()

# Part 1
pattern = r"mul\(\d{1,3},\d{1,3}\)"
matches: list[str] = re.findall(pattern, input)
result1 = sum(int(x) * int(y) for c in matches for x, y in [c[4:-1].split(",")])
print(f"Part 1: {result1}")

# part 2
result2 = 0
is_enabled = True
i = 0

while i <= len(input) - 7:
    if input[i:].startswith("do()"):
        is_enabled = True
        i += 4
    elif input[i:].startswith("don't()"):
        is_enabled = False
        i += 7

    if is_enabled:
        match: list[str] = re.findall(pattern, input[i : i + 12])
        if match:
            x, y = match[0][4:-1].split(",")
            result2 += int(x) * int(y)
            i += len(match[0]) - 1

    i += 1

print(f"Part 2: {result2}")
