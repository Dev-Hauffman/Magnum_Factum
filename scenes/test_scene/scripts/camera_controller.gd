extends Node2D
class_name CameraController


signal moved_and_zoomed
signal finished_moving


@export var movement_speed: int = 20
@export var drag_speed: int = 20

@export var SPEED:float = 20.0
@export var ZOOM_SPEED:float = 20.0  
@export var ZOOM_MARGIN:float = 0.1
@export var ZOOM_MIN:float = 1.0
@export var ZOOM_MAX:float = 2.5


var mousePos = Vector2()
var mousePosGlobal = Vector2()
var mouse_initial_position: Vector2
var mouse_final_position: Vector2

var zoomFactor = 1.0
var zoomPos = Vector2()
var zooming = false

var shake_intensity:float = 0.0
var should_shake:bool = false

var timer = Timer.new()
var timer_wait_time = 0.2

var target = Vector2.ZERO
var camera: Camera2D

var can_move:bool = false
var can_zoom:bool = false
var player_moved:bool = false
var move_tween:Tween


func initialize(target_camera:Camera2D):
	camera = target_camera
	add_child(timer)
	timer.wait_time = timer_wait_time
	timer.one_shot = true


func set_camera_limits(top_limit: int, right_limit: int, bottom_limit: int, left_limit: int) -> void:
	camera.limit_top = top_limit
	camera.limit_left = left_limit
	camera.limit_right = right_limit
	camera.limit_bottom = bottom_limit


func set_bottom_limit(bottom_limit):
	camera.limit_bottom = bottom_limit


func set_camera_position(target_position:Vector2):
	camera.global_position = target_position


func move_and_zoom(target_position:Vector2, zoom:Vector2):
	var tween = create_tween()
	tween.parallel().tween_property(camera, "zoom", zoom ,0.8).set_ease(Tween.EASE_OUT_IN)
	tween.parallel().tween_property(camera, "position", target_position,0.8).set_ease(Tween.EASE_OUT_IN)
	tween.play()
	await tween.finished
	emit_signal("moved_and_zoomed")


func move_to(target_position:Vector2, speed:float):
	if move_tween != null:
		if move_tween.is_running():
			move_tween.stop()
	move_tween = create_tween()
	move_tween.tween_property(camera, "position", target_position, speed).set_ease(Tween.EASE_OUT_IN)
	move_tween.play()
	await move_tween.finished
	emit_signal("finished_moving")


func zoom(zoom:Vector2):
	var tween = create_tween()
	tween.parallel().tween_property(camera, "zoom", zoom ,0.8).set_ease(Tween.EASE_OUT_IN)
	tween.play()


func _input(event):
	if abs(zoomPos.x - get_global_mouse_position().x) > ZOOM_MARGIN:
		zoomFactor = 1.0
	if abs(zoomPos.y - get_global_mouse_position().y) > ZOOM_MARGIN:
		zoomFactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("zoom_in"):
				zoomFactor -= 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
			if event.is_action("zoom_out"):
				zoomFactor += 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
		else:
			zooming = false
			
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()


func _process(delta):
	if can_move:
		handle_movement(delta)
	if can_zoom:
		handle_zoom(delta)
	if not zooming:
		zoomFactor = 1.0
	if should_shake:
		shake(delta)
	if player_moved and move_tween != null:
		move_tween.stop()
		player_moved = false


func handle_movement(delta):
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var target_position_x = camera.position.x + inputX * movement_speed * camera.zoom.x
	var target_position_y = camera.position.y + inputY * movement_speed * camera.zoom.y
	
	if not Input.is_action_pressed("pan_button"):
		camera.position.x = lerp(camera.position.x, target_position_x, movement_speed * delta)
		camera.position.y = lerp(camera.position.y, target_position_y, movement_speed * delta)
		
	#camera.position.x = clamp(camera.position.x, camera.limit_left  + get_viewport_rect().size.x/2, camera.limit_right - get_viewport_rect().size.x/2)
	#camera.position.y = clamp(camera.position.y, camera.limit_top + get_viewport_rect().size.y/2, camera.limit_bottom - get_viewport_rect().size.y/2)
	
	if inputX == 0 and inputY == 0:
		if Input.is_action_just_pressed("pan_button"):
			mouse_initial_position = get_global_mouse_position()
		if Input.is_action_pressed("pan_button"):
			mouse_final_position = get_global_mouse_position()
			var final_position:Vector2 = mouse_initial_position - mouse_final_position
			camera.position = lerp(camera.position, camera.position + final_position, drag_speed * delta)
	
	if inputX != 0 or inputY != 0 or Input.is_action_just_pressed("pan_button"):
		player_moved = true


func handle_zoom(delta):
	camera.zoom.x = lerp(camera.zoom.x, camera.zoom.x * zoomFactor, ZOOM_SPEED*delta)
	camera.zoom.y = lerp(camera.zoom.y, camera.zoom.y * zoomFactor, ZOOM_SPEED*delta)
	
	camera.zoom.x = clamp(camera.zoom.x, ZOOM_MIN, ZOOM_MAX)
	camera.zoom.y = clamp(camera.zoom.y, ZOOM_MIN, ZOOM_MAX)


func shake_camera(intensity:float = 2.0):
	shake_intensity = intensity
	should_shake = true


func shake(delta):
	if timer.time_left == 0:
		timer.start()
		if camera.offset == Vector2.ZERO:
			target = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		if camera.offset == target:
			target = Vector2.ZERO
			should_shake = false
		var tween = create_tween()
		tween.tween_property(camera, "offset", target, timer_wait_time)
		tween.play()
		#camera.offset = lerp(camera.offset, target, 1)
