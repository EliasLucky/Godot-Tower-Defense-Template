class_name Turret
extends Node2D

@onready var collision_area = $collision_area
@onready var detection_area = $detection_area
@onready var cooldown_timer = $timer_cooldown

@export var turret_id : String = ""
@export var turret_name : String = ""

@export var upgrade_data : TurretUpgrade

@export var damage_effects_data : Array[DamageEffect] = []

# rate
@export var attack_speed : float = 1.0
@export var attack_range : float = 1.0
@export var damage : float = 1.0

@export var turret_level : int = 1
var turret_price : int = -1

var deployed : bool = false
@export var rotates : bool = true
var current_target = null

#signal turret_updated

func _ready():
	deployed = true
	cooldown_timer.wait_time = 1.0/attack_speed
	detection_area.get_node("CollisionShape2D").shape.radius = attack_range*10

	detection_area.area_entered.connect(_on_detection_area_entered)
	detection_area.area_exited.connect(_on_detection_area_exited)
	collision_area.input_event.connect(_on_collision_area_input_event)

	cooldown_timer.timeout.connect(attack)
	cooldown_timer.start()
	
	if upgrade_data.turret_level_texture.size() < upgrade_data.max_level:
		print("Turret have no special textures per level. 'upgrade_data.turret_level_texture.size()' < max turret level. It will be skipped.")

	if upgrade_data.turret_head_level_texture.size() < upgrade_data.max_level:
		if has_node("turret_head"):
			print("Turret have 'turret_head' node but 'upgrade_data.turret_head_level_texture' does not have enoguh textures of the turret head for new levels. It will be skipped.")

func _process(_delta):
	if rotates:
		var turret_head = $turret_head
		if is_instance_valid(current_target):
			turret_head.look_at(current_target.position)
		else:
			try_get_closest_target()

func _on_detection_area_entered(area : Area2D):
	if deployed and not current_target:
		var area_parent = area.get_parent()
		if area_parent is Enemy:
			current_target = area.get_parent()
			#try_get_nearby_turrets()

func _on_detection_area_exited(area : Area2D):
	if deployed and current_target == area.get_parent():
		current_target = null
		try_get_closest_target()

func _on_collision_area_input_event(_viewport, _event, _share_idx):
	if deployed and Input.is_action_just_pressed("LMB"):
		if Gameplay.turret_details.has(name):
			Gameplay.switch_turret_details(self.name)
		else:
			Gameplay.open_turret_details(self)

func try_get_closest_target():
	if not deployed:
		return

	var closest = 1000
	var closest_area
	for area in detection_area.get_overlapping_areas():
		var dist = area.position.distance_to(position)
		if dist < closest:
			closest = dist
			closest_area = area
	if closest_area:
		current_target = closest_area.get_parent()

func upgrade_turret() -> void:
	turret_level += 1	
	
	if upgrade_data.turret_level_texture.size() >= upgrade_data.max_level:
		$Sprite2D.texture = upgrade_data.turret_level_texture[turret_level]

	if upgrade_data.turret_head_level_texture.size() >= upgrade_data.max_level:
		$turret_head.texture = upgrade_data.turret_head_level_texture[turret_level]
	
	attack_speed = _upgrade_turret_stat(upgrade_data.attack_speed_multiplier, attack_speed, upgrade_data.attack_speed)
	attack_range = _upgrade_turret_stat(upgrade_data.attack_range_multiplier, attack_range, upgrade_data.attack_range)
	damage = _upgrade_turret_stat(upgrade_data.damage_multiplier, damage, upgrade_data.damage)

func _upgrade_turret_stat(is_multiplier : bool, stat : float, val : float) -> float:
	if is_multiplier:
		stat *= val
	else:
		stat += val
	return stat

func attack():
	if is_instance_valid(current_target):
		attack_inherited()
	else:
		try_get_closest_target()

# override
func attack_inherited():
	pass

