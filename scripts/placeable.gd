extends Area2D

func _ready() -> void:
	Gameplay.init_buy_turret(get_parent().get_node("turrets"))

	input_event.connect(_on_input_event)

# stupid fix. if player opened turret details then do not open buy new turret menu
func _process(_delta) -> void:
	if Gameplay.opened_turret_details:
		Gameplay.close_buy_turret()

func _on_input_event(_viewport, _event, _share_idx):
	if Input.is_action_pressed("LMB"):
		if Gameplay.opened_turret_details:
			Gameplay.close_turret_details()
		else:
			Gameplay.open_buy_turret(get_global_mouse_position())
		print("Clicked on the polygon shape")
