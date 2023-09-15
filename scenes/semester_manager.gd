extends Node

#controls information about the semester, like when it's finished (successfully or not), make the semester grades
var disciplines_data:Dictionary = {}
var tests:Array = []


func setup_semester():
	pass


func create_tests(available_disciplines):
	for discipline in available_disciplines:
		var tests:Dictionary = {}
		var test_string = "test"
		var counter = 1
		var number_of_tests = 2 # in the future might be 3 to 2 tests without G2
		tests["quantity"] = number_of_tests
		var scores:Dictionary = {}
		for score in range(number_of_tests):
			scores[test_string + str(counter)] = -1
			counter += 1
		counter = 1
		tests["scores"] = scores
		disciplines_data[discipline] = tests


func setup_test():
	define_tests()
	get_next_test()


func define_tests():
	var maximum_test_number:int
	for discipline in disciplines_data:
		maximum_test_number += disciplines_data[discipline]["quantity"]
	for test in range(maximum_test_number):
		pass


func get_next_test():
	pass
