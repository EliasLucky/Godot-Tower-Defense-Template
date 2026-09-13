class_name Bullet
extends Node2D

@onready var detection_area : Area2D = $Area2D
@onready var disappear_timer : Timer = $disappear_timer

var damage_effects : Array[DamageEffect] = []

# override
var speed : float = -1.0
var damage : float = -1.0
var pierce : int = -1
var time : float = -1.0

var target
var direction : Vector2

func _ready():
	detection_area.area_entered.connect(_on_area_2d_area_entered)
	disappear_timer.timeout.connect(_on_disappear_timer_timeout)

func _process(delta):
	if target:
		if not direction:
			direction = (target-position).normalized()
		position += direction * speed * delta

func _on_area_2d_area_entered(area):
	var obj = area.get_parent()
	if obj is Enemy:
		pierce -= 1
		obj.damage(damage)
		#if effect:
		#	obj.give_effect(effect)
		for effect in damage_effects:
			obj.give_effect(effect)
	if pierce == 0:
		queue_free()

# if bullet did not reach an enemy and actually flew out of the map then delete it.
func _on_disappear_timer_timeout():
	queue_free()
