extends Node2D


@onready var test_camera:Camera2D = $GridContainer/TestViewportContainer/SubViewport/TestCamera2D
@onready var test_screen = $GridContainer/TestViewportContainer/SubViewport/TestScreen


func start_test(speed_value:int, precision_value:int):
	test_screen.initialize(test_camera, speed_value, precision_value)
	
	
