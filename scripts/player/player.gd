class_name Player
extends CharacterBody3D

@export_group("Speed Settings")
var speed_upgrades : Array[float] = [1.7,1.9,2.1,2.5,3.0]
@export var max_speed: float = 1.5 # 3.0
@export var rotation_speed: float = 6.0

@export_group("References")
@export var joystick: Control # Drag your VirtualJoystick node here in the Inspector
@onready var model_node: Node3D = $Model # Change to your imported Node3D model's exact name
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer # Path to imported AnimationPlayer

# Adjust animation names according to your imported model
const ANIM_IDLE = "Armature_001|Armature_001|Armature_001|Armature_001|mixamo_com|Layer0|Armatu"
const ANIM_WALK = "Armature_001|Armature_001|Armature_001|Armature_002|mixamo_com|Layer0|Armatu"
const ANIM_RUN = "run"

@onready var plates = $plates
@onready var packages_models = $packages

var upgrade_speed_lvl : int = 0
var upgrade_packages_lvl : int = 0
var upgrade_profits_lvl : int = 0

var has_burger : bool = false
var has_package : bool = false
var burgers : int = 0;
var packages : int = 0;
var max_burgers : int = 1

func _ready():
	var models = plates.get_children()
	for i in range(models.size()):
		models[i].position.y -= 10
	
	var models_ = packages_models.get_children()
	for i in range(models_.size()):
		models_[i].position.y -= 10

	Gameplay.player_upgrade.connect(_upgrade)

func _upgrade(upgrade : String, level : int):
	if upgrade == "Speed":
		upgrade_speed_lvl = level
		max_speed = speed_upgrades[level]
	if upgrade == "Packages":
		upgrade_packages_lvl = level
		if level == 0:
			max_burgers = 1
		else:
			max_burgers = (1*level)
	#if upgrade == "Money":

func _physics_process(delta: float) -> void:
	var input_vec = Vector2.ZERO
	
	# Get vector from joystick if available, fallback to WASD for PC testing
	if joystick and joystick.output_vector != Vector2.ZERO:
		input_vec = joystick.output_vector
	else:
		#input_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		input_vec = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))

	# Convert 2D input into 3D world direction on the XZ plane
	var move_dir = Vector3(-input_vec.x, 0.0, -input_vec.y)
	var input_magnitude = clamp(input_vec.length(), 0.0, 1.0)

	if input_magnitude > 0.05:
		var camera = get_node("Camera3D")
		var cam_forward = -camera.global_transform.basis.z
		var cam_right = -camera.global_transform.basis.x
		cam_forward.y = 0
		cam_right.y = 0
		cam_forward = cam_forward.normalized()
		cam_right = cam_right.normalized()

		move_dir = (cam_right * move_dir.x) + (cam_forward * move_dir.z)

		# Calculate dynamic target speed based on joystick push distance
		var target_speed = max_speed * input_magnitude
		velocity.x = move_dir.x * target_speed
		velocity.z = move_dir.z * target_speed
		
		# Rotate character mesh smoothly towards movement direction
		var target_angle = atan2(move_dir.x, move_dir.z)
		model_node.rotation.y = lerp_angle(model_node.rotation.y, target_angle, rotation_speed * delta)
		
		# Switch animations based on speed/push intensity
		if input_magnitude < 0.5:
			play_animation(ANIM_WALK, input_magnitude * 2.0) # Scale playback speed
		else:
			play_animation(ANIM_WALK, input_magnitude)
	else:
		# Apply friction to stop moving smoothly
		velocity.x = move_toward(velocity.x, 0.0, max_speed * 10.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, max_speed * 10.0 * delta)
		play_animation(ANIM_IDLE, 1.0)

	# Keep standard gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	move_and_slide()

func play_animation(anim_name: String, speed_scale: float) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name, 0.15) # 0.15s blend time for smooth transitions
	animation_player.speed_scale = speed_scale
