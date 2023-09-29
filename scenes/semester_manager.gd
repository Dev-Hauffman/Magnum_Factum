extends Node
class_name SemesterManager


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
			var test_info:Array = []
			if disciplines_data[discipline]["quantity"] > counter:
				test_info.append(discipline)
				test_info.append(counter)
				tests_order.append(test_info)
		counter += 1
		done = true
		for discipline in disciplines_data:
			if disciplines_data[discipline]["quantity"] > counter:
				done = false
	emit_signal("finished")


func has_passed() -> bool:
	return check_final_grades()


func check_final_grades() -> bool:
	var passed:bool = true
	for discipline in disciplines_data:
		var final_score:float = 0
		for score in disciplines_data[discipline]["scores"]:
			final_score += score
		final_score = final_score / float(disciplines_data[discipline]["quantity"])
		print_debug(discipline + "final score is: " + str(final_score))
		disciplines_data[discipline]["final_grade"] = final_score
		if final_score < 7.0:
			passed = false
	return passed
