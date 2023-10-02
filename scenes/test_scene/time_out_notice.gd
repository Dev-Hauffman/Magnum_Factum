extends Node2D


var speed:float = 0.5


@onready var time_up_animation = $TimeUpAnimation


func notify_time_up():
	time_up_animation.play("Slide in")
