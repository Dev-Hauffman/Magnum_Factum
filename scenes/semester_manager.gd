extends Node


signal finished


#controls information about the semester, like when it's finished (successfully or not), make the semester grades
var disciplines_data:Dictionary = {}
var tests_order:Array = []


func setup_semester(available_disciplines:Array[String]):
	disciplines_data.clear()
	create_tests(available_disciplines)
	define_tests_order()


func create_tests(available_disciplines:Array[String]):
	for discipline in available_disciplines:
		var tests:Dictionary = {}
		var test_string = "test"
		var number_of_tests = 2 # in the future might be 3 to 2 tests without G2
		tests["quantity"] = number_of_tests
		var scores:Array[float] = []
		tests["scores"] = scores
		disciplines_data[discipline] = tests


func define_tests_order():
	var done:bool = false
	var counter:int = 0
	while not done:
		for discipline in disciplines_data:
			if disciplines_data[discipline]["quantity"] > counter:
				tests_order.append(discipline)
		counter += 1
		done = true
		for discipline in disciplines_data:
			if disciplines_data[discipline]["quantity"] > counter:
				done = false
	print_debug("finished")
	emit_signal("finished")
