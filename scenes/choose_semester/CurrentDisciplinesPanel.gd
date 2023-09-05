extends PanelContainer


signal item_dropped_on_current(item)


@onready var current_disciplines_list = $MarginContainer/VBoxContainer/ScrollContainer/CurrentDisciplinesList


func _can_drop_data(at_position, data):
	if data.on_available:
		return true


func _drop_data(at_position, data):
	var semester_entry = load("res://scenes/choose_semester/semester_entry.tscn").instantiate()
	current_disciplines_list.add_child(semester_entry)
	semester_entry.original_order = data.original_order
	semester_entry.discipline_name.text = data.discipline_name.text
	semester_entry.discipline_level.text = data.discipline_level.text
	semester_entry.on_available = false
	semester_entry.on_current = true
	semester_entry.connect("dropped_on_top", Callable(self, "treat_dropped_on_top"))
	
	emit_signal("item_dropped_on_current", data)


func treat_dropped_on_top(data, entry):
	if entry.on_current:
		_drop_data(Vector2.ZERO, data)
