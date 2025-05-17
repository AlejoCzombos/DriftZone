extends Node3D

var player_car : Car
var obstacule_pivot : RigidBody3D

func _ready() -> void:
	obstacule_pivot = get_parent()

func _process(delta: float) -> void:
	if player_car != null and player_car:
		var player_position = player_car.global_position
		var obstacule_position = obstacule_pivot.global_position
		#print("Angle OBSTACLE: ", rad_to_deg(player_position.signed_angle_to(obstacule_position, Vector3.UP)))
		print("Angle: PLAYER", rad_to_deg(obstacule_position.angle_to(player_position)))
	#print(player_car)

func disable_funcitons() -> void:
	$ExitArea.monitoring = false
	$EntryArea.monitoring = false
	$ExitArea/CollisionShape3D.disabled = true
	$EntryArea/CollisionShape3D.disabled = true
	player_car = null

func _on_entry_area_body_entered(body: Node3D) -> void:
	if body is Car:
		player_car = body
		print("Entre")

func _on_exit_area_body_exited(body: Node3D) -> void:
	if body is Car:
		player_car = null
		print("Sali")
