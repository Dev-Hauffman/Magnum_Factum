extends Node


const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")


func _ready():
	var main_menu = MAIN_MENU.instantiate()
	add_child(main_menu)
