extends Control

@onready var menu_btn : TextureButton = $Control/menu
@onready var retry_btn : TextureButton = $Control/retry

@onready var stats : VBoxContainer = $stats

var base_text_of_labels : Dictionary = {}

func _ready():
	for label in stats.get_children():
		base_text_of_labels[label.name] = label.text

	menu_btn.button_up.connect(_menu_btn)
	retry_btn.button_up.connect(_retry_btn)

func _process(_delta):
	get_parent().get_node("shadow").visible = visible

func set_stats(dictionary : Dictionary) -> void:
	for key in dictionary.keys():
		stats.get_node(key).text = base_text_of_labels[key] + " " + str(dictionary[key])

func _menu_btn():
	pass

func _retry_btn():
	Gameplay.game_retry()
