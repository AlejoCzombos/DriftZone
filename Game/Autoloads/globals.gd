extends Node

var total_score: float = 0 : get = get_total_score, set = set_total_score

var current_score: float = 0 : 
	get:
		return current_score
	set(value):
		current_score = value

func get_total_score() -> float:
	return total_score

func set_total_score(value: float = 0) -> void:
	total_score += current_score
	current_score = 0
	Signals.update_total_score.emit(total_score)
