package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func verifyApplicability(update string, rule []string) bool {
	return strings.Contains(update, rule[0]) &&
		strings.Contains(update, rule[1])
}

func UpdateIsCorrect(update string, rules [][]string) bool {
	correctRules := 0
	for _, rule := range rules {
		if strings.Index(update, rule[0]) < strings.Index(update, rule[1]) {
			correctRules++
		}
	}
	return len(rules) == correctRules
}

func correctPageOrder(pageNumbers []string, firstIdx, secondIndex int) []string {
	if firstIdx > secondIndex {
		pageNumbers[firstIdx], pageNumbers[secondIndex] = pageNumbers[secondIndex], pageNumbers[firstIdx]
		return pageNumbers
	}
	return pageNumbers
}

func main() {
	data, err := os.ReadFile("input")
	if err != nil {
		fmt.Println("Error reading file: ", err)
	}

	sections := strings.SplitN(strings.TrimSpace(string(data)), "\n\n", 2)
	rulesLines := strings.Split(sections[0], "\n")
	updatesLines := strings.Split(sections[1], "\n")

	var rules [][]string

	for _, rule := range rulesLines {
		parts := strings.Split(rule, "|")
		rule := []string{parts[0], parts[1]}
		rules = append(rules, rule)
	}

	var resultPart1, resultPart2 int
	for _, update := range updatesLines {

		// PART 1
		var applicableRules [][]string
		for _, rule := range rules {
			if verifyApplicability(update, rule) {
				applicableRules = append(applicableRules, rule)
			}
		}
		if UpdateIsCorrect(update, applicableRules) {
			pageNumbers := strings.Split(update, ",")
			centerNumber, _ := strconv.Atoi(pageNumbers[(len(pageNumbers)-1)/2])
			resultPart1 += centerNumber
		} else {

			// PART 2
			pageNumbers := strings.Split(update, ",")
			for {
				wasCorrected := false
				for _, rule := range applicableRules {
					first, second := rule[0], rule[1]
					firstIdx, secondIdx := -1, -1
					for i, page := range pageNumbers {
						if page == first {
							firstIdx = i
						} else if page == second {
							secondIdx = i
						}
					}
					if firstIdx > secondIdx {
						pageNumbers[firstIdx], pageNumbers[secondIdx] = pageNumbers[secondIdx], pageNumbers[firstIdx]
						wasCorrected = true
					}
				}
				if !wasCorrected {
					break
				}
			}
			centerNumber, _ := strconv.Atoi(pageNumbers[(len(pageNumbers)-1)/2])
			resultPart2 += centerNumber
		}
	}

	fmt.Printf("Part 1: %d\n", resultPart1)
	fmt.Printf("Part 2: %d\n", resultPart2)
}
