extends Control

@export_file("*.tscn") var main_menu_scene_path: String = ""
@export_file("*.tscn") var game_scene_path: String = ""
@onready var rich_text_label: RichTextLabel = $Panel/MarginContainer/VBoxContainer/PanelContainer/RichTextLabel
@onready var combo: Control = $"../Combo"

func _ready() -> void:
	visible = false

func appear() -> void:
	visible = true
	get_tree().paused = true
	rich_text_label.text = "Max combo: %d" % combo.max_succesful_cuts_done

func _on_retry_pressed() -> void:
	TransitionScene.transition_to(game_scene_path)

func _on_main_menu_pressed() -> void:
	TransitionScene.transition_to(main_menu_scene_path)
