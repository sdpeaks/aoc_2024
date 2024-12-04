package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func createLists(lines []string) (leftList []int, rightList []int) {
	for _, line := range lines {
		columns := strings.Fields(line)

		if len(columns) == 2 {
			leftNumber, _ := strconv.Atoi(columns[0])
			rightNumber, _ := strconv.Atoi(columns[1])

			leftList = append(leftList, leftNumber)
			rightList = append(rightList, rightNumber)
		}
	}
	return
}

func distanceBetweenNumbers(leftNum, rightNum int) int {
	if rightNum > leftNum {
		return rightNum - leftNum
	} else {
		return leftNum - rightNum
	}
}

func main() {
	input, err := os.ReadFile("input")
	if err != nil {
		fmt.Println("File reading error:", err)
		return
	}

	lines := strings.Split(string(input), "\n")
	leftList, rightList := createLists(lines)

	sort.Ints(leftList)
	sort.Ints(rightList)

	// PART 1
	result1 := 0
	if len(leftList) == len(rightList) {
		for i := range leftList {
			dist := distanceBetweenNumbers(leftList[i], rightList[i])
			result1 += dist
		}
	}
	fmt.Println("Part 1: ", result1)

	// PART 2
	result2 := 0
	for _, leftNumber := range leftList {
		counter := 0
		for _, rightNumber := range rightList {
			if rightNumber == leftNumber {
				counter += 1
			}
		}
		result2 += leftNumber * counter

	}
	fmt.Println("Part 2: ", result2)
}
