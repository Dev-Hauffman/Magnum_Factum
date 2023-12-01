extends Node2D


signal finished_displaying


var boards:Array = []
var wait_time:float = 2


@onready var semester_info_position = $SemesterInfoPosition
@onready var board_sliding_player = $BoardSlidingPlayer
@onready var music_sound_controller = $MusicSoundController
@onready var white_screen_player = $WhiteScreenPlayer


func start(current_semester:int):
	white_screen_player.play("fade_out")
	create_boards(current_semester)
	await white_screen_player.animation_finished
	await get_tree().create_timer(1).timeout #time to show the objective diploma
	present_boards()


func create_boards(current_semester:int):
	var disciplines:Array
	var semester_count = current_semester
	disciplines = Disciplines.get_discipline_by_semester(semester_count)
	while not disciplines.is_empty():
		if not disciplines.is_empty():
			var semester_info_container = ResourceLoader.load("res://scenes/show_semester/semester_info_container.tscn").instantiate()
			add_child(semester_info_container)
			semester_info_container.initialize(semester_count, disciplines)
			boards.append(semester_info_container)
			if semester_count == current_semester:
				semester_info_container.connect("finished_animation", Callable(self, "finished_presentation"))
			disciplines.clear()
		semester_count += 1
		disciplines = Disciplines.get_discipline_by_semester(semester_count)


func present_boards():
	var target:float = semester_info_position.position.y
	boards.reverse()
	for board in boards:
		board_sliding_player.play()
		await get_tree().create_timer(0.2).timeout
		board.move_to(target)
		move_child(board, boards.find(board))
		#target += 10
		await get_tree().create_timer(1).timeout

func finished_presentation():
	music_sound_controller.play("music_volume_drop")
	await get_tree().create_timer(wait_time).timeout
	emit_signal("finished_displaying")
