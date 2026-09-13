extends CanvasLayer

@export var star_texture: Texture          # The texture to use for flying stars
@export var target_node_path: NodePath    # Path to the target TextureRect (e.g., "VBoxContainer2/Texture")
@export var fly_duration: float = 0.6     # Duration of each flight
@export var stagger_delay: float = 0.15   # Delay between stars
@export var arc_height: float = 80.0      # How high the arc goes (in pixels)
@export var start_scale: float = 0.5
@export var end_scale: float = 0.8        # Scale at the target (can be 1.0 if you want)

var target: TextureRect
var screen_size: Vector2

func _ready() -> void:
	target = get_node(target_node_path) as TextureRect
	if not target:
		print("StarFlyEffect: target node not found!")
		return
# Ensure the target is on the same CanvasLayer; we'll use its global position.

func show_stars(count: int = 3) -> void:
	if not target:
		return

	screen_size = get_viewport().get_visible_rect().size
	var center = screen_size * 0.5   # screen center in pixels

	# The target's global position on this CanvasLayer.
	var target_pos = target.global_position
	# Offset the target by -32 on X (as you mentioned)
	#target_pos += Vector2(-32, 0)

	for i in range(count):
		# Create a new TextureRect for this star
		var star = TextureRect.new()
		star.texture = star_texture
		var tex_size = star_texture.get_size()
		star.size = tex_size
		star.pivot_offset = tex_size * 0.5
		star.scale = Vector2(start_scale, start_scale)
		star.modulate = Color(1,1,1,1)

		# Add to the CanvasLayer (so it's on top of UI)
		add_child(star)

		# Set its initial position at screen center (with some random offset if desired)
		var start_pos = center + Vector2(randf_range(-20, 20), randf_range(-10, 10))
		star.position = start_pos

		# Calculate control point for arc (quadratic bezier)
		var mid = (start_pos + target_pos) * 0.5
		mid.y -= arc_height   # arc goes up (negative y in screen coords)

		# Create a tween for this star
		var tween = create_tween()
		#tween.set_delay(i * stagger_delay)   # stagger

		# Animate position along a quadratic curve using tween_method
		tween.tween_method(
			_update_star_position.bind(star, start_pos, mid, target_pos),
			0.0, 1.0, fly_duration
		).set_delay(i * stagger_delay)

		# Animate scale: pop up then shrink
		tween.tween_property(star, "scale", Vector2(1.2, 1.2), fly_duration * 0.3).set_ease(Tween.EASE_OUT).set_delay(i * stagger_delay)
		tween.tween_property(star, "scale", Vector2(end_scale, end_scale), fly_duration * 0.7).set_ease(Tween.EASE_IN).set_delay(i * stagger_delay)

		# Optional: fade out or keep it at the target
		# tween.tween_property(star, "modulate", Color(1,1,1,0), 0.2).set_delay(fly_duration - 0.2)

		# After the animation, we could free the star or keep it.
		# Here we free it after the flight is complete.
		tween.tween_callback(star.queue_free).set_delay(fly_duration).set_delay(i * stagger_delay)

# This function is called by the tween to update the star's position
func _update_star_position(progress: float, star: TextureRect, start: Vector2, control: Vector2, end: Vector2) -> void:
# Quadratic bezier: B(t) = (1-t)^2 * start + 2*(1-t)*t * control + t^2 * end
	var t = progress
	var pos = (1 - t) * (1 - t) * start + 2 * (1 - t) * t * control + t * t * end
	star.position = pos
