extends Node

@onready var cut_bar: Control = %CutBar
@onready var manual_control: Control = $"../../CutBar/PanelContainer/MarginContainer/ManualControl"
@onready var panel_container: PanelContainer = $"../../CutBar/PanelContainer"
@onready var yellow_zone: ColorRect = $"../../CutBar/PanelContainer/MarginContainer/ManualControl/YellowZone"
@export var frozen_zone: ColorRect

func create_zone() -> void:
	print('creating zone')
	frozen_zone = ColorRect.new()
	frozen_zone.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	frozen_zone.custom_minimum_size = Vector2(30, 40)
	frozen_zone.color = Color8(30, 125, 255, 255)
	frozen_zone.name = "FrozenZone"
	
	while true:
		frozen_zone.position.x = randf_range(frozen_zone.custom_minimum_size.x, panel_container.size.x - frozen_zone.custom_minimum_size.x)
		
		if !get_parent().overlaps_x(frozen_zone, yellow_zone):
			break
			
	manual_control.add_child(frozen_zone)

func enable_mode() -> void:
	print("enabled zone")
	Engine.time_scale = 0.5
	cut_bar.temp_speed = cut_bar.speed*1.25
	await get_tree().create_timer(5.0).timeout
	disable_mode()

func disable_mode() -> void:
	print("frozen zone disabled")
	Engine.time_scale = 1
	cut_bar.temp_speed = -1

func _on_cut_bar_mouse_clicked(type: CutType.Result) -> void:
	if type == CutType.Result.FROZEN:
		enable_mode()
		frozen_zone.queue_free()
