extends PanelContainer

@onready var yellow_zone: ColorRect = $MarginContainer/YellowZone
@onready var green_zone: ColorRect = $MarginContainer/YellowZone/GreenZone
@onready var margin_container: MarginContainer = $MarginContainer

func randomize_pos():
	yellow_zone.position.x = randf_range(0 + yellow_zone.size.x / 2, margin_container.size.x - yellow_zone.size.x / 2)
