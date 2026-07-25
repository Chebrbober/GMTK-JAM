extends Control

@export_file("*.tscn") var path_to_game_scene

func _on_play_pressed() -> void:
	TransitionScene.transition_to(path_to_game_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
