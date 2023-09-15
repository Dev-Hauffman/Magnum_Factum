extends Node

# this class handle game over or success, other than global info
var current_semester:int = 1


@onready var semester_manager = $SemesterManager


func _ready():
	set_current_semester_disciplines()
	


func set_current_semester_disciplines():
	var semester_disciplines = Disciplines.get_discipline_by_semester(current_semester)
	
