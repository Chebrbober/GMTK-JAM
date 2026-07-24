extends Control

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	timer.autostart = true

func pick_random_event() -> void:
	for child in get_children():
		if child.has_method("create_zone"):
			child.create_zone()
			print("found available zone")
		elif child != Node:
			continue
			
func overlaps_x(a: Control, b: Control) -> bool:
	return (
		a.position.x < b.position.x + b.size.x
		and b.position.x < a.position.x + a.size.x
	)
