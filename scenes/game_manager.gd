extends Node


var choose_semester_scene

var available_disciplines:Array = []
var current_disciplines:Dictionary = {}


func _ready():
	available_disciplines = Disciplines.get_existing_disciplines()
	add_choose_semester_scene()


func add_choose_semester_scene():
	choose_semester_scene = preload("res://scenes/choose_semester/choose_semester_screen.tscn").instantiate()
	add_child(choose_semester_scene)
	choose_semester_scene.initialize(available_disciplines)
	choose_semester_scene.connect("disciplines_chosen", Callable(self, "treat_chosen_disciplines"))


func treat_chosen_disciplines(remaining_diciplines:Array, chosen_disciplines:Array):
	available_disciplines = remaining_diciplines
	for discipline in chosen_disciplines:
		var content:Dictionary = {}
		content["discipline_name"] = discipline[0]
		content["level"] = discipline[1]
		current_disciplines[discipline[0]] = content
	create_tests()


func create_tests():
	for discipline in current_disciplines:
		var tests:Dictionary = {}
		var string = "test"
		var counter = 1
		#var number_of_tests = randi_range(2,3)
		var number_of_tests = 2
		tests["quantity"] = number_of_tests
		var scores:Dictionary = {}
		for score in range(number_of_tests):
			scores[string + str(counter)] = -1
			counter += 1
		counter = 1
		tests["scores"] = scores
		current_disciplines[discipline]["tests"] = tests
		
