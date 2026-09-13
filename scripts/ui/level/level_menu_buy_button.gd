@tool
extends NinePatchRect

@onready var label = $Label
#@onready var icon = $Icon

@onready var button : TextureButton = $TextureButton
@onready var checked : Control = $Checked

@export var free_texture : Texture2D
@export var manager_texture : Texture2D
@export var ceo_texture : Texture2D

@export var gem_base : Control
@export var gem_manager : Control
@export var gem_ceo : Control
@export var money_base : Control
@export var money_manager : Control
@export var money_ceo : Control

@export_enum("Free","Manager","CEO") var type : String = "Free":
	set(value):
		type = value
		if value == "Free":
			self.texture = free_texture
		if value == "Manager":
			self.texture = manager_texture
		if value == "CEO":
			self.texture = ceo_texture

@export var enabled : bool = true:
	set(value):
		enabled = value
		if not button: return
		_enabled(value)

func _enabled(value):
	if not value:
		button.hide();
	else:
		button.show();

@export var amount : int = 0:
	set(value):
		amount = value
		if label:
			label.text = str(value)

@export var gems : bool = false:
	set(value):
		gems = value
		#if not icon: return
		_gems(value)

func _gems(value):
	if value:
		#icon.get_node("gems").show();
		#icon.get_node("money").hide();
		
		money_base.hide()
		money_manager.hide()
		money_ceo.hide()
		gem_base.hide()
		gem_manager.hide()
		gem_ceo.hide()
		if type == "Free":
			gem_base.show()
		elif type == "Manager":
			gem_manager.show()
		elif type == "CEO":
			gem_ceo.show()
	else:
		#icon.get_node("gems").hide();
		#icon.get_node("money").show();
		
		money_base.hide()
		money_manager.hide()
		money_ceo.hide()
		gem_base.hide()
		gem_manager.hide()
		gem_ceo.hide()
		if type == "Free":
			money_base.show()
		elif type == "Manager":
			money_manager.show()
		elif type == "CEO":
			money_ceo.show()

func _ready():
	label.text = str(amount)
	_enabled(enabled)
	_gems(gems)
	button.button_up.connect(_button_up)

func _button_up():
	button.hide();
	if gems:
		Gameplay.player_gems += amount
	else:
		Gameplay.player_money += amount
	checked.show();
