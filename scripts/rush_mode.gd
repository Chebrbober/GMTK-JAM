extends Node

@onready var yellow_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone"
@onready var green_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone/GreenZone"
@onready var drum_and_base_sound: AudioStreamPlayer = $"../DrumAndBaseSound"
@onready var shader_rect: ColorRect = $ShaderRect
@onready var cut_bar: Control = %CutBar
@onready var current_modes: Control = $"../../CurrentModes"
@onready var y_initial_min_size_x := yellow_zone.custom_minimum_size.x
@onready var g_initial_min_size_x := green_zone.custom_minimum_size.x
@onready var timer: Timer = $Timer
var y_initial_size_x
var g_initial_size_x
var zone_id := get_instance_id()
var tween: Tween


func enable_mode() -> void:
	y_initial_size_x = yellow_zone.size.x
	g_initial_size_x = green_zone.size.x 
	yellow_zone.custom_minimum_size.x = 100
	green_zone.custom_minimum_size.x = 50
	cut_bar.temp_speed = 500 if 500 > cut_bar.speed else cut_bar.speed+50
	drum_and_base_sound.play()
	
	current_modes.add_label("Rush mode", zone_id, Color.DARK_ORANGE)
	
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_method(func(value):
		shader_rect.material.set_shader_parameter("line_width", value), 0.001, 0.1, 1).set_trans(Tween.TRANS_SINE)
	shader_rect.visible = true
	
	timer.start()
	
	while timer.time_left > 0:
		current_modes.update_time(zone_id, timer.time_left)
		if !is_inside_tree():
			return
		await get_tree().process_frame
		
	current_modes.delete_label(zone_id)
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
