class_name ScoreManager extends Node

@onready var player_car : Car

func _ready() -> void:
	player_car = get_parent()

var current_score: float = 0

func calculate_score(angle: float, velocity: float):
	$DriftTimer.stop()
	var score = absf(angle) * velocity * 0.1
	current_score += score
	Signals.update_score.emit(current_score)

func apply_score() -> void:
	if $DriftTimer.is_stopped() and current_score > 0:
		$DriftTimer.start()

func lose_score() -> void:
	print("puntuacion perdida")
	Signals.failed_score.emit()
	current_score = 0

func _on_drift_timer_timeout() -> void:
	print("puntiacion aplicada")
	$DriftTimer.stop()
	Signals.apply_score.emit()
	current_score = 0
