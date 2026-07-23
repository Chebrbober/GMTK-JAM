extends Control

@onready var yellow_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone
@onready var green_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone/GreenZone
@onready var panel_container: PanelContainer = $PanelContainer
@onready var indicator: ColorRect = %Indicator
@export var time_to_move: float = 1.0
var tween: Tween

func _ready() -> void:
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(indicator, "position:x", panel_container.size.x - 5, time_to_move)
	tween.tween_property(indicator, "position:x", 0, time_to_move)

func randomize_pos():
	yellow_zone.position.x = randf_range(0 + yellow_zone.size.x / 2, panel_container.size.x - yellow_zone.size.x / 2)
