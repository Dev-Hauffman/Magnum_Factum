extends Node2D


var questions:Array[QuestionInfo] = []
var final_score:float = 0


@onready var camera_controller:CameraController = $CameraController
@onready var test_container = $TestPanelContainer
@onready var limits:PanelContainer = $LimitsContainer
@onready var questions_container = $TestPanelContainer/TestMarginContainer/QuestionsContainer
#@onready var test_label = $TestPanelContainer/TestMarginContainer/QuestionsContainer/PanelContainer/QuestionMarginContainer/QuestionContainer/Label


func _ready():
	#var new_label = Label.new()
	#add_child(new_label)
	#new_label.global_position = test_label.global_position
	#new_label.add_theme_color_override("font_color", Color.BLACK)
	#new_label.text = test_label.text
	
	#await get_tree().create_timer(0.01).timeout
	pass


func initialize(camera:Camera2D):
	camera_controller.initialize(camera)
	camera_controller.set_camera_position(Vector2(limits.size.x/2 - get_window().size.x/2, test_container.position.y))
	var top_limit = limits.global_position.y
	var right_limit = limits.global_position.x + limits.size.x
	var bottom_limit = limits.global_position.y + limits.size.y
	var left_limit = limits.global_position.x
	camera_controller.set_camera_limits(top_limit, right_limit, bottom_limit, left_limit)
	generate_questions()
	add_questions()


func generate_questions():
	var question_generator:QuestionGenerator = QuestionGenerator.new()
	questions = question_generator.define_questions()


func add_questions():
	for entry in questions:
		var question = preload("res://scenes/test_scene/test_screen/question.tscn").instantiate()
		questions_container.add_child(question)
		question.initialize(entry)
		question.connect("clicked", Callable(self, "treat_question_click"))


func treat_question_click():
	camera_controller.shake_camera()


func _on_test_panel_container_resized():
	camera_controller.set_bottom_limit(limits.global_position.y + limits.size.y)


func _on_timer_timeout():
	print_debug("time out")
	for children in questions_container.get_children():
		if children.visible == true:
			children.can_click = false
			final_score += children.current_score
	print_debug("final score: " + str(final_score))
