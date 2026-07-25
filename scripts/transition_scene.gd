extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func _ready() -> void:
	visible = false

func transition_to(path_to_scene: String) -> void:
	if Engine.time_scale != 1:
		Engine.time_scale = 1
	get_tree().paused = true
	animation_player.play("trans_animation")
	var timer = get_tree().create_timer(0.9)
	await timer.timeout
	switch_scene(path_to_scene)
	
func switch_scene(destination: String) -> void:
	get_tree().change_scene_to_file(destination)
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = true
	
func toggle_pause(to_resume: bool) -> void:
	if to_resume:
		get_tree().paused = false
		get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = true
		
