class_name RayTurret
extends Turret

@onready var hit_area : Area2D = $hit_area
@onready var timer_ray_duration : Timer = $timer_ray_duration

@export var laser_material : Material

@export var ray_length : float = 200.0
@export var ray_duration : int = 1
var ray_enabled : bool = false
var ray_extension : float = 0.0

func _ready():
	super._ready()

	hit_area.get_node("Line2D").material = laser_material	

	cooldown_timer.one_shot = false
	cooldown_timer.start()
	timer_ray_duration.timeout.connect(_timer_ray_duration_timeout)

func _process(delta):
	super._process(delta)

	# check if enemies are in ray
	for enemy in hit_area.get_overlapping_areas():
		var collider = enemy.get_parent()
		if collider is Enemy:
			collider.damage(damage)

	# ray is animated
	if ray_enabled and ray_extension < 1.0:
		ray_extension += 0.1
		activate_ray(ray_extension)
	if not ray_enabled and ray_extension >= 0.0:
		ray_extension -= 0.01
		deactivate_ray(ray_extension)

func attack_inherited():
	if is_instance_valid(current_target):
		if not ray_enabled:
			ray_enabled = true

			timer_ray_duration.start()
	else:
		try_get_closest_target()

func activate_ray(ratio):
	if is_instance_valid(current_target):
		var angle := get_angle_to(current_target.position)
		var offset = to_local(current_target.position) # Vector2(cos(angle), sin(angle)) * self.attack_range*10 * ratio
		hit_area.get_node("Line2D").set_point_position(1,offset)
		hit_area.get_node("CollisionShape2D").shape.b = offset
	else:
		ray_enabled = false
		timer_ray_duration.stop()

func deactivate_ray(ratio):
	var offset = hit_area.get_node("Line2D").get_point_position(1) * ratio
	hit_area.get_node("Line2D").set_point_position(1,offset)
	hit_area.get_node("CollisionShape2D").shape.b = offset

func _timer_ray_duration_timeout():
	ray_enabled = false
	cooldown_timer.start()
