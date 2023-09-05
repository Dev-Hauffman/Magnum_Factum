extends PanelContainer
class_name SemesterEntryPreview

func _init(name:String, level:String):
	var name_label = Label.new()
	name_label.add_theme_font_size_override("font_size", 8)
	name_label.text = name
	add_child(name_label)
