extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false

func transition_to(path_to_scene: String) -> void:
	animation_player.play("trans_animation")
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	switch_scene(path_to_scene)
	await animation_player.animation_finished
	visible = false
	
func switch_scene(destination: String) -> void:
	get_tree().change_scene_to_file(destination)
