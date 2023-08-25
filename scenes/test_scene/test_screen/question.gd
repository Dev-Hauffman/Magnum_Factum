extends PanelContainer

signal clicked

var maximum_score:float = 0
var current_score:float = 0
var paragraphs:Array[RichTextLabel] = []
var current_paragraph:int = 0
var can_click:bool = true


@onready var question_number = $QuestionMarginContainer/ContentContainer/NumberLabel
@onready var content_container = $QuestionMarginContainer/ContentContainer


# to fix the difference in height between the underlines and the text I had to mess with the font sizes of 
# overlap "placeholder" container containing the underlines and empty labels, to aid me finding the right
# font size, I simulated the creation of a vbox and put labels inside with a random letter inside "T" 
# (capital) to make that letter match the size of the text inside the label representing the question text
func initialize(content:QuestionInfo):
	maximum_score = content.score
	question_number.text = "Question " + str(content.number)
	
	var margin:MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.add_theme_constant_override("margin_left",20)
	margin.add_theme_constant_override("margin_top",20)
	margin.add_theme_constant_override("margin_right",20)
	margin.add_theme_constant_override("margin_bottom",20)
	
	var underlines:VBoxContainer = VBoxContainer.new()
	margin.add_child(underlines)
	
	var extra_space:Label = Label.new()
	underlines.add_child(extra_space)
	extra_space.add_theme_font_size_override("font_size", 15) #test/ mess around with this # bottom width = 1, font size = 16
	
	var number_of_lines:int = 0
	for question in content.paragraph:
		var question_text:RichTextLabel = RichTextLabel.new()
		content_container.add_child(question_text)
		question_text.fit_content = true
		question_text.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		question_text.text = question
		question_text.add_theme_constant_override("line_separation", 1) #avoid changing this
		await get_tree().create_timer(0.01).timeout # it's here because only in the next frame it updates the wrapping (from what I remember)
		number_of_lines += question_text.get_line_count()
		question_text.visible_characters = 0
		paragraphs.append(question_text)
		
	for line in number_of_lines:
		var filler_label:Label = Label.new()
		underlines.add_child(filler_label)
		filler_label.add_theme_font_size_override("font_size", 13) #test/ mess around with this # bottom width = 1, font size = 16
		filler_label.add_theme_constant_override("line_spacing", 3) #avoid changing this
		var style_box = load("res://resources/question_underline.tres")
		filler_label.add_theme_stylebox_override("normal", style_box)


func _on_gui_input(event):
	if can_click:
		if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
			if current_paragraph < paragraphs.size():
				paragraphs[current_paragraph].visible_characters += 5
				emit_signal("clicked")
				if paragraphs[current_paragraph].visible_ratio >= 1:
					current_score += maximum_score / paragraphs.size()
					current_paragraph += 1
					print_debug(current_score)
					if current_paragraph == paragraphs.size():
						print_debug(current_score)
