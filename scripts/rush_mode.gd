extends Node

@onready var yellow_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/YellowZone"
@onready var green_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/YellowZone/GreenZone"
@onready var cut_bar: Control = %CutBar
@onready var y_initial_size_x := yellow_zone.size.x
@onready var g_initial_size_x := green_zone.size.x


func enable_mode() -> void:
	yellow_zone.size.x = 200
	green_zone.size.x = 125
	cut_bar.temp_speed = 450
	
	await get_tree().create_timer(5.0).timeout
	disable_mode()
	
func disable_mode() -> void:
	cut_bar.temp_speed = -1
