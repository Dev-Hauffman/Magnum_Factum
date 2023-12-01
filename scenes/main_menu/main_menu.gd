extends CanvasLayer


@onready var title_call_sound_player:AudioStreamPlayer = $TitleCallSoundPlayer
@onready var explosion_player = $ExplosionPlayer
@onready var button_click_player = $ButtonClickPlayer
@onready var white_screen_player = $WhiteScreenPlayer


func _on_start_game_button_pressed():
	button_click_player.play()
	white_screen_player.play("fade_in")
	await white_screen_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/game_manager.tscn")


func _on_exit_game_button_pressed():
	button_click_player.play()
	await button_click_player.finished
	get_tree().quit(0)


func call_title_sound():
	title_call_sound_player.play()


func call_explosion_sound():
	explosion_player.play()
