extends CanvasLayer

@onready var money_label : Label = $MarginContainer5/VBoxContainer/money/Label
@onready var gems_label : Label = $MarginContainer5/VBoxContainer/gems/Label

@onready var wave_delay_timer_progress : TextureProgressBar = $MarginContainer5/Control/TextureProgressBar
@onready var waves_label : Label = $MarginContainer5/Control/Label

@onready var game_over_screen : Control = $game_over
@onready var game_won_screen : Control = $game_won

@onready var place_turret_screen : Control = $place_turret
@onready var turret_details_screen : Control = $turret_details/turret_details
@onready var turret_details_node : Control = $turret_details
var turret_details : Array[String] = [];

var opened_turret_details : bool = false

var current_money : int = 30
var current_gems : int = 0;


var game_loaded : bool = false

var game_paused : bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	money_label.text = str(current_money)
	gems_label.text = str(current_gems)

func print_wave_data(max_waves : int, current_wave : int) -> void:
	waves_label.text = "Waves " + str(current_wave) + "/" + str(max_waves)

func game_over():
	get_tree().paused = true

	var level = get_tree().current_scene

	var stats = {}
	stats["wave_reached"] = level.current_wave
	stats["max_waves"] = level.max_waves
	stats["total_killed"] = level.total_killed_enemies
	game_over_screen.set_stats(stats)
	game_over_screen.show()

func game_retry():
	clean()
	
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("An error has occured.")
	get_tree().paused = false

func game_won():
	get_tree().paused = true
	game_won_screen.show()

func init_buy_turret(turrets : Node2D) -> void:
	place_turret_screen.turrets = turrets

func open_buy_turret(global_pos : Vector2) -> void:
	place_turret_screen.click_position = global_pos
	var s = place_turret_screen.size
	place_turret_screen.position = global_pos + Vector2(s.x-100,s.y/2-80)
	place_turret_screen.show()

func close_buy_turret() -> void:
	place_turret_screen.hide()

func open_turret_details(turret : Turret) -> void:
	turret_details.append(turret.name)
	var d = turret_details_screen.duplicate()
	d.turret = turret
	d.name = turret.name
	turret_details_node.add_child(d)

	# kind of obsolete
	switch_turret_details(turret.name)

func close_turret_details() -> void:
	for detail in turret_details_node.get_children():
		detail.hide()
	opened_turret_details = false

func switch_turret_details(turret_name : String) -> void:
	for detail in turret_details_node.get_children():
		detail.hide()
		if detail.name == turret_name:
			detail.visible = not detail.visible
			opened_turret_details = detail.visible


func delete_turret_details(turret_name : String) -> void:
	turret_details_node.get_node(turret_name).queue_free()
	var index = turret_details.find(turret_name)
	turret_details.remove_at(index)

func clean() -> void:
	current_money = 30
	current_gems = 0

	close_turret_details()
	turret_details.clear()

	game_over_screen.hide()
	game_won_screen.hide()

	place_turret_screen.hide()
