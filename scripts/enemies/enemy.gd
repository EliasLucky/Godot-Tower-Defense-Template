class_name Enemy
extends PathFollow2D

enum State {
	WALKING,
	DAMAGED
}

var state : State = State.WALKING

@onready var sprite = $Sprite2D
@onready var health_bars = $health/bars

@export var health : float = 10.0
@export var speed : float = 1.0

@export var reward_after_kill : int = 5

## Start spawning after specific wave
@export var spawn_on_after_wave : int = 0
## Stop spawning after specific wave. -1 means enemy will spawn only depending on `spawn_on_after_wave`
@export var spawn_on_before_wave : int = -1

var finish_base

var effects : Array[DamageEffect] = []

signal enemy_destroyed

func _ready():
	_init_health_bars()

func _init_health_bars():
	if health <= 1.0:
		health_bars.hide()
		return

	var bars_amount = int(round(health))
	for i in range(bars_amount):
		var bar = health_bars.get_node("bar")
		var d = bar.duplicate()
		d.name = str(i+1)
		d.show()
		health_bars.add_child(d)
	var black_bar = health_bars.get_parent().get_node("background")
	var black_bar_size_x = (bars_amount*10) + ((bars_amount-1)*4) + 6
	#print(black_bar_size_x)
	black_bar.size = Vector2(black_bar_size_x,20)
	black_bar.position = Vector2(-(black_bar_size_x/2.0),-10.0)
	health_bars.position = Vector2(-(black_bar_size_x/2.0)+3.0,-7.5)

func _process(delta : float) -> void:
	var processed_effects = process_effects(delta)
	var cur_speed = processed_effects.speed
	var cur_damage = processed_effects.damage

	health -= cur_damage

	if state == State.WALKING:
		progress_ratio += 0.0005 * cur_speed
		if progress_ratio == 1:
			finish_path()
			return

		var angle = int(rotation_degrees) % 360
		if angle > 180:
			angle -= 360

		sprite.flip_v = abs(angle) > 90

func finish_path():
	#if is_destroyed:
	#	return
	#is_destroyed = true
	
	#damage_animation()
	finish_base.damage()
	
	queue_free()

func damage(value : float) -> void:
	health -= value
	_damage_animation()

	health_bars.get_node(str(int(round(health+1)))).hide()

	if health <= 0:
		Gameplay.current_money += reward_after_kill
		enemy_destroyed.emit()

		queue_free()

# TODO: yeah fix. based on what it does has?
func give_effect(effect : DamageEffect) -> void:
	if effects.has(effect):
		var index = effects.find(effect)
		effects[index].current_time = 0.0
	else:
		effects.append(effect)

func process_effects(delta : float) -> Dictionary:
	var calculated_speed = speed
	var calculated_damage = 0.0
	for i in range(effects.size()-1,-1,-1):
		if _process_effect(effects[i], delta):
			effects.remove_at(i)
			continue
		calculated_speed += effects[i].speed_effect
		if effects[i].damage_effect_time >= effects[i].damage_effect_time_limit:
			effects[i].damage_effect_time = 0.0
			calculated_damage += effects[i].damage_effect
	
	return {"speed": calculated_speed, "damage": calculated_damage}

func _process_effect(effect : DamageEffect, delta : float) -> bool:
	effect.current_time += delta
	effect.damage_effect_time += delta
	if effect.current_time >= effect.time_limit:
		return true
	return false


func _damage_animation():
	var tween := create_tween()
	tween.tween_property(self, "v_offset", 0, 0.05)
	tween.tween_property(self, "modulate", Color.ORANGE_RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_parallel()
	tween.tween_property(self, "v_offset", -5, 0.2)
	tween.set_parallel(false)
	tween.tween_property(self, "v_offset", 0, 0.2)
