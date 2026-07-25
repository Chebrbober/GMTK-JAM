extends Control

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
var current_zones: Dictionary = {}

func add_label(zone_name: String, zone_id: int, color: Color, font_size := 32) -> void:
	var label := Label.new()
	label.text = zone_name
	label.set_meta("zone_name", zone_name)
	label.label_settings = LabelSettings.new()
	label.label_settings.font_color = color
	label.label_settings.font_size = font_size

	v_box_container.add_child(label)
	current_zones[zone_id] = label
	
func delete_label(zone_id: int) -> void:
	if current_zones.has(zone_id):
		current_zones[zone_id].queue_free()
		current_zones.erase(zone_id)

func update_time(zone_id: int, time_left: float) -> void:
	if current_zones.has(zone_id):
		var label: Label = current_zones[zone_id]
		var zone_name: String = label.get_meta("zone_name")
		label.text = "%s (%.1fs)" % [zone_name, time_left]
