class_name Cone extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Car"):
		body.collide_with_obstacle()
		$ScoreTrigger.disable_funcitons()
