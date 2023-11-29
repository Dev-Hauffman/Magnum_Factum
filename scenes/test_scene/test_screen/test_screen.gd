extends Node2D


signal initialized
signal finished_test(final_score)
signal finished_showing


var questions_info:Array[QuestionInfo] = []
var final_score:float = 0
var middle
var questions = []


@onready var camera_controller:CameraController = $CameraController
@onready var test_container = $TestPanelContainer
@onready var limits:PanelContainer = $LimitsContainer
@onready var questions_container = $TestPanelContainer/TestMarginContainer/QuestionsContainer
@onready var timer = $Timer


func _ready():
	#var new_label = Label.new()
	#add_child(new_label)
	#new_label.global_position = test_label.global_position
	#new_label.add_theme_color_override("font_color", Color.BLACK)
	#new_label.text = test_label.text
	await initialized
	#await get_tree().process_frame #is this necessary?
	#await get_tree().create_timer(18.0).timeout
	show_questions()
	await finished_showing
	camera_controller.can_move = true
	camera_controller.can_zoom = true
	timer.start()
	


func initialize(camera:Camera2D, writing_speed:int, precision:int):
	camera_controller.initialize(camera)
	middle = limits.global_position.x + (limits.size.x/2)
	camera_controller.set_camera_position(Vector2(middle, test_container.position.y))
	var top_limit = limits.global_position.y
	var right_limit = limits.global_position.x + limits.size.x
	var bottom_limit = limits.global_position.y + limits.size.y
	var left_limit = limits.global_position.x
	camera_controller.set_camera_limits(top_limit, right_limit, bottom_limit, left_limit)
	generate_questions()
	await add_questions(writing_speed, precision)
	emit_signal("initialized")


func generate_questions():
	var question_generator:QuestionGenerator = QuestionGenerator.new()
	questions_info = question_generator.define_questions()


func add_questions(writing_speed:int, precision:int):
	for entry in questions_info:
		var question = preload("res://scenes/test_scene/test_screen/question.tscn").instantiate()
		question.mouse_filter = Control.MOUSE_FILTER_PASS
		questions_container.add_child(question)
		question.initialize(entry, writing_speed, precision)
		question.connect("clicked", Callable(self, "treat_question_click"))
		question.connect("confidence_defined", Callable(self, "spawn_confidence_label"))
		questions.append(question)
		await question.populated


func show_questions():
	var question = questions[0]
	var height_middle = question.global_position.y + get_viewport_rect().size.y/4
	camera_controller.move_and_zoom(Vector2(middle,height_middle), Vector2(2, 2))
	await camera_controller.moved_and_zoomed
	await get_tree().create_timer(0.3).timeout
	for i in range(1, questions.size()):
		question = questions[i]
		height_middle = question.global_position.y + get_viewport_rect().size.y/4 # why 4? Because the screen is divide in 2 viewports, but you have to divide it by 2 to get their half (it doesn't matter if they're side by side or on top of each other)
		camera_controller.move_to(Vector2(middle, height_middle), 1.0)
		await camera_controller.finished_moving
		await get_tree().create_timer(0.3).timeout
	question = questions[0]
	height_middle = question.global_position.y + get_viewport_rect().size.y/4
	camera_controller.move_and_zoom(Vector2(middle,height_middle), Vector2(1, 1))
	await camera_controller.moved_and_zoomed
	emit_signal("finished_showing") 


func treat_question_click(position:Vector2):
	camera_controller.shake_camera()
	camera_controller.move_to(position, 1.0)
	camera_controller.zoom(Vector2(2, 2))


func spawn_confidence_label(confidence_value:int, paragraph_position:Vector2, paragraph_rectangle:Rect2):
	var confidence_label = preload("res://scenes/test_scene/test_screen/confidence_label.tscn").instantiate()
	confidence_label.initialize(confidence_value, paragraph_position, paragraph_rectangle)
	add_child(confidence_label)


func _on_test_panel_container_resized():
	camera_controller.set_bottom_limit(limits.global_position.y + limits.size.y)


func _on_timer_timeout():
	print_debug("time out")
	for children in questions_container.get_children():
		if children.visible == true:
			children.can_click = false
			children.can_reset = false
			children.can_show = false
			children.time_is_up = true
			final_score += children.get_score()
	final_score = snapped(final_score, 0.1)
	print_debug("final score: " + str(final_score))
	emit_signal("finished_test", final_score)
