extends ColorRect


func _input(event):
	if event.is_action_pressed("left_mouse_button"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
