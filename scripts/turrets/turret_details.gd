extends Control

@onready var label_turret_name = $turret_name
@onready var label_turret_level = $turret_lvl

@onready var upgrade_btn = $upgrade
@onready var sell_btn = $sell

var turret : Turret

func _ready():
	upgrade_btn.button_up.connect(_upgrade_btn)
	sell_btn.button_up.connect(_sell_btn)

func _process(_delta):
	if turret:
		_can_upgrade()
		_upgrade_labels()

		position = turret.global_position

func _upgrade_labels():
	label_turret_name.text = turret.turret_name
	label_turret_level.text = "TURRET LVL: " + str(turret.turret_level)

	upgrade_btn.get_node("Label").text = "Upgrade for " + str(get_upgrade_price())
	sell_btn.get_node("Label").text = "Sell for " + str(get_sell_price())

func _upgrade_btn():
	if _can_upgrade():
		Gameplay.current_money -= get_upgrade_price()
		turret.upgrade_turret()
	
func _can_upgrade():
	if turret.turret_level == turret.upgrade_data.max_level:
		upgrade_btn.get_node("Label").text = "MAX"
		upgrade_btn.disabled = true
	else:
		upgrade_btn.disabled = Gameplay.current_money < get_upgrade_price()
	return not upgrade_btn.disabled

func get_upgrade_price():
	return turret.upgrade_data.upgrade_cost

func _sell_btn():
	Gameplay.current_money += get_sell_price()
	turret.queue_free()
	queue_free()

func get_sell_price():
	var base = turret.turret_price
	base = base * 0.7 # 70% of the base price
	for i in range(turret.turret_level-1):
		base += turret.upgrade_data.upgrade_cost
	
	return round(base)
