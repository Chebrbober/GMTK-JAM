class_name Food extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var cuts_required: int = 5
@export var cuts_done: int = 0
@export var available_sprites: Array[Texture2D]

signal finished(node: Node2D)

func _ready() -> void:
	if !available_sprites.is_empty():
		sprite_2d.texture = available_sprites[randi_range(0, available_sprites.size() - 1)]
		
	sprite_2d.region_enabled = true
	sprite_2d.region_rect = Rect2(
		Vector2.ZERO,
		sprite_2d.texture.get_size()
	)
	
func cut(type: CutType.Result) -> void:
	if type == CutType.Result.MISS:
		return
	cuts_done += 1
	
	var remaining = cuts_required - cuts_done
	var fraction = float(remaining) / cuts_required
	
	var rect = sprite_2d.region_rect
	rect.size.x = sprite_2d.texture.get_width() * fraction
	sprite_2d.region_rect = rect
	
	if cuts_done == cuts_required:
		finished.emit(self)
