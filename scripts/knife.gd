extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var cut_sounds: Array[AudioStream]

func play_cut() -> void:
	animation_player.play("cut")
	pick_random_sound()
	
func pick_random_sound() -> void:
	var rand_cut_sound: AudioStream = cut_sounds.pick_random()
	audio_stream_player.stream = rand_cut_sound
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player.play()
