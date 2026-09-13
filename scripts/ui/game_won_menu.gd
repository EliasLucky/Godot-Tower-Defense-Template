extends Control

@onready var retry_btn : TextureButton = $Control/retry
@onready var continue_btn : TextureButton = $Control/continue

@onready var reward_label : Label = $VBoxContainer/reward/HBoxContainer/Label

func _ready():
	retry_btn.button_up.connect(_retry_btn)
	continue_btn.button_up.connect(_continue_btn)

func _process(_delta):
	get_parent().get_node("shadow").visible = visible

func _retry_btn():
	Gameplay.game_retry()

func _continue_btn():
	pass
