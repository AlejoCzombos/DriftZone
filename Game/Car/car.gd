class_name Car extends RigidBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var wheel_front_left: MeshInstance3D = $"wheel-front-left"
@onready var wheel_front_right: MeshInstance3D = $"wheel-front-right"

@export_range(0.1, 2) var rotation_force : float = 0.2
@export_range(0.1, 2) var engine_force : float = 0.5

@export var drift_angle : int = 20
@export var min_drift_velocity: int = 10

var push_force : Vector3 = Vector3.ZERO
var rotation_direction: int = 0

var raycast_length = 4
var is_drifting : bool = false

func _ready() -> void:
	camera_pivot.top_level = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var forward = -get_global_transform().basis.z
	
	var velocity_direction: Vector3 = linear_velocity.normalized()
	var angle_difference: float = forward.signed_angle_to(velocity_direction, Vector3.UP)
	angle_difference = rad_to_deg(angle_difference)
	
	var is_drifring_actual : bool = false
	
	if absf(angle_difference) > drift_angle and linear_velocity.length() > min_drift_velocity:
		is_drifring_actual = true
	else:
		is_drifring_actual = false
	
	if is_drifting != is_drifring_actual:
		toggle_is_drifting()
	
	$ScoreManager.calculate_score(angle_difference, linear_velocity.length())
	
	wheel_front_left.rotation.y = rotation_direction * deg_to_rad(drift_angle) * 2
	wheel_front_right.rotation.y = rotation_direction * deg_to_rad(drift_angle) * 2
	
	apply_central_impulse(forward * push_force.length())
	apply_torque_impulse(Vector3(0, rotation_direction * rotation_force, 0))
	camera_follows()

func camera_follows() -> void:
	var player_pos = global_transform.origin
	camera_pivot.transform.origin = player_pos

func _physics_process(delta: float) -> void:
	get_input(delta)

func get_input(delta) -> void:
	push_force = Vector3.ZERO
	rotation_direction = 0
	if Input.get_action_strength("accelerate"):
		push_force = Vector3.FORWARD * engine_force
	if Input.get_action_strength("brake"):
		push_force = Vector3.BACK * (engine_force * 0.4)
	if Input.get_action_strength("turn_left"):
		rotation_direction += 1
	if Input.get_action_strength("turn_right"):
		rotation_direction -= 1

func toggle_is_drifting() -> void:
	is_drifting = !is_drifting
	$GPUParticles3D.emitting = is_drifting
	$GPUParticles3D2.emitting = is_drifting
	
	#if is_drifting:
		#print("Derrapando")
	#else:
		#print("No derrapando")
		
