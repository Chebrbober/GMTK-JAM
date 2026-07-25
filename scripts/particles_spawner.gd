extends Node

@onready var slice_particles: CPUParticles2D = $"../SliceParticles"
@onready var juice_particles: CPUParticles2D = $"../JuiceParticles"
@onready var sprite_2d: Sprite2D = $"../Sprite2D"

func spawn_particles() -> void:
	var new_juice_particles = juice_particles.duplicate()
	var new_slice_particles = slice_particles.duplicate()
	
	new_juice_particles.global_position = sprite_2d.global_position + sprite_2d.region_rect.size / 2
	new_juice_particles.emission_rect_extents = Vector2(1, sprite_2d.region_rect.size.y / 2)
	new_juice_particles.emitting = true
	
	new_slice_particles.global_position = sprite_2d.global_position + sprite_2d.region_rect.size / 2
	new_slice_particles.emitting = true
	
	var parent = get_tree().current_scene
	
	parent.add_child(new_juice_particles)
	parent.add_child(new_slice_particles)
	
