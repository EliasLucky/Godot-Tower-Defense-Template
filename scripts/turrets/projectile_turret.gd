class_name ProjectileTurret
extends Turret

@export var projectile : PackedScene

@export var bullet_speed : float = 200.0
@export var bullet_pierce : int = 1

func attack_inherited():
	if is_instance_valid(current_target):
		var p = projectile.instantiate()
		#p.bullet_type = self.bullet_type
		p.damage = damage
		p.speed = bullet_speed
		p.pierce = bullet_pierce

		p.position = position
		p.target = current_target.position
		get_parent().get_parent().get_node("projectiles").add_child(p)
	else:
		try_get_closest_target()
