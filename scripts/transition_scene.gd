extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func _ready() -> void:
	visible = false

func transition_to(path_to_scene: String) -> void:
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	animation_player.play("trans_animation")
	var timer = get_tree().create_timer(1.0)
	await timer.timeout
	get_tree().paused = true
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	switch_scene(path_to_scene)
	await animation_player.animation_finished
	visible = false
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	
func switch_scene(destination: String) -> void:
	get_tree().change_scene_to_file(destination)
