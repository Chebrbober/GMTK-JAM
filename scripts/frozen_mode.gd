extends Node

@onready var cut_bar: Control = %CutBar
@onready var manual_control: Control = $"../../CutBar/PanelContainer/MarginContainer/ManualControl"
@onready var panel_container: PanelContainer = $"../../CutBar/PanelContainer"
@onready var yellow_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone"
@onready var shader_rect: ColorRect = $ShaderRect
@onready var material := shader_rect.material
@onready var current_modes: Control = $"../../CurrentModes"
@onready var wind_stream_player: AudioStreamPlayer = $WindStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer
@export var frozen_zone: ColorRect
var zone_id := get_instance_id()
var tween: Tween

func create_zone() -> void:
	print('creating zone')
	frozen_zone = ColorRect.new()
	frozen_zone.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	frozen_zone.custom_minimum_size = Vector2(30, 40)
	frozen_zone.color = Color8(30, 125, 255, 255)
	frozen_zone.name = "FrozenZone"
	frozen_zone.material = material
	frozen_zone.material.set_shader_parameter("strength", 0.7)
	frozen_zone.material.set_shader_parameter("distortion", 0.4)
	frozen_zone.material.set_shader_parameter("border_size", 32)

	while true:
		frozen_zone.position.x = randf_range(frozen_zone.custom_minimum_size.x, panel_container.size.x - frozen_zone.custom_minimum_size.x)
		
		if !get_parent().overlaps_x(frozen_zone, yellow_zone):
			break
			
	manual_control.add_child(frozen_zone)
	var timer = get_tree().create_timer(5.0)
	timer.timeout.connect(delete_on_timeout)

func enable_mode() -> void:
	if tween:
		tween.kill()
		
	wind_stream_player.play()
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player.play()
		
	cut_bar.temp_speed = cut_bar.speed*1.25
		
	print("enabled zone")
	current_modes.add_label("Frozen mode", zone_id, Color.SKY_BLUE)
	tween = create_tween()
	tween.tween_property(Engine, "time_scale", 0.5, 2).from_current()
	
	shader_rect.visible = true
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("strength", value), 0.0, 0.8, 2.0)
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("border_size", value), 0.0, 0.1, 2.0)
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("distortion", value), 0.0, 0.008, 2.0)
	
	timer.start()
	
	while timer.time_left > 0:
		current_modes.update_time(zone_id, timer.time_left)
		await get_tree().process_frame
	
	current_modes.delete_label(zone_id)
	disable_mode()

func disable_mode() -> void:
	print("frozen zone disabled")
	cut_bar.temp_speed = -1
	
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player.play()
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(Engine, "time_scale", 1, 2).from_current()
	
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("strength", value), 0.8, 0.0, 2.0)
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("border_size", value), 0.1, 0.0, 2.0)
	tween.parallel().tween_method(func(value):
		material.set_shader_parameter("distortion", value), 0.008, 0.0, 2.0)
	
	await tween.finished
	shader_rect.visible = false

func _on_cut_bar_mouse_clicked(type: CutType.Result) -> void:
	if type == CutType.Result.FROZEN:
		enable_mode()
		if is_instance_valid(frozen_zone):
			frozen_zone.queue_free()
		
func delete_on_timeout() -> void:
	if is_instance_valid(frozen_zone):
		frozen_zone.queue_free()
