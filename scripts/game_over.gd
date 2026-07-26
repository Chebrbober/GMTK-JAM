extends Control

@export_file("*.tscn") var main_menu_scene_path: String = ""
@export_file("*.tscn") var game_scene_path: String = ""
@onready var rich_text_label: RichTextLabel = $Panel/MarginContainer/VBoxContainer/PanelContainer/RichTextLabel
@onready var panel: Panel = $Panel
@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var combo: Control = $"../Combo"
@onready var timer: Timer = $Timer
var elapsed_time: float = 0.0

func _ready() -> void:
	visible = false
	timer.start()

func appear() -> void:
	timer.stop()
	visible = true
	get_tree().paused = true
	
	rich_text_label.text = "Max combo: %d\nTime: %.1f s" % [
		combo.max_succesful_cuts_done,
		elapsed_time
	]

func _on_retry_pressed() -> void:
	TransitionScene.transition_to(game_scene_path)

func _on_main_menu_pressed() -> void:
	TransitionScene.transition_to(main_menu_scene_path)

func _on_timer_timeout() -> void:
	elapsed_time += timer.wait_time

func _on_margin_container_resized() -> void:
	panel.size = margin_container.size
