extends CanvasLayer


signal finished_preparation(writting_speed, precision)
signal stress_defined(stress_amount)


var number_of_weeks:int = 4
var rest_amount:int = 15
var stress_amount:int = 25
var writing_speed:int
var precision:int = 20
var choice_panels:Array = []
var choice_panels_index:int = 1

var preview_precision:int
var preview_writing_speed:int


@onready var test_name_label:Label = $VBoxContainer/TestNameLabel
@onready var choice_container:HBoxContainer = $VBoxContainer/ChoiceContainer
@onready var tiredness_bar:ProgressBar = $HBoxContainer3/VBoxContainer2/TirednessContainer/TirednessBar
@onready var knowledge_bar:ProgressBar = $HBoxContainer3/VBoxContainer2/KnowledgeContainer/KnowledgeBar
@onready var test_start_button = $VBoxContainer/ChoiceContainer/TestContainer/MarginContainer/VBoxContainer/TestStartButton
@onready var writing_speed_value = $HBoxContainer3/VBoxContainer2/TirednessContainer/TirednessBar/WritingSpeedValue
@onready var answer_precision_value = $HBoxContainer3/VBoxContainer2/KnowledgeContainer/KnowledgeBar/AnswerPrecisionValue
@onready var tiredness_bar_preview = $HBoxContainer3/VBoxContainer2/TirednessContainer/TirednessBar/TirednessBarPreview
@onready var knowledge_bar_preview = $HBoxContainer3/VBoxContainer2/KnowledgeContainer/KnowledgeBar/KnowledgeBarPreview
@onready var tiredness_preview_animation = $HBoxContainer3/VBoxContainer2/TirednessContainer/TirednessBar/TirednessBarPreview/TirednessPreviewAnimation
@onready var knowledge_animation_preview = $HBoxContainer3/VBoxContainer2/KnowledgeContainer/KnowledgeBar/KnowledgeBarPreview/KnowledgeAnimationPreview
@onready var overview_animation_player = $OverviewAnimationPlayer
@onready var score_warning = $PieceOfPaper/ScoreWarning
@onready var first_test_value = $PieceOfPaper/FormulaContainer/FormulaDenominator/FirstTestValue
@onready var discipline_name = $PieceOfPaper/DisciplineName
@onready var piece_of_paper = $PieceOfPaper
@onready var paper_sheet_sound = $PaperSheetSound


func _ready():
	overview_animation_player.play("Fade out")

func initialize(test_name:String, test_number:String, stress_level:int, semester_number:int, scores:Array):
	test_name_label.text = "Semester " + str(semester_number) + " - " + test_name + " - " +  " Test " + str(int(test_number)+1)
	tiredness_bar.value = stress_level
	update_speed_value()
	populate_choices()
	discipline_name.text = test_name
	if int(test_number) > 0:
		update_formula(scores)
		populate_score_warn(scores)
	else:
		score_warning.visible = false


func populate_choices():
	var counter: int = 1
	for weeks in range(number_of_weeks):
		var week_value:String = "Week " + str(counter)
		var choice_panel = preload("res://scenes/test_preparation/choice_panel.tscn").instantiate()
		choice_container.add_child(choice_panel)
		choice_panel.initialize(week_value)
		choice_container.move_child(choice_panel, counter - 1)
		choice_panel.connect("study_selected", Callable(self, "study_selected"))
		choice_panel.connect("rest_selected", Callable(self, "rest_selected"))
		choice_panel.connect("study_mouse_entered", Callable(self, "add_study_preview"))
		choice_panel.connect("study_mouse_left", Callable(self, "remove_preview"))
		choice_panel.connect("rest_mouse_entered", Callable(self, "add_rest_preview"))
		choice_panel.connect("rest_mouse_left", Callable(self, "remove_preview"))
		choice_panels.append(choice_panel)
		if counter == 1:
			choice_panel.study_button.disabled = false
			choice_panel.rest_button.disabled = false
		counter += 1


func add_study_preview():
	if knowledge_bar.value != 100:
		knowledge_bar_preview.value = knowledge_bar.value + 100 / number_of_weeks
	else:
		knowledge_bar_preview.value = 100
	answer_precision_value.text = "Answer Precision: " + str(get_precision_value(knowledge_bar_preview.value)) +"%"
	if tiredness_bar.value != 100:
		tiredness_bar_preview.value = tiredness_bar.value + stress_amount
	else:
		tiredness_bar_preview.value = 100
	writing_speed_value.text = "Writing Speed:" + str(get_writing_speed_value(tiredness_bar_preview.value))
	knowledge_animation_preview.play("Pulse")
	tiredness_preview_animation.play("Pulse")


func remove_preview():
	knowledge_bar_preview.value = 0
	tiredness_bar_preview.value = 0
	writing_speed_value.text = "Writing Speed:" + str(writing_speed)
	answer_precision_value.text = "Answer Precision: " + str(precision) +"%"
	if tiredness_preview_animation.is_playing():
		tiredness_preview_animation.stop()
	if knowledge_animation_preview.is_playing():
		knowledge_animation_preview.stop()


func add_rest_preview():
	if tiredness_bar.value != 0:
		tiredness_bar_preview.value = tiredness_bar.value - rest_amount
		tiredness_preview_animation.play("Pulse")
	else:
		tiredness_bar_preview.value = 0
	writing_speed_value.text = "Writing Speed:" + str(get_writing_speed_value(tiredness_bar_preview.value))


func study_selected():
	remove_preview()
	knowledge_bar.value += 100 / number_of_weeks
	if tiredness_bar.value < 100: 
		tiredness_bar.value += stress_amount
	update_precision_value()
	update_speed_value()
	enable_next_choice_panel()


func update_precision_value():
	precision = get_precision_value(knowledge_bar.value)
	answer_precision_value.text = "Answer Precision: " + str(precision) +"%"


func get_precision_value(value:int) -> int:
	var result:int
	if value == 100:
		result = 80
	elif value >= 75:
		result = 60
	elif value >= 50:
		result = 50
	elif value >= 25:
		result = 40
	else:
		result = 20
	return result


func rest_selected():
	remove_preview()
	if tiredness_bar.value - rest_amount < 0:
		tiredness_bar.value = 0
	else:
		tiredness_bar.value -= rest_amount
	update_speed_value()
	update_precision_value()
	enable_next_choice_panel()


func update_speed_value():
	writing_speed = get_writing_speed_value(tiredness_bar.value)
	writing_speed_value.text = "Writing Speed:" + str(writing_speed)


func get_writing_speed_value(value:int) -> int:
	var result:int = 20 - (float(value)/10.0)
	if writing_speed == 0:
		writing_speed = 10
	return result


func enable_next_choice_panel():
	if choice_panels_index >= choice_panels.size():
		choice_panels_index = 1
		test_start_button.disabled = false
	else:
		var next_choice_panel = choice_panels[choice_panels_index]
		next_choice_panel.study_button.disabled = false
		next_choice_panel.rest_button.disabled = false
		choice_panels_index += 1


func _on_button_pressed():
	emit_signal("finished_preparation", writing_speed, precision)
	emit_signal("stress_defined", tiredness_bar.value)


func populate_score_warn(scores:Array):
	var necessary_score:float = 14.0 - scores[0]
	score_warning.text = "You need to score " + str(necessary_score)
	score_warning.visible = true


func update_formula(scores:Array):
	first_test_value.text = str(scores[0])


func paper_sheet_sound_play():
	paper_sheet_sound.play()


#code to make paper move when hovered upon
#not used
#func _input(event):
#	if event is InputEventMouseMotion:
#		var new_rect = Rect2(piece_of_paper.get_rect().position + piece_of_paper.position, piece_of_paper.get_rect().size)
#		if new_rect.has_point(get_viewport().get_mouse_position()):
#			print_debug("detected!")
