extends Control

@onready var score_label: Label = $ScoreLabel
@onready var rotation_label: Label = $RotationLabel
@onready var velocity_label: Label = $VelocityLabel

func _ready() -> void:
	Signals.update_score.connect(update_score)
	Signals.update_current_rotation.connect(update_rotation)
	Signals.update_current_velocity.connect(update_velocity)
	Signals.delete_score.connect(delete_score)

func update_score(new_score: float) -> void:
	score_label.text = str(roundi(new_score))

func update_velocity(current_velocity: float) -> void:
	velocity_label.text = str(roundi(current_velocity))

func update_rotation(current_rotation: float) -> void:
	rotation_label.text = str(roundi(current_rotation))

func delete_score() -> void:
	var tween_faild_score : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween_faild_score.tween_method(tween_text, int(score_label.text), 0, .7)
	#tween_faild_score.tween_property(score_label, "theme_override_colors/font_color", Color.RED, 1)

func tween_text(score: int) -> void:
	score_label.text = str(score)
