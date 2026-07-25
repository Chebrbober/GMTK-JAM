class_name Food extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var slice_particles: CPUParticles2D = $SliceParticles
@onready var juice_particles: CPUParticles2D = $JuiceParticles
@onready var particles_spawner: Node = $ParticlesSpawner
@export var cuts_required: int = 5
@export var cuts_done: int = 0
@export var data: FoodResource

signal finished(node: Node2D)

func _ready() -> void:
	setup(data)
	sprite_2d.region_enabled = true
	sprite_2d.region_rect = Rect2(
		Vector2.ZERO,
		sprite_2d.texture.get_size()
	)
	
func setup(data: FoodResource) -> void:
	cuts_required = data.cuts_required
	sprite_2d.texture = data.sprite
	slice_particles.texture = data.slice_sprite
	juice_particles.color = data.juice_particles_color

func cut(type: CutType.Result) -> void:
	if type == CutType.Result.MISS:
		return
	cuts_done += 1
	
	var remaining = cuts_required - cuts_done
	var fraction = float(remaining) / cuts_required
	
	var rect = sprite_2d.region_rect
	rect.size.x = sprite_2d.texture.get_width() * fraction
	sprite_2d.region_rect = rect
	
	particles_spawner.spawn_particles()
	
	if cuts_done == cuts_required:
		finished.emit(self)
