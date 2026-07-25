extends Node

@onready var yellow_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone"
@onready var green_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone/GreenZone"
@onready var drum_and_base_sound: AudioStreamPlayer = $"../DrumAndBaseSound"
@onready var shader_rect: ColorRect = $ShaderRect
@onready var cut_bar: Control = %CutBar
@onready var y_initial_size_x := yellow_zone.size.x
@onready var g_initial_size_x := green_zone.size.x
@onready var y_initial_min_size_x := yellow_zone.custom_minimum_size.x
@onready var g_initial_min_size_x := green_zone.custom_minimum_size.x
var tween: Tween


func enable_mode() -> void:
	yellow_zone.custom_minimum_size.x = 150
	green_zone.custom_minimum_size.x = 100
	cut_bar.temp_speed = 500
	drum_and_base_sound.play()
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(func(value):
		shader_rect.material.set_shader_parameter("line_width", value), 0.001, 0.1, 1).set_trans(Tween.TRANS_SINE)
	shader_rect.visible = true
	
	await get_tree().create_timer(10.0, true, false, true).timeout
	disable_mode()
	
func disable_mode() -> void:
	cut_bar.temp_speed = -1
	yellow_zone.custom_minimum_size.x = y_initial_min_size_x
	green_zone.custom_minimum_size.x = g_initial_min_size_x
	yellow_zone.size.x = y_initial_size_x
	green_zone.size.x = g_initial_size_x
	
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(func(value):
		shader_rect.material.set_shader_parameter("line_width", value), 0.1, 0.001, 1).set_trans(Tween.TRANS_SINE)
	shader_rect.visible = false
