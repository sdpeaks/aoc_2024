package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
	data := os.read_entire_file("input") or_else os.exit(1)
	defer delete(data)

	inputLines := strings.split(strings.trim_right(string(data), "\n"), "\n")
	area_size := map[string]int {
		"area_height" = len(inputLines),
		"area_width"  = len(inputLines[0]),
	}
	guard: Guard = ---

	there_is_a_guard := true

	for {
		for line, yIdx in inputLines {
			for char, xIdx in line {
				if char == '^' || char == '>' || char == 'v' || char == '<' {
					getGuard(&guard, char, xIdx, yIdx)
					there_is_a_guard = update(&guard, &inputLines, area_size)
					break
				}
			}
		}
		if !there_is_a_guard {
			//fmt.printf("las guard position: x=%d, y=%d\n\n", guard.xLocation, guard.yLocation)
			break
		}
	}

	counter_part1 := 0
	for line in inputLines {
		for char in line {
			if char == 'X' {
				counter_part1 += 1
			}
		}
	}

	fmt.printf("Part 1: %d\n", counter_part1)
}

update :: proc(guard: ^Guard, area: ^[]string, area_size: map[string]int) -> bool {
	next_location := Location {
		x = guard.xLocation,
		y = guard.yLocation,
	}

	switch guard.direction {
	case .UP:
		next_location.y -= 1
	case .DOWN:
		next_location.y += 1
	case .RIGHT:
		next_location.x += 1
	case .LEFT:
		next_location.x -= 1
	}

	if next_location.x < 0 ||
	   next_location.x > area_size["area_width"] ||
	   next_location.y < 0 ||
	   next_location.y > area_size["area_height"] {
		area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "^", "X", 1)
		return false
	}

	switch rune(area[next_location.y][next_location.x]) {
	case '.':
		switch guard.direction {
		case .UP:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "^", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"^",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .RIGHT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], ">", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					">",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .DOWN:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "v", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"v",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .LEFT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "<", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"<",
					area[next_location.y][next_location.x + 1:],
				},
			)
		}
	case 'X':
		switch guard.direction {
		case .UP:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "^", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"^",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .RIGHT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], ">", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					">",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .DOWN:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "v", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"v",
					area[next_location.y][next_location.x + 1:],
				},
			)
		case .LEFT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "<", "X", 1)
			area[next_location.y], _ = strings.concatenate(
				{
					area[next_location.y][:next_location.x],
					"<",
					area[next_location.y][next_location.x + 1:],
				},
			)
		}
	case '#':
		switch guard.direction {
		case .UP:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "^", ">", 1)
		case .RIGHT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], ">", "v", 1)
		case .DOWN:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "v", "<", 1)
		case .LEFT:
			area[guard.yLocation], _ = strings.replace(area[guard.yLocation], "<", "^", 1)
		}
	case:
		return false
	}
	return true
}

getGuard :: proc(guard: ^Guard, char: rune, x, y: int) -> bool {
	dir: Direction
	switch char {
	case '^':
		dir = Direction.UP
	case '>':
		dir = Direction.RIGHT
	case 'v':
		dir = Direction.DOWN
	case '<':
		dir = Direction.LEFT
	case:
		return false
	}

	guard^ = Guard {
		direction = dir,
		xLocation = x,
		yLocation = y,
	}
	return true
}

Location :: struct {
	x, y: int,
}

Direction :: enum {
	UP = 1,
	LEFT,
	DOWN,
	RIGHT,
}

Guard :: struct {
	direction:            Direction,
	xLocation, yLocation: int,
}
