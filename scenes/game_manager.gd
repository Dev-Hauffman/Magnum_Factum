extends Node

# this class handle game over or success, other than global info
var current_semester:int = 1
var current_scene
var current_tiredness_level:int = 0
var current_test_info:Array = []
var tests_order_index:int = 0


@onready var semester_manager:SemesterManager = $SemesterManager


func _ready():
	semester_manager.connect("finished", Callable(self, "show_semester"))
	set_current_semester_disciplines()


func show_semester():
	if current_scene != null:
		current_scene.queue_free()
	var semester_display = preload("res://scenes/show_semester/show_semester.tscn").instantiate()
	current_scene = semester_display
	add_child(semester_display)
	semester_display.connect("finished_displaying", Callable(self, "run_semester"))
	semester_display.start(current_semester)
	


func set_current_semester_disciplines():
	var semester_disciplines = Disciplines.get_discipline_by_semester(current_semester)
	semester_manager.setup_semester(semester_disciplines)


func run_semester():
	if current_scene != null:
		current_scene.queue_free()
	if semester_manager.tests_order.is_empty():
		end_semester()
	else:
		var next_test:Array = semester_manager.tests_order.pop_front()
		tests_order_index = next_test[1]
		current_test_info = next_test
		var test_preparation = preload("res://scenes/test_preparation/test_preparation.tscn").instantiate()
		current_scene = test_preparation
		add_child(test_preparation)
		test_preparation.initialize(next_test[0], str(next_test[1]), current_tiredness_level, current_semester, semester_manager.disciplines_data[next_test[0]]["scores"])
		test_preparation.finished_preparation.connect(Callable(self, "run_test"))
		test_preparation.stress_defined.connect(Callable(self, "update_accumulated_stress"))


func end_semester():
	current_semester += 1
	print_debug("semester has ended")
	var passed:bool = semester_manager.check_final_grades()
	if passed:
		set_current_semester_disciplines()
	if not passed:
		end_game()


func run_test(writing_speed, precision):
	if current_scene != null:
		current_scene.queue_free()
	var test = preload("res://scenes/test_scene/test_scene.tscn").instantiate()
	current_scene = test
	add_child(test)
	test.connect("test_ended", Callable(self, "treat_test_end"))
	test.start_test(writing_speed, precision)


func update_accumulated_stress(stress_amount:int):
	current_tiredness_level = stress_amount


func treat_test_end(score:float):
	semester_manager.disciplines_data[current_test_info[0]]["scores"].append(score)
	if tests_order_index + 1 == 1:
		var necessary_score:float = 14.0 - score
		if necessary_score > 10:
			end_game()
	if tests_order_index + 1 == semester_manager.disciplines_data[current_test_info[0]]["quantity"]:
		var passed:bool = semester_manager.check_final_grades()
		if not passed:
			end_game()
	run_semester()


func end_game():
	get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")
