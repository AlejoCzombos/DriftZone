class_name score_manager extends Node

@onready var player_car : Car

func _ready() -> void:
	player_car = get_parent()

var current_score: float = 0

func calculate_score(angle: float, velocity: float):
	Signals.update_current_rotation.emit(angle)
	Signals.update_current_velocity.emit(velocity * 2)
	if player_car.is_drifting:
		$DriftTimer.stop()
		var score = absf(angle) * velocity * 0.1
		current_score += score
		Signals.update_score.emit(current_score)
	else:
		if $DriftTimer.is_stopped():
			$DriftTimer.start()

func _on_drift_timer_timeout() -> void:
	Signals.delete_score.emit()
	current_score = 0
