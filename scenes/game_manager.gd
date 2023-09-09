extends Node


var available_disciplines:Array = []
var current_disciplines:Dictionary = {}
var current_semester:int = 1


func _ready():
	available_disciplines = Disciplines.get_discipline_by_semester(current_semester)
	# play_show_semester_scene() #shows current disciplines and semester in a scene
	
	create_tests()


func create_tests():
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
		current_disciplines[discipline] = tests
