extends Node2D


var questions:Array[QuestionInfo] = []


@onready var camera_controller = $CameraController
@onready var limits:PanelContainer = $TestPanelContainer
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


func _on_test_panel_container_resized():
	camera_controller.set_bottom_limit(limits.global_position.y + limits.size.y)
