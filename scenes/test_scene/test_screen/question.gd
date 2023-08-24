extends PanelContainer


@onready var question_number = $QuestionMarginContainer/ContentContainer/NumberLabel
@onready var content_container = $QuestionMarginContainer/ContentContainer


func initialize(content:QuestionInfo):
	question_number.text = "Question " + str(content.number)	
	var margin:MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.add_theme_constant_override("margin_left",20)
	margin.add_theme_constant_override("margin_top",20)
	margin.add_theme_constant_override("margin_right",20)
	margin.add_theme_constant_override("margin_bottom",20)
	var underlines:VBoxContainer = VBoxContainer.new()
	margin.add_child(underlines)
	#underlines.add_theme_constant_override("separation", 1)
	var extra_space:Label = Label.new()
	underlines.add_child(extra_space)
	extra_space.add_theme_font_size_override("font_size", 16)
	var number_of_lines:int = 0
	for question in content.paragraph:
		var question_text = Label.new()
		content_container.add_child(question_text)
		question_text.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		question_text.text = question
		question_text.add_theme_constant_override("line_spacing", 1)
		await get_tree().create_timer(0.01).timeout
		number_of_lines += question_text.get_line_count()
	for line in number_of_lines:
		var filler_label:Label = Label.new()
		underlines.add_child(filler_label)
		filler_label.add_theme_font_size_override("font_size", 14)
		filler_label.add_theme_constant_override("line_spacing", 3)
		var style_box = load("res://resources/question_underline.tres")
		filler_label.add_theme_stylebox_override("normal", style_box)
