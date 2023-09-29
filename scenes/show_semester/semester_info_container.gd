extends PanelContainer


signal finished_animation


var moving:bool = false
var tween:Tween



@onready var semester_label = $MarginContainer/VBoxContainer/SemesterLabel
@onready var disciplines_container = $MarginContainer/VBoxContainer/DisciplinesContainer


func initialize(current_semester:int, disciplines:Array):
	semester_label.text = "Semester " + str(current_semester)
	populate_disciplines(disciplines)
	position = Vector2(position.x, position.y - get_viewport_rect().size.y)


func populate_disciplines(disciplines):
	for discipline in disciplines:
		var label = Label.new()
		label.text = discipline
		disciplines_container.add_child(label)


func move_to(target:float):
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, target) , 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.play()
	moving = true


func _process(delta):
	if moving:
		if not tween.is_running():
			moving = false
			emit_signal("finished_animation")
