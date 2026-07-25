extends CanvasLayer

@export_file("*.tscn") var path_to_menu_scene
@export_file("*.tscn") var path_to_game_scene
var can_toggle: bool = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and can_toggle:
		toggle()
		get_viewport().set_input_as_handled()

func toggle() -> void:
	if visible:
		resume()
	else:
		pause()

func pause() -> void:
	if can_toggle:
		get_tree().paused = true
		visible = true

func resume() -> void:
	if can_toggle:
		get_tree().paused = false
		visible = false

func _on_menu_pressed() -> void:
	TransitionScene.transition_to(path_to_menu_scene)
	can_toggle = false

func _on_quit_to_desktop_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	resume()

func _on_retry_pressed() -> void:
	TransitionScene.transition_to(path_to_game_scene)
