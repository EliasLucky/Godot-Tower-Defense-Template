extends Node2D

@onready var health_bars = $health/bars

@export var health : int = 7
var current_health : int = 7

func _ready():
	current_health = health


func damage():
	current_health -= 1
	if current_health == 0:
		Gameplay.game_over()

		return
	health_bars.get_node(str(current_health+1)).hide()

func reset():
	current_health = health
	for i in range(1,health+1):
		health_bars.get_node(str(i)).show()
