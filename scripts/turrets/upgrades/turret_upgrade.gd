class_name TurretUpgrade
extends Resource

## Turret texture based on its level: turret_level_texture[turret_level]
@export var turret_level_texture : Array[Texture2D] = []
@export var turret_head_level_texture : Array[Texture2D] = []

@export var attack_speed : float = 1.5
@export var attack_speed_multiplies = true

@export var attack_range : float = 1.5
@export var attack_range_multiplies = true

@export var damage : float = 1.0
@export var damage_multiplies = false

@export var max_level : int = 3

@export var upgrade_cost : int = 50
