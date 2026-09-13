extends Node2D

@onready var path : Path2D = $PathSpawner
@onready var timer_spawn_delay : Timer = $PathSpawner/timer_spawn_delay
@onready var timer_wave_delay : Timer = $PathSpawner/timer_wave_delay

@onready var finish_base : Node2D = $finish_base

#@export var enemy : PackedScene

@export var enemies : Array[PackedScene] = []
@export var max_waves : int = 3
@export var wave_enemies_spawn_count : int = 10

var current_wave : int = -1
var current_wave_enemies_spawn_count : int = 0

var spawned_enemies : int = 0
var killed_enemies : int  = 0
var total_killed_enemies : int = 0

func _ready() -> void:
	current_wave_enemies_spawn_count = wave_enemies_spawn_count

	timer_spawn_delay.timeout.connect(_timer_spawn_delay_timeout)
	timer_wave_delay.timeout.connect(_timer_wave_delay_timeout)

	get_viewport().physics_object_picking_first_only = false
	get_viewport().physics_object_picking_sort = true

func _process(_delta):
	Gameplay.wave_delay_timer_progress.value = timer_wave_delay.wait_time - timer_wave_delay.time_left
	Gameplay.wave_delay_timer_progress.max_value = timer_wave_delay.wait_time
	Gameplay.print_wave_data(max_waves, current_wave+1)

var _save_net : int = 0
func spawn_enemy():
	
	var rand_enemy = enemies.pick_random().instantiate()
	while not _can_spawn_enemy(rand_enemy):
		rand_enemy.queue_free()
		rand_enemy = enemies.pick_random().instantiate()
		
		_save_net += 1
		if _save_net >= 5:
			print("WHILE LOOP EXHAUSTED. enemies array does not have any enemy that follows the condition: `current_wave >= enemy.spawn_on_after_wave and current_wave <= enemy.spawn_on_before_wave`. current_wave is ", str(current_wave))
			break

	rand_enemy.finish_base = finish_base
	rand_enemy.enemy_destroyed.connect(enemy_destroyed)
	path.add_child(rand_enemy)
	spawned_enemies += 1

func _can_spawn_enemy(enemy : Enemy) -> bool:
	var before : bool = false
	if enemy.spawn_on_before_wave == -1:
		before = true
	else:
		before = current_wave <= enemy.spawn_on_before_wave
	
	return current_wave >= enemy.spawn_on_after_wave and before

func _sort_by_attribute(arr : Array, attr : String):
	arr.sort_custom(func(a,b):
		if not a.get(attr):
			return true
		if a.get(attr) < b.get(attr):
			return true
		return false
	)

func enemy_destroyed() -> void:
	killed_enemies += 1
	total_killed_enemies += 1
	if killed_enemies == spawned_enemies:
		if not current_wave == max_waves:
			timer_wave_delay.start()
			return

		Gameplay.level_completed.show()

func _check_wave_cleared():
	pass

func _timer_spawn_delay_timeout():
	if spawned_enemies < current_wave_enemies_spawn_count:
		spawn_enemy()
		timer_spawn_delay.start()

func _timer_wave_delay_timeout():
	current_wave += 1
	spawned_enemies = 0
	killed_enemies = 0
	print("Starting wave")
	timer_spawn_delay.start()
