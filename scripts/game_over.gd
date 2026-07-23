extends Control

@export_file("*.tscn") var main_menu_scene_path: String = ""
@export_file("*.tscn") var game_scene_path: String = ""

func _ready() -> void:
	visible = false

func appear() -> void:
	visible = true
	get_tree().paused = true

func _on_retry_pressed() -> void:
	TransitionScene.transition_to(game_scene_path)

func _on_main_menu_pressed() -> void:
	TransitionScene.transition_to(main_menu_scene_path)
