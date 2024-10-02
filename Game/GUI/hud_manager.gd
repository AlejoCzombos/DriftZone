extends Control

@onready var total_score_label: Label = $TotalScoreLabel
@onready var current_score_label: Label = $CurrentScoreLabel
@onready var rotation_label: Label = $RotationLabel
@onready var velocity_label: Label = $VelocityLabel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Signals.update_current_score.connect(update_current_score)
	Signals.update_total_score.connect(update_total_score)
	Signals.update_current_rotation.connect(update_rotation)
	Signals.update_current_velocity.connect(update_velocity)
	Signals.failed_score.connect(failed_score_animation)
	Signals.apply_score.connect(apply_score_animation)

func update_current_score(new_score: float) -> void:
	animation_player.play("drift_time")
	current_score_label["theme_override_colors/font_color"] = Color.WHITE
	current_score_label.text = str(roundi(new_score))
	
func update_total_score(new_score: float) -> void:
	total_score_label.text = str(roundi(new_score))

func update_velocity(current_velocity: float) -> void:
	velocity_label.text = str(roundi(current_velocity))

func update_rotation(current_rotation: float) -> void:
	rotation_label.text = str(roundi(current_rotation))

func apply_score_animation() -> void:
	var tween_failed_score : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween_failed_score.tween_method(tween_text, int(current_score_label.text), 0, .5)
	animation_player.stop()

func failed_score_animation() -> void:
	animation_player.stop()
	var tween_failed_score : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	#tween_failed_score.tween_property(score_label, "theme_override_colors/font_color", Color.RED, 1)
	current_score_label["theme_override_colors/font_color"] = Color.RED
	tween_failed_score.tween_method(tween_text, int(current_score_label.text), 0, .1)

func tween_text(score: int) -> void:
	current_score_label.text = str(score)
