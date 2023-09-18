extends CanvasLayer


signal finished_preparation



func _on_button_pressed():
	emit_signal("finished_preparation")
