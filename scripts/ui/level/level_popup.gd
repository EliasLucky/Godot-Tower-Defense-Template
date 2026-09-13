extends Control

@export var level : Label
@export var reward : Label

@export var reward_money : Control
@export var reward_gem : Control

@export var rewards : Array[int] = [];
@export var reward_types : Array[bool] = [];
@export var special_rewards : Array[Node3D] = [];

@export var reward_money_color : Color
@export var reward_gem_color : Color

@onready var buttons : Control = $VBoxContainer/HBoxContainer
@onready var switch : Control = $VBoxContainer/switch
@onready var free_btn : TextureButton = $VBoxContainer/HBoxContainer/free/ad2
@onready var buy_btn : TextureButton = $VBoxContainer/HBoxContainer/buy/ad

@onready var continue_btn : TextureButton = $VBoxContainer/Control/TextureButton

func _ready():
	continue_btn.button_up.connect(_continue_btn)
	free_btn.button_up.connect(_free_btn)
	buy_btn.button_up.connect(_buy_btn)
	buttons.hide()
	switch.show()
	hide();

func _process(_delta):
	if not Gameplay.game_loaded: return
	level.text = str(Gameplay.current_level+1)
	reward.text = str(rewards[Gameplay.current_level])

	if reward_types[Gameplay.current_level]:
		reward_money.hide();
		reward_gem.show();
		reward.label_settings.font_color = reward_gem_color
	else:
		reward_money.show();
		reward_gem.hide();
		reward.label_settings.font_color = reward_money_color

	if get_parent().joystick and visible:
		get_parent().joystick.disabled = visible

var reward_ = 0
func new_level():
	reward_ = rewards[Gameplay.current_level]
	
	if special_rewards[Gameplay.current_level]:
		special_rewards[Gameplay.current_level].position.y = 0;

	if Gameplay.current_level+1 >= 3:
		buttons.show()
		switch.hide()

func _free_btn():
	reward_ = reward_ * 2
	
	buttons.hide()
	switch.show()

func _buy_btn():
	if Gameplay.player_gems >= 3:
		Gameplay.player_gems -= 3
		
		reward_ = reward_ * 2
		
		buttons.hide()
		switch.show()

func _continue_btn():
	hide()
	get_parent().joystick.disabled = visible
	
	if not Gameplay.notice_level_menu_once:
		Gameplay.notice_level_menu_once = true
		Gameplay.notice_level_menu.show()

	if reward_types[Gameplay.current_level]:
		Gameplay.player_gems = reward_
	else:
		Gameplay.player_money = reward_
