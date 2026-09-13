extends Control

@export var free_gems : Control

@export var upgrade_capacity : Control
@export var upgrade_speed : Control
@export var upgrade_profits : Control

@onready var exit_button : TextureButton = $NinePatchRect/TextureButton

var once = false

func _ready():
	exit_button.button_up.connect(_exit_button)

func _process(_delta):
	if get_parent().joystick and visible:
		get_parent().joystick.disabled = visible

func _exit_button():
	hide();
	if not once:
		once = true
		free_gems.show();
	get_parent().joystick.disabled = visible
