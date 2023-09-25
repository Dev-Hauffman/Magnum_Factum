extends PanelContainer
class_name ChoiceContainer


signal study_selected
signal rest_selected


@onready var week_label:Label = $MarginContainer/VBoxContainer/WeekLabel
@onready var study_button = $MarginContainer/VBoxContainer/StudyButton
@onready var rest_button = $MarginContainer/VBoxContainer/RestButton


func initialize(week_value:String):
	week_label.text = week_value


func _on_study_button_pressed():
	emit_signal("study_selected")
	study_button.disabled = true
	rest_button.disabled = true


func _on_rest_button_pressed():
	emit_signal("rest_selected")
	rest_button.disabled = true
	study_button.disabled = true
