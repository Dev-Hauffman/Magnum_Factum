extends Node2D
class_name CameraController


@export var movement_speed: int = 20
@export var drag_speed: int = 20


var mouse_initial_position: Vector2
var mouse_final_position: Vector2


var camera: Camera2D


func initialize(target_camera:Camera2D):
	camera = target_camera


func set_camera_limits(top_limit: int, right_limit: int, bottom_limit: int, left_limit: int) -> void:
	camera.limit_top = top_limit
	camera.limit_left = left_limit
	camera.limit_right = right_limit
	camera.limit_bottom = bottom_limit


func set_bottom_limit(bottom_limit):
	camera.limit_bottom = bottom_limit


func _process(delta):
	handle_movement(delta)


func handle_movement(delta):
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var target_position_x = camera.position.x + inputX * movement_speed * camera.zoom.x
	var target_position_y = camera.position.y + inputY * movement_speed * camera.zoom.y
	
	if not Input.is_action_pressed("pan_button"):
		camera.position.x = lerp(camera.position.x, target_position_x, movement_speed * delta)
		camera.position.y = lerp(camera.position.y, target_position_y, movement_speed * delta)
		
	camera.position.x = clamp(camera.position.x, camera.limit_left  + get_viewport_rect().size.x/2, camera.limit_right - get_viewport_rect().size.x/2)
	camera.position.y = clamp(camera.position.y, camera.limit_top + get_viewport_rect().size.y/2, camera.limit_bottom - get_viewport_rect().size.y/2)
	
	if inputX == 0 and inputY == 0:
		if Input.is_action_just_pressed("pan_button"):
			mouse_initial_position = get_global_mouse_position()
		if Input.is_action_pressed("pan_button"):
			mouse_final_position = get_global_mouse_position()
			var final_position:Vector2 = mouse_initial_position - mouse_final_position
			camera.position = lerp(camera.position, camera.position + final_position, drag_speed * delta)
