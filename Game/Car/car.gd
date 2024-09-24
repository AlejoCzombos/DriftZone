class_name Car extends RigidBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var wheel_front_left: MeshInstance3D = $"wheel-front-left"
@onready var wheel_front_right: MeshInstance3D = $"wheel-front-right"
@onready var score_manager: ScoreManager = $ScoreManager

enum STATE {
	IDLE,
	DRIVING,
	DRIFTING,
	CRASHED
}

@export_range(0.1, 2) var rotation_force : float = 0.2
@export_range(0.1, 2) var engine_force : float = 0.5

@export var drift_angle : int = 20
@export var min_drift_velocity: int = 10

var push_force : Vector3 = Vector3.ZERO
var rotation_direction: int = 0
var current_angle: float = 0
var raycast_length = 4

var current_state : STATE = STATE.IDLE

func state_controller(new_state: STATE) -> void:
	if new_state == current_state:
		return
	match new_state:
		STATE.IDLE:
			print("Idle")
		STATE.DRIVING:
			score_manager.apply_score()
			print("Andando")
			$GPUParticles3D.emitting = false
			$GPUParticles3D2.emitting = false
		STATE.DRIFTING:
			print("drifteando")
			$GPUParticles3D.emitting = true
			$GPUParticles3D2.emitting = true
		STATE.CRASHED:
			score_manager.lose_score()
			new_state = STATE.DRIVING
		_:
			printerr("ERROR ESTADO")
	current_state = new_state

func _ready() -> void:
	camera_pivot.top_level = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var forward = -get_global_transform().basis.z
	
	var velocity_direction: Vector3 = linear_velocity.normalized()
	current_angle = rad_to_deg(forward.signed_angle_to(velocity_direction, Vector3.UP))
	
	if absf(current_angle) > drift_angle and linear_velocity.length() > min_drift_velocity:
		state_controller(STATE.DRIFTING)
		score_manager.calculate_score(current_angle, linear_velocity.length())
	else:
		if linear_velocity.length() < 0.1:
			state_controller(STATE.IDLE)
		else:
			state_controller(STATE.DRIVING)
	
	update_hud()
	
	wheel_front_left.rotation.y = rotation_direction * deg_to_rad(drift_angle) * 2
	wheel_front_right.rotation.y = rotation_direction * deg_to_rad(drift_angle) * 2
	
	apply_central_impulse(forward * push_force.length())
	apply_torque_impulse(Vector3(0, rotation_direction * rotation_force, 0))
	camera_follows()

func update_hud() -> void:
	Signals.update_current_rotation.emit(current_angle if current_state != STATE.IDLE else 0.0)
	Signals.update_current_velocity.emit(linear_velocity.length() * 2)

func collide_with_obstacle() -> void:
	state_controller(STATE.CRASHED)

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
