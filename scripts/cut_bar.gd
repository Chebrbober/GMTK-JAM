extends Control

@onready var red_zone: ColorRect = $PanelContainer/MarginContainer/RedZone
@onready var yellow_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone
@onready var green_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone/GreenZone
@onready var panel_container: PanelContainer = $PanelContainer
@onready var indicator: ColorRect = %Indicator
@export var time_to_move: float = 1.0
var tween: Tween
var multiplier: float = 1.5
var max_size: float = 150

signal mouse_clicked

func _ready() -> void:
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(indicator, "position:x", panel_container.size.x - 5, time_to_move)
	tween.tween_property(indicator, "position:x", 0, time_to_move)

func randomize_pos():
	yellow_zone.position.x = randf_range(0 + yellow_zone.size.x, panel_container.size.x - yellow_zone.size.x  * 1.5)
	green_zone.position.x = yellow_zone.size.x / 2 - green_zone.size.x / 2

func is_indicator_in_zone(zone: Control) -> bool:
	return indicator.get_global_rect().intersects(zone.get_global_rect())

func _on_click_area_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("click"):
		return
	if is_indicator_in_zone(green_zone):
		print("perfect")
		emit_signal("mouse_clicked")
		randomize_pos()
		update_zone_sizes(true)
	elif is_indicator_in_zone(yellow_zone):
		print("good")
		emit_signal("mouse_clicked")
		randomize_pos()
		update_zone_sizes(true)
	else:
		print('miss')
		randomize_pos()
		update_zone_sizes(false)
		
func update_zone_sizes(is_hit: bool) -> void:
	if is_hit and green_zone.size.x:
		green_zone.size.x /= multiplier
		yellow_zone.size.x /= multiplier
	elif !is_hit and green_zone.size.x and yellow_zone.size.x < 150:
		var yellow_zone_size: int = yellow_zone.size.x * multiplier
		if yellow_zone_size <= 150:
			yellow_zone.size.x = yellow_zone_size
			green_zone.size.x *= multiplier
	
