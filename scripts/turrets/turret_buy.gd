extends TextureButton

@onready var price_label : Label = $Label

@export var turret : PackedScene

@export var turret_name : String = ""
@export var price : int = 70:
	set(value):
		price = value
		if price_label:
			price_label.text = str(price)

func _ready():
	price_label.text = str(price)

	button_up.connect(_button_up)

func _process(_delta):
	if Gameplay.current_money < price:
		disabled = true
	else:
		disabled = false

func _button_up():
	Gameplay.current_money -= price

	var d = turret.instantiate()
	d.position = get_parent().click_position
	d.turret_price = price
	get_parent().turrets.add_child(d)
	
	Gameplay.close_buy_turret()
