extends CanvasLayer


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_manager.tscn")


func _on_exit_game_button_pressed():
	get_tree().quit(0)
