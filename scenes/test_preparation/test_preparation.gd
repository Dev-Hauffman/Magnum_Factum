extends CanvasLayer


signal finished_preparation(writting_speed, precision)
signal stress_defined(stress_amount)


var number_of_weeks:int = 4
var rest_amount:int = 20
var stress_amount:int = 10
var writting_speed:int = 10
var precision:int


@onready var test_name_label:Label = $VBoxContainer/TestNameLabel
@onready var choice_container:HBoxContainer = $VBoxContainer/ChoiceContainer
@onready var tiredness_bar:ProgressBar = $HBoxContainer3/VBoxContainer2/TirednessContainer/TirednessBar
@onready var knowledge_bar:ProgressBar = $HBoxContainer3/VBoxContainer2/KnowledgeContainer/KnowledgeBar


func initialize(test_name:String, test_number:String, stress_level:int):
	test_name_label.text = "Test " + test_number + " - " + test_name
	print_debug("testpreparation: " + str(stress_level))
	tiredness_bar.value = stress_level
	update_speed_value()
	populate_choices()


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
		counter += 1


func study_selected():
	knowledge_bar.value += 100 / number_of_weeks
	if tiredness_bar.value < 100: 
		tiredness_bar.value += stress_amount
	update_precision_value()
	update_speed_value()


func update_precision_value():
	if knowledge_bar.value > 75:
		precision = 80
	elif knowledge_bar.value >= 50:
		precision = 60
	elif knowledge_bar.value >= 25:
		precision = 40
	else:
		precision = 20
	knowledge_bar.tooltip_text = "Your answer precision is " + str(precision)


func rest_selected():
	if tiredness_bar.value - rest_amount < 0:
		tiredness_bar.value = 0
	else:
		tiredness_bar.value -= rest_amount
	update_speed_value()


func update_speed_value():
	writting_speed = 10 - (tiredness_bar.value/10)
	if writting_speed == 0:
		writting_speed = 1
	tiredness_bar.tooltip_text = "Your writing speed is at " + str(writting_speed)

func _on_button_pressed():
	emit_signal("finished_preparation", writting_speed, precision)
	emit_signal("stress_defined", tiredness_bar.value)
