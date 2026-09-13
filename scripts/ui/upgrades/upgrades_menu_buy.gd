@tool
extends NinePatchRect

@export var label : Control # = $buy/Label
@export var buy_label : Label
@export var icon_speed : Control # = $icon_speed
@export var icon_packages : Control # = $icon_packages
@export var icon_money : Control # = $icon_money

@export var upgrade_bars : Control# = $Control/HBoxContainer
@export var filled_bar : Control# = $Control/HBoxContainer/completed

@export var buy_btn : TextureButton# = $buy
@export var ad_btn : TextureButton# = $ad
@export var checked : Control# = $Checked

var upgrade_level : int = 0;

var current_price : int = 250

@export var free = false:
	set(value):
		free = value
		if not buy_label: return
		if free:
			buy_label.text = "FREE"
		else:
			buy_label.text = str(current_price) + "$"

@export_enum("Speed","Packages","Money") var type : String = "Speed":
	set(value):
		type = value
		if value == "Speed":
			label.text = "MOVE SPEED"
			icon_speed.show()
			icon_packages.hide();
			icon_money.hide()
		if value == "Packages":
			label.text = "CAPACITY"
			icon_speed.hide()
			icon_packages.show();
			icon_money.hide()
		if value == "Money":
			label.text = "PROFITS UP"
			icon_speed.hide()
			icon_packages.hide();
			icon_money.show()

@export var enabled : bool = true:
	set(value):
		enabled = value
		if not buy_btn: return
		if not value:
			buy_btn.disabled = true
		else:
			buy_btn.disabled = false

@export var amount : int = 250:
	set(value):
		amount = value
		current_price = value
		if buy_label:
			buy_label.text = str(value) + "$"

func _ready():
	buy_btn.button_up.connect(_buy_btn)

func _buy_btn(loading_data=false):
	if free and type == "Speed":
		free = false
		buy_label.text = str(current_price) + "$"
		
		upgrade_level += 1
		upgrade_bars.get_node(str(upgrade_level)).texture = filled_bar.texture
		Gameplay.player_upgrade.emit(type,upgrade_level)
		return
	if upgrade_level == 5: return
	if Gameplay.player_money < current_price: return
	
	if not loading_data:
		Gameplay.player_money -= current_price
	current_price += 200
	buy_label.text = str(current_price) + "$"
	
	upgrade_level += 1
	upgrade_bars.get_node(str(upgrade_level)).texture = filled_bar.texture
	Gameplay.player_upgrade.emit(type,upgrade_level)
