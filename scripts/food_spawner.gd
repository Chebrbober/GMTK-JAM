class_name FoodSpawner extends Node

@export var food_scene: PackedScene
@export_dir var resources_folder
@export var foods: Array[FoodResource]
@onready var wind_audio: AudioStreamPlayer = $WindAudio
@onready var screen_size = get_viewport().get_visible_rect().size
@onready var start_pos = Vector2(screen_size.x+500, screen_size.y/2)
@onready var center_pos = screen_size / 2
@onready var cut_bar = %CutBar
var tween = create_tween()
var time_to_move: float = 1.0
var cut_acces: bool = false

signal cut_acces_changed(can_cut: bool)

func _ready() -> void:
	await search_for_food()
	spawn()
	
func search_for_food() -> void:
	foods.clear()

	var dir := DirAccess.open(resources_folder)
	if dir == null:
		push_error("Couldn't open folder: " + resources_folder)
		return

	dir.list_dir_begin()

	while true:
		var file := dir.get_next()

		if file == "":
			break
		if dir.current_is_dir():
			continue
		if file.ends_with(".tres"):
			var resource := load(resources_folder.path_join(file))
			if resource is FoodResource:
				foods.append(resource)

	dir.list_dir_end()

	print("Loaded ", foods.size(), " food resources.")
	
func spawn() -> void:
	var food = food_scene.instantiate()
	
	var data: FoodResource = foods.pick_random()
	
	food.data = data
	food.position = start_pos
	food.finished.connect(throw)
	cut_bar.mouse_clicked.connect(food.cut)
	
	add_child(food)
	move_to_center(food)
	
func move_to_center(node: Node2D) -> void:
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(node, "position", center_pos, time_to_move).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).from_current()
	
	wind_audio.pitch_scale = randf_range(0.9, 1.1)
	wind_audio.play()
	
	await tween.finished
	cut_acces = true
	cut_acces_changed.emit(cut_acces)
	
func throw(node: Node2D):
	cut_acces = false
	cut_acces_changed.emit(cut_acces)
	node.queue_free()
	spawn()
