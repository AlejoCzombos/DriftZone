class_name ScoreManager extends Node

@onready var player_car : Car
@onready var wait_faild: Timer = $WaitFaild
@onready var drift_timer: Timer = $DriftTimer

func _ready() -> void:
	player_car = get_parent()

func calculate_score(angle: float, velocity: float):
	if wait_faild.is_stopped():
		var new_score = absf(angle) * velocity * 0.1
		Globals.current_score += new_score
		Signals.update_current_score.emit(Globals.current_score)

func apply_score() -> void:
	if drift_timer.is_stopped() and Globals.current_score > 0:
		drift_timer.start()

func lose_score() -> void:
	wait_faild.start()
	if Globals.current_score != 0:
		print("puntuacion perdida")
		Signals.failed_score.emit()
		Globals.current_score = 0

func _on_drift_timer_timeout() -> void:
	print("puntiacion aplicada")
	Signals.apply_score.emit()
	Globals.set_total_score()
