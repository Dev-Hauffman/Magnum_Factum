extends Label
class_name ConfidenceLabel


@onready var confidence_animation_player:AnimationPlayer = $ConfidenceAnimationPlayer


func _ready():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 50), 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.play()
	confidence_animation_player.play("Ascend")


func initialize(confidence_value:int, paragraph_position:Vector2, paragraph_rectangle:Rect2):
	add_theme_font_size_override("font_size", 6)
	text ="confidence: " + str(confidence_value) + "%"
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", 3)
	if confidence_value >= 70:
		add_theme_color_override("font_color", Color.DARK_GREEN)
	elif confidence_value >= 40:
		add_theme_color_override("font_color", Color.YELLOW)
	else:
		add_theme_color_override("font_color", Color.FIREBRICK)
	position.x = paragraph_position.x + paragraph_rectangle.size.x/2 - get_rect().size.x/2
	position.y = paragraph_position.y + paragraph_rectangle.size.y/2 - get_rect().size.y/2


func _process(_delta):
	if not confidence_animation_player.is_playing():
		queue_free()
