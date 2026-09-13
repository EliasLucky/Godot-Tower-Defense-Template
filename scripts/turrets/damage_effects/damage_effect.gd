class_name DamageEffect
extends Resource

@export var time_limit : float = 10.0
var current_time : float = 0.0

@export var speed_effect : float = -2.0
@export var damage_effect : float = 5.0

@export var damage_effect_time_limit : float = 5.0
var damage_effect_time : float = 0.0

@export var particle : PackedScene
