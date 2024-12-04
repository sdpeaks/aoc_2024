package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:time"

line_to_report :: proc(line: string) -> (levels: [dynamic]int) {
	for str_number in strings.fields(line) {
		append(&levels, strconv.atoi(str_number))
	}
	return
}

is_increasing_by_three_or_less :: proc(prev_num, curr_num: int) -> bool {
	return prev_num < curr_num && (curr_num - prev_num) <= 3
}

is_decreasing_by_three_or_less :: proc(prev_num, curr_num: int) -> bool {
	return prev_num > curr_num && (prev_num - curr_num) <= 3
}

is_safe_report :: proc(report: [dynamic]int) -> bool {
	if len(report) < 2 {
		return false
	}

	increasing := true
	decreasing := true

	prev: int
	for i in 0 ..< len(report) {
		if i > 0 {
			curr := report[i]

			if !is_increasing_by_three_or_less(prev, curr) {
				increasing = false
			}
			if !is_decreasing_by_three_or_less(prev, curr) {
				decreasing = false
			}

			if !increasing && !decreasing {
				return false
			}
		}
		prev = report[i]
	}

	return increasing || decreasing
}

main :: proc() {
	data, ok := os.read_entire_file("input", context.allocator)
	if !ok {
		fmt.println("could not read the input file")
		return
	}
	defer delete(data, context.allocator)

	input := string(data)

	safe_counter_1 := 0
	safe_counter_2 := 0

	for line in strings.split_lines_iterator(&input) {
		if line == "" do continue

		report := line_to_report(line)
		defer delete(report)

		// part 1
		if is_safe_report(report) {
			safe_counter_1 += 1
		}

		// part 2
		for i in 0 ..< len(report) {
			new_report := make([dynamic]int, len(report), cap(report))
			defer delete(new_report)
			copy(new_report[:], report[:])

			ordered_remove(&new_report, i)

			if is_safe_report(new_report) {
				safe_counter_2 += 1
				break
			}
		}
	}

	fmt.printf("part 1, safe reports: %d\n", safe_counter_1)
	fmt.printf("part 2, safe reports: %d\n", safe_counter_2)
}
