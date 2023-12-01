extends PanelContainer
class_name ChoiceContainer


signal study_selected
signal rest_selected
signal study_mouse_entered
signal rest_mouse_entered
signal study_mouse_left
signal rest_mouse_left


var red_circling_image = preload("res://resources/images/red circling.png")
var correction_offset:float = 2

@onready var red_circling_sprite = $RedCirclingSprite
@onready var week_label:Label = $MarginContainer/VBoxContainer/WeekLabel
@onready var study_button = $MarginContainer/VBoxContainer/StudyButton
@onready var rest_button = $MarginContainer/VBoxContainer/RestButton
@onready var margin:MarginContainer = $MarginContainer
@onready var button_hover_sound = $ButtonHoverSound
@onready var button_pressed_sound = $ButtonPressedSound


func initialize(week_value:String):
	week_label.text = week_value
	study_button.disabled = true
	rest_button.disabled = true


func _on_study_button_pressed():
	button_pressed_sound.play()
	red_circling_sprite.visible = true
	red_circling_sprite.position.y = study_button.global_position.y - study_button.size.y - margin.get_theme_constant("margin_top") + correction_offset
	red_circling_sprite.position.x = study_button.position.x + (study_button.size.x/2) + margin.get_theme_constant("margin_left") + correction_offset
	emit_signal("study_selected")
	study_button.disabled = true
	rest_button.disabled = true


func _on_rest_button_pressed():
	button_pressed_sound.play()
	red_circling_sprite.visible = true
	red_circling_sprite.position.y = rest_button.global_position.y - rest_button.size.y - margin.get_theme_constant("margin_top") + correction_offset
	red_circling_sprite.position.x = rest_button.position.x + (rest_button.size.x/2) + margin.get_theme_constant("margin_left") + correction_offset
	emit_signal("rest_selected")
	rest_button.disabled = true
	study_button.disabled = true


func _on_study_button_mouse_entered():
	if not study_button.disabled:
		button_hover_sound.play()
		emit_signal("study_mouse_entered")


func _on_study_button_mouse_exited():
	if not study_button.disabled:
		emit_signal("study_mouse_left")


func _on_rest_button_mouse_entered():
	if not study_button.disabled:
		button_hover_sound.play()
		emit_signal("rest_mouse_entered")


func _on_rest_button_mouse_exited():
	if not study_button.disabled:
		emit_signal("rest_mouse_left")
