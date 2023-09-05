extends Node


var choose_semester_scene

var available_disciplines:Array = []
var current_disciplines:Array = []


func _ready():
	available_disciplines = Disciplines.get_existing_disciplines()
	add_choose_semester_scene()


func add_choose_semester_scene():
	choose_semester_scene = preload("res://scenes/choose_semester/choose_semester_screen.tscn").instantiate()
	add_child(choose_semester_scene)
	choose_semester_scene.initialize(available_disciplines)
	
