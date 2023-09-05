extends PanelContainer


signal item_dropped_on_available(item)


@onready var available_disciplines_list = $MarginContainer/VBoxContainer/ScrollContainer/AvailableDisciplinesList


func _can_drop_data(at_position, data):
	if data.on_current:
		return true


func _drop_data(at_position, data):
	var semester_entry = load("res://scenes/choose_semester/semester_entry.tscn").instantiate()
	available_disciplines_list.add_child(semester_entry)
	semester_entry.original_order = data.original_order
	semester_entry.discipline_name.text = data.discipline_name.text
	semester_entry.discipline_level.text = data.discipline_level.text
	semester_entry.on_available = true
	semester_entry.on_current = false
	semester_entry.connect("dropped_on_top", Callable(self, "treat_dropped_on_top"))
	
	emit_signal("item_dropped_on_available", data)


func treat_dropped_on_top(data, entry):
	if entry.on_available:
		_drop_data(Vector2.ZERO, data)
