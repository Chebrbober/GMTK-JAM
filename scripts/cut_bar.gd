extends Control

@onready var red_zone: ColorRect = $PanelContainer/MarginContainer/RedZone
@onready var yellow_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone
@onready var green_zone: ColorRect = $PanelContainer/MarginContainer/YellowZone/GreenZone
@onready var panel_container: PanelContainer = $PanelContainer
@onready var indicator: ColorRect = %Indicator
@export var speed: float = 200
var direction: int = 1
var size_multiplier: float = 1.2
var speed_multiplier: float = 1.05
var max_size: float = 150
var can_cut: bool

signal mouse_clicked(type: CutType)

func _ready() -> void:
	yellow_zone.size.x *= 2
	green_zone.size.x *= 2
	randomize_pos()

func _process(delta: float) -> void:
	indicator.position.x += direction * speed * delta

	var right = panel_container.size.x - 5

	if indicator.position.x >= right:
		indicator.position.x = right
		direction = -1

	elif indicator.position.x <= 0:
		indicator.position.x = 0
		direction = 1

func randomize_pos():
	yellow_zone.position.x = randf_range(0 + yellow_zone.size.x, panel_container.size.x - yellow_zone.size.x  * 1.5)
	green_zone.position.x = yellow_zone.size.x / 2 - green_zone.size.x / 2

func is_indicator_in_zone(zone: Control) -> bool:
	return indicator.get_global_rect().intersects(zone.get_global_rect())

func _on_click_area_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("click"):
		return
	if !can_cut:
		return
	if is_indicator_in_zone(green_zone):
		print("perfect")
		mouse_clicked.emit(CutType.Result.PERFECT)
		update_zone_sizes(true)
	elif is_indicator_in_zone(yellow_zone):
		print("good")
		mouse_clicked.emit(CutType.Result.GOOD)
		update_zone_sizes(true)
	else:
		print('miss')
		mouse_clicked.emit(CutType.Result.MISS)
		update_zone_sizes(false)
	randomize_pos()
	
		
func update_zone_sizes(is_hit: bool) -> void:
	if is_hit and green_zone.size.x:
		green_zone.size.x /= size_multiplier
		yellow_zone.size.x /= size_multiplier
		speed *= speed_multiplier
	elif !is_hit and yellow_zone.size.x < 150:
		var yellow_zone_size: int = yellow_zone.size.x * (size_multiplier+0.3)
		if yellow_zone_size <= 150:
			yellow_zone.size.x = yellow_zone_size
			green_zone.size.x *= size_multiplier
			speed /= (speed_multiplier+0.3)

func _on_food_spawner_cut_acces_changed(cut_acces: bool) -> void:
	can_cut = cut_acces
