extends Node

# this class handle game over or success, other than global info
var current_semester:int = 1
var current_scene
var current_tiredness_level:int = 0


@onready var semester_manager:SemesterManager = $SemesterManager


func _ready():
	semester_manager.connect("finished", Callable(self, "run_semester"))
	set_current_semester_disciplines()


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
		var test_preparation = preload("res://scenes/test_preparation/test_preparation.tscn").instantiate()
		current_scene = test_preparation
		add_child(test_preparation)
		print_debug("gamemanager: " + str(current_tiredness_level))
		test_preparation.initialize(next_test[0], str(next_test[1]), current_tiredness_level)
		test_preparation.finished_preparation.connect(Callable(self, "run_test"))
		test_preparation.stress_defined.connect(Callable(self, "update_accumulated_stress"))


func end_semester():
	current_semester += 1
	print_debug("semester has ended")


func run_test(writing_speed, precision):
	if current_scene != null:
		current_scene.queue_free()
	var test = preload("res://scenes/test_scene/test_scene.tscn").instantiate()
	current_scene = test
	add_child(test)
	test.test_screen.connect("finished_test", Callable(self, "next_test"))
	test.start_test(writing_speed, precision)


func update_accumulated_stress(stress_amount:int):
	current_tiredness_level = stress_amount



func next_test(): #TEMPORARY
	run_semester()
