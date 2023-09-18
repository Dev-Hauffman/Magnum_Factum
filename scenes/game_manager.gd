extends Node

# this class handle game over or success, other than global info
var current_semester:int = 1
var current_scene


@onready var semester_manager = $SemesterManager


func _ready():
	semester_manager.connect("finished", Callable(self, "run_tests_preparation"))
	set_current_semester_disciplines()


func set_current_semester_disciplines():
	var semester_disciplines = Disciplines.get_discipline_by_semester(current_semester)
	semester_manager.setup_semester(semester_disciplines)


func run_tests_preparation():
	print_debug("got here")
	if current_scene != null:
		current_scene.queue_free()
	var test_preparation = preload("res://scenes/test_preparation/test_preparation.tscn").instantiate()
	current_scene = test_preparation
	add_child(test_preparation)
	test_preparation.finished_preparation.connect(Callable(self, "run_test"))


func run_test():
	if current_scene != null:
		current_scene.queue_free()
	var test = preload("res://scenes/test_scene/test_scene.tscn").instantiate()
	current_scene = test
	add_child(test)
	test.test_screen.connect("finished_test", Callable(self, "next_test"))


func next_test():
	current_semester += 1
	set_current_semester_disciplines()
