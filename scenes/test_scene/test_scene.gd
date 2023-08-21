extends Node2D


@onready var test_camera:Camera2D = $GridContainer/TestViewportContainer/SubViewport/TestCamera2D
@onready var test_screen = $GridContainer/TestViewportContainer/SubViewport/TestScreen


func _ready():
	test_screen.initialize(test_camera)
