class_name Food extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var cutsRequired: int = 5
@export var cutsDone: int = 0
@export var available_sprites: Array[Texture2D]

signal finished

func _ready() -> void:
	if available_sprites != null or available_sprites.is_empty():
		sprite_2d.texture = available_sprites[randi_range(0, available_sprites.size() - 1)]
	
func cut() -> void:
	cutsDone += 1
	
	if cutsDone == cutsRequired:
		emit_signal("finished")
