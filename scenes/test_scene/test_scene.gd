extends Node2D


signal test_ended(final_score)


@onready var test_camera:Camera2D = $GridContainer/TestViewportContainer/SubViewport/TestCamera2D
@onready var test_screen = $GridContainer/TestViewportContainer/SubViewport/TestScreen
@onready var time_up_notice = $TimeUpNotice
@onready var transition_animation = $DarkBackground/TransitionAnimation
@onready var score_value_label = $ScoreResult/ScoreValueLabel
@onready var score_result_animation = $ScoreResult/ScoreResultAnimation
@onready var get_ready_animation = $Preparation/GetReadyAnimation
@onready var write_label = $WriteLabel
@onready var get_ready_label = $Preparation/GetReadyLabel
@onready var time_is_up_voice = $TimeIsUpVoice
@onready var get_ready_voice = $GetReadyVoice
@onready var write_voice = $WriteVoice


func start_test(speed_value:int, precision_value:int):
	get_ready_label.hide()
	test_screen.initialize(test_camera, speed_value, precision_value)
	test_screen.connect("finished_test", Callable(self, "end_screen"))
	test_screen.connect("finished_showing", Callable(self, "start_writing"))
	await test_screen.initialized
	transition_animation.play("Fade out")
	await transition_animation.animation_finished
	get_ready_animation.play("Flash")
	get_ready_voice.play()
	


func end_screen(final_score:float):
	time_is_up_voice.play()
	print_debug(final_score)
	time_up_notice.notify_time_up()
	await time_up_notice.time_up_animation.animation_finished
	transition_animation.play("Fade in")
	await transition_animation.animation_finished
	set_label_score(final_score)
	score_result_animation.play("Show score")
	await score_result_animation.animation_finished
	emit_signal("test_ended", final_score)


func start_writing():
	get_ready_animation.stop()
	write_label.show()
	write_voice.play()
	await get_tree().create_timer(0.3).timeout
	write_label.hide()


func set_label_score(score:float):
	score_value_label.text = "[center]" + str(score) + "[/center]"
