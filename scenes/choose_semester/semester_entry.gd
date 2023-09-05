extends PanelContainer


signal dropped_on_top(data, entry)


var original_order:int
var dropped_on_target:bool = false
var on_current:bool = false
var on_available:bool = true


@onready var discipline_name = $MarginContainer/HBoxContainer/DisciplineName
@onready var discipline_level = $MarginContainer/HBoxContainer/DisciplineLevel


func initialize(content:Array, order):
	discipline_name.text = content[0]
	discipline_level.text = "[center]" + content[1] + "[/center]"
	original_order = order


func _get_drag_data(at_position:Vector2):
	if not dropped_on_target:
		set_drag_preview(get_preview_control())
		return self


func on_item_dropped_on_target(draggable):
	if draggable.original_order != original_order:
		return
	queue_free()


func get_preview_control():
	var preview = SemesterEntryPreview.new(discipline_name.text, discipline_level.text)
	return preview


func _can_drop_data(at_position, data):
	if data.on_available and not on_available:
		return true
	elif data.on_current and not on_current:
		return true


func _drop_data(at_position, data):
	emit_signal("dropped_on_top", data, self)
