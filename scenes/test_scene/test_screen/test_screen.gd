extends Node2D


@onready var camera_controller = $CameraController
@onready var limits:PanelContainer = $PanelContainer
@onready var test_label = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Label


func _ready():
	var new_label = Label.new()
	add_child(new_label)
	await get_tree().create_timer(0.01).timeout
	new_label.global_position = test_label.global_position
	new_label.add_theme_color_override("font_color", Color.BLACK)
	new_label.text = test_label.text
	var top_limit = limits.global_position.y
	var right_limit = limits.global_position.x + limits.size.x
	var bottom_limit = limits.global_position.y + limits.size.y
	var left_limit = limits.global_position.x
	camera_controller.set_camera_limits(top_limit, right_limit, bottom_limit, left_limit)
	generate_questions()


func initialize(camera:Camera2D):
	camera_controller.initialize(camera, limits)


func generate_questions():
	var question_generator:QuestionGenerator = QuestionGenerator.new()
	var questions:Array[QuestionInfo] = question_generator.define_questions()
