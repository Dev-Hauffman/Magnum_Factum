extends PanelContainer

signal clicked(leading_character_position)
signal populated


var maximum_score:float = 0
#var current_score:float = 0
var paragraphs:Array[RichTextLabel] = []
var paragraph_sizes:Array[int] =[]
var paragraph_info:Array = []
var current_paragraph_index:int = 0
var can_click:bool = true
var margin_value:int = 8
var finished_question:bool = false
var can_reset:bool = false
var can_show:bool = false
var time_is_up:bool = false

var style_box = load("res://resources/question_underline.tres")
var green_box = load("res://resources/paragraph_green_selection.tres")
var yellow_box = load("res://resources/paragraph_yellow_selection.tres")
var red_box = load("res://resources/paragraph_red_selection.tres")
#var notepen_font = load("res://resources/fonts/Notepen.ttf")
#var note_taker_font_1 = load("res://resources/fonts/note-taker.otf")
#var note_taker_font_2 = load("res://resources/fonts/note-taker.ttf")
var caveat_font = load("res://resources/fonts/Caveat-VariableFont_wght.ttf")

var visible_character_amount:int = 5

var current_character:RichTextLabel
var character_current_position
var character_next_position
var character_initial_position
var current_letter:int = 0
var current_letter_index:int = 0
var current_line:int = 0
var current_height = 0
var can_update_character_position:bool = false
var initial_letter:int = 0


@onready var question_number = $QuestionMarginContainer/ContentContainer/HBoxContainer/NumberLabel
@onready var score_label = $QuestionMarginContainer/ContentContainer/HBoxContainer/ScoreLabel
@onready var content_container = $QuestionMarginContainer/ContentContainer


# to fix the difference in height between the underlines and the text I had to mess with the font sizes of 
# overlap "placeholder" container containing the underlines and empty labels, to aid me finding the right
# font size, I simulated the creation of a vbox and put labels inside with a random letter inside "T" 
# (capital) to make that letter match the size of the text inside the label representing the question text
func initialize(content:QuestionInfo):
	maximum_score = content.score
	question_number.text = "Question " + str(content.number)
	score_label.text = "(" + "Score: " + str(content.score) + ")"
	
	var margin:MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", margin_value)
	margin.add_theme_constant_override("margin_top", margin_value)
	margin.add_theme_constant_override("margin_right", margin_value)
	margin.add_theme_constant_override("margin_bottom", margin_value)
	
	var underlines:VBoxContainer = VBoxContainer.new()
	margin.add_child(underlines)
	underlines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var extra_space:Label = Label.new()
	underlines.add_child(extra_space)
	extra_space.mouse_filter = Control.MOUSE_FILTER_IGNORE
	extra_space.add_theme_font_size_override("font_size", 9) #test/ mess around with this # bottom width = 1, font size = 16
	
	var number_of_lines:int = 0
	var counter:int = 0
	for question in content.paragraph:
		var question_text:RichTextLabel = RichTextLabel.new()
		content_container.add_child(question_text)
		question_text.fit_content = true
		question_text.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		question_text.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		question_text.text = question["phrase"]
		question_text.add_theme_constant_override("line_separation", 1) #avoid changing this
		question_text.add_theme_font_override("normal_font", caveat_font)
		question_text.add_theme_color_override("default_color", Color.BLACK)
		question_text.add_theme_font_size_override("normal_font_size", 6)
		question_text.mouse_filter = Control.MOUSE_FILTER_PASS
		question_text.connect("mouse_entered", Callable(self, "show_paragraph_confidence").bind(question_text, counter))
		question_text.connect("mouse_exited", Callable(self, "hide_paragraph_confidence").bind(question_text, counter))
		question_text.gui_input.connect(Callable(self, "rewrite_paragraph").bind(question_text, counter))
		#eliminate this
		await get_tree().create_timer(0.01).timeout # it's here because only in the next frame it updates the wrapping (from what I remember)
		number_of_lines += question_text.get_line_count()
		question_text.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
		question_text.visible_characters = 0 # cannot be before "get_line_count()"
		paragraphs.append(question_text)
		paragraph_sizes.append(question["size"])
		counter += 1
	emit_signal("populated")
	#TO-DO: make its own method for this and called it next frame to eliminate timer
	for line in number_of_lines:
		var underline_label:Label = Label.new() 
		underlines.add_child(underline_label)
		underline_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		underline_label.add_theme_font_size_override("font_size", 3) #test/ mess around with this # bottom width = 1, font size = 16
		underline_label.add_theme_constant_override("line_spacing", 3) #avoid changing this
		underline_label.add_theme_font_override("font", caveat_font)
		underline_label.add_theme_stylebox_override("normal", style_box)
	#TO-DO: make its own method for this and called it next frame to eliminate timer
	current_character = RichTextLabel.new()
	add_child(current_character)
	current_character.fit_content = true
	current_character.autowrap_mode = TextServer.AUTOWRAP_OFF
	current_character.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	current_character.add_theme_font_override("normal_font", caveat_font)
	current_character.add_theme_font_size_override("normal_font_size", 6)
	current_character.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current_character.add_theme_color_override("default_color", Color.RED)
	character_current_position = paragraphs[0].global_position
	character_next_position = paragraphs[0].global_position
	character_initial_position = paragraphs[0].global_position
	#current_height = character_initial_position.y
	can_update_character_position = true


func _process(delta):
	if can_update_character_position and current_character != null:
		current_character.global_position = character_current_position
		#current_character.global_position.y = paragraphs[current_paragraph_index].global_position.y + current_height
		#character_current_position.y = paragraphs[current_paragraph_index].global_position.y
	for confidence_label in paragraph_info:
		confidence_label["label"].global_position = confidence_label["position"]


func show_paragraph_confidence(target:RichTextLabel, index:int):
	if finished_question and not time_is_up:
		if can_show and paragraph_info[index]["can_rewrite"] == false:
			var confidence_label = paragraph_info[index]["label"]
			var paragraph_confidence_level:int = int(confidence_label.text)
			confidence_label.visible = true
			if paragraph_confidence_level >= 70:
				target.add_theme_stylebox_override("normal", green_box)
				confidence_label.add_theme_color_override("font_color", Color.DARK_GREEN)
			elif paragraph_confidence_level >= 40:
				target.add_theme_stylebox_override("normal", yellow_box)
				confidence_label.add_theme_color_override("font_color", Color.YELLOW)
			else:
				target.add_theme_stylebox_override("normal", red_box)
				confidence_label.add_theme_color_override("font_color", Color.FIREBRICK)


func hide_paragraph_confidence(target:RichTextLabel, index:int):
	if finished_question:
		target.remove_theme_stylebox_override("normal")
		paragraph_info[index]["label"].visible = false


func rewrite_paragraph(event, target:RichTextLabel, index:int):
	if finished_question and not time_is_up:
		if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
			if can_reset and int(paragraph_info[index]["label"].text) < 100:
				if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
					can_reset = false
					paragraph_info[index]["can_rewrite"] = true
					#current_score -= maximum_score / paragraphs.size()
					target.visible_characters = 0
					target.text = QuestionPhrases.choose_phrase_by_size(paragraph_sizes[index])
					current_character.visible = true
					current_paragraph_index = index
					current_letter = 0
					current_line = 0
					current_letter_index = 0
					initial_letter = 0
					current_height = 0
					character_current_position = paragraphs[index].global_position
					character_next_position = paragraphs[index].global_position
					character_initial_position = paragraphs[index].global_position
					hide_paragraph_confidence(target, index)
			elif paragraph_info[index]["can_rewrite"] == true:
				emit_signal("clicked", current_character.global_position)
				for i in visible_character_amount:
					fill_paragraph_again(index)
					if paragraphs[index].visible_ratio >= 1:
						character_current_position = character_next_position
						can_show = true
						current_character.visible = false
						paragraph_info[index]["can_rewrite"] = false
						#current_score += maximum_score / paragraphs.size()
						recalculate_confidence(index)
						#print_debug("final score: " + str(current_score))
						await get_tree().create_timer(1).timeout #this represent the animation playing before being able to review a question
						can_reset = true
						break


func fill_paragraph_again(index:int):
	paragraphs[index].visible_characters += 1
	var current_paragraph:RichTextLabel = paragraphs[index]
	if current_letter >= current_paragraph.text.length():
		printerr("Current letter index is greater than the size of the current paragraph. Index out of bounds")
		return
	var paragraph_current_string = current_paragraph.text[current_letter]
	current_character.text = paragraph_current_string
	#update to next position
	var character_size:Vector2
	if current_paragraph.get_character_line(current_letter + 1) > current_line: # added "+1" because of visible_character_behaviour
		set_current_character_to_new_line(character_size, current_paragraph)
	else:
		set_current_character_next_position(character_size, current_paragraph)


func recalculate_confidence(index:int):
	var regex = RegEx.new()
	regex.compile("[0-9]+")
	var result = regex.search(paragraph_info[index]["label"].text)
	var base_value = result.get_string()
	var confidence_value:int = generate_confidence_value(int(base_value))
	paragraph_info[index]["confidence_value"] = confidence_value
	print_debug(paragraph_info[index]["confidence_value"])
	paragraph_info[index]["label"].text = "confidence: " + str(confidence_value) + "%"


func _on_gui_input(event):
	if can_click and not time_is_up:
		if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
			if current_paragraph_index < paragraphs.size():
				emit_signal("clicked", current_character.global_position)
				for i in visible_character_amount:
					paragraphs[current_paragraph_index].visible_characters += 1
					if paragraphs[current_paragraph_index].visible_ratio >= 1:
						#current_score += maximum_score / paragraphs.size()
						create_confidence_value()
						update_character_position() #has to be before increase in current_paragraph_index or won't update
						current_paragraph_index += 1
						#print_debug(current_score)
						if current_paragraph_index == paragraphs.size():
							finished_question = true
							can_show = true
							can_click = false
							current_character.visible = false
							#print_debug(current_score)
							await get_tree().create_timer(1).timeout #this represent the animation playing before being able to review a question
							can_reset = true
						break
					else:
						update_character_position()


func update_character_position():
	#get current letter and set current letter to the richlabel
	
	var current_paragraph:RichTextLabel = paragraphs[current_paragraph_index]
	if current_letter >= current_paragraph.text.length():
		printerr("Current letter index is greater than the size of the current paragraph. Index out of bounds")
		return
	#var paragraph_current_string = current_paragraph.text.substr(current_letter, visible_character_amout)
	var paragraph_current_string = current_paragraph.text[current_letter]
	current_character.text = paragraph_current_string
	#update to next position
	var character_size:Vector2
	#print_debug("Initial letter: %d" % initial_letter)
	
	if current_paragraph.get_character_line(current_letter + 1) > current_line: # added "+1" because of visible_character_behaviour
		set_current_character_to_new_line(character_size, current_paragraph)
		
	elif paragraphs[current_paragraph_index].visible_ratio >= 1:
		character_current_position = character_next_position
		current_line = 0
		current_letter_index = 0
		current_letter = 0
		initial_letter = 0
		if current_paragraph_index + 1 < paragraphs.size():
			current_paragraph = paragraphs[current_paragraph_index + 1]
		else:
			current_paragraph = paragraphs[current_paragraph_index]
#		paragraph_current_string = current_paragraph.text[current_letter]
#		current_character.text = paragraph_current_string
		
		character_initial_position = current_paragraph.global_position
		#character_size = current_paragraph.get_theme_font("normal_font").get_string_size(current_paragraph.text.substr(initial_letter, current_letter_index + 1),1,-1,6)
		#var line_separation = current_paragraph.get_theme_constant("line_separation")
		#var string_x_size = character_initial_position.x
		#var string_y_size = character_size.y
		current_height = 0
		character_next_position = character_initial_position
		
	else:
		set_current_character_next_position(character_size, current_paragraph)
		


func set_current_character_to_new_line(character_size:Vector2, current_paragraph:RichTextLabel):
	initial_letter = current_letter
	current_letter_index = 0
	current_letter += 1
	current_line += 1
	character_size = current_paragraph.get_theme_font("normal_font").get_string_size(current_paragraph.text.substr(initial_letter, current_letter_index + 1),1,-1,6)
	var line_separation = current_paragraph.get_theme_constant("line_separation")
	var string_x_size = character_initial_position.x
	var string_y_size = character_size.y
	current_height += line_separation + string_y_size
	character_next_position = Vector2(string_x_size, current_paragraph.global_position.y + current_height)
	character_current_position = character_next_position
	
	character_size = current_paragraph.get_theme_font("normal_font").get_string_size(current_paragraph.text.substr(initial_letter, current_letter_index + 1),1,-1,6)
	character_next_position.x = character_initial_position.x + character_size.x
	character_next_position.y = current_paragraph.global_position.y + current_height
	
	current_letter_index += 1


func set_current_character_next_position(character_size:Vector2, current_paragraph:RichTextLabel):
	character_current_position = character_next_position
	character_size = current_paragraph.get_theme_font("normal_font").get_string_size(current_paragraph.text.substr(initial_letter, current_letter_index + 1),1,-1,6)
	#print_debug(current_paragraph.text.substr(initial_letter, current_letter_index + 1))
	character_next_position.x = character_initial_position.x + character_size.x
	character_next_position.y = current_paragraph.global_position.y + current_height
	current_letter_index += 1
	current_letter += 1


func create_confidence_value():
	var confidence_dict:Dictionary = {}
	var confidence_value:int = generate_confidence_value()
	confidence_dict["confidence_value"] = confidence_value
	var confidence_label:Label = Label.new()
	confidence_label.add_theme_font_size_override("font_size", 6)
	confidence_label.text ="confidence: " + str(confidence_value) + "%"
	confidence_label.add_theme_color_override("font_outline_color", Color.BLACK)
	confidence_label.add_theme_constant_override("outline_size", 3)
	confidence_label.visible = false
	add_child(confidence_label)
	confidence_dict["label"] = confidence_label
	var value_position_x = paragraphs[current_paragraph_index].global_position.x + paragraphs[current_paragraph_index].get_rect().size.x/2 - confidence_label.get_rect().size.x/2
	var value_position_y = paragraphs[current_paragraph_index].global_position.y + paragraphs[current_paragraph_index].get_rect().size.y/2 - confidence_label.get_rect().size.y/2
	confidence_dict["position"] = Vector2(value_position_x, value_position_y)
	var can_rewrite:bool = false
	confidence_dict["can_rewrite"] = can_rewrite
	paragraph_info.append(confidence_dict)


func generate_confidence_value(base_value:int = 10) -> int:
	var confidence_value:int = (randi_range(base_value, 109) / 10) * 10
	return confidence_value


func get_score() -> float:
	var score:float = 0
	for confidence_value in paragraph_info:
		var random_value = randi_range(0, 100)
		print_debug("random value is: " + str(random_value))
		print_debug("confidence value is: " + str(confidence_value["confidence_value"]))
		if random_value <= confidence_value["confidence_value"]:
			score += maximum_score / paragraphs.size()
			print_debug("score is now: %f" % score)
	return score
