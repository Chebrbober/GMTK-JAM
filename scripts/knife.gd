extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_cut() -> void:
	animation_player.play("cut")
