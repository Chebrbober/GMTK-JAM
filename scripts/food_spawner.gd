class_name FoodSpawner extends Node

@export var food_scene: PackedScene
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
	spawn()
	
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
