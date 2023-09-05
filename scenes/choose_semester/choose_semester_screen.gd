extends CanvasLayer


var available_disciplines:Array = []
var current_disciplines:Array = []


@onready var available_disciplines_list = $MarginContainer/HBoxContainer/AvailableDisciplinesPanel/MarginContainer/VBoxContainer/ScrollContainer/AvailableDisciplinesList
@onready var current_disciplines_list = $MarginContainer/HBoxContainer/CurrentDisciplinesPanel/MarginContainer/VBoxContainer/ScrollContainer/CurrentDisciplinesList
@onready var available_disciplines_container = $MarginContainer/HBoxContainer/AvailableDisciplinesPanel
@onready var current_disciplines_container = $MarginContainer/HBoxContainer/CurrentDisciplinesPanel


func _ready():
	current_disciplines_container.connect("item_dropped_on_current", Callable(self, "on_item_dropped_on_current"))
	available_disciplines_container.connect("item_dropped_on_available", Callable(self, "on_item_dropped_on_available"))


func initialize(disciplines_still_available:Array):
	available_disciplines = disciplines_still_available
	populate_lists()


func populate_lists():
	var counter:int = 0
	for entry in available_disciplines:
		var semester_entry = preload("res://scenes/choose_semester/semester_entry.tscn").instantiate()
		available_disciplines_list.add_child(semester_entry)
		semester_entry.initialize(entry, counter)
		semester_entry.connect("dropped_on_top", Callable(self, "treat_dropped_on_top"))
		counter += 1


func treat_dropped_on_top(data, entry):
	if entry.on_current:
		on_item_dropped_on_current(data)
	if entry.on_available:
		on_item_dropped_on_available(data)
		available_disciplines_container.treat_dropped_on_top(data, entry)


func on_item_dropped_on_current(dropped_item):
	var iterable_array = []
	for item in available_disciplines_list.get_children():
		if item.visible == true:
			iterable_array.append(item)
	for item in iterable_array:
		if item.original_order == dropped_item.original_order:
			available_disciplines_list.remove_child(item)
			var index:int = find_index(item, available_disciplines)
			var temporary_current_disciplines = current_disciplines.duplicate()
			temporary_current_disciplines.append(available_disciplines[index])
			current_disciplines = temporary_current_disciplines
			var temporary_available_disciplines = available_disciplines.duplicate()
			temporary_available_disciplines.remove_at(index)
			available_disciplines = temporary_available_disciplines
			item.queue_free()
			break


func on_item_dropped_on_available(dropped_item):
	var iterable_array = []
	for item in current_disciplines_list.get_children():
		if item.visible == true:
			iterable_array.append(item)
	for item in iterable_array:
		if item.original_order == dropped_item.original_order:
			current_disciplines_list.remove_child(item)
			var index:int = find_index(item, current_disciplines)
			var temporary_available_disciplines = available_disciplines.duplicate()
			temporary_available_disciplines.append(current_disciplines[index])
			available_disciplines = temporary_available_disciplines
			var temporary_current_disciplines = current_disciplines.duplicate()
			temporary_current_disciplines.remove_at(index)
			current_disciplines = temporary_current_disciplines
			item.queue_free()
			break


func find_index(search_item, array:Array) -> int:
	var index:int = -1
	var counter = 0
	for item in array:
		if item[0] == search_item.discipline_name.text:
			index = counter
			break
		counter += 1
	return index
	


func _on_button_pressed():
	print_debug("current_disciplines:")
	for current in current_disciplines:
		print(current[0] + current[1])
	print_debug("available_disciplines:")
	for available in available_disciplines:
		print(available[0] + available[1])
