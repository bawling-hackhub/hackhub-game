extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var body_mesh = $MeshInstance3D # Enemy body mesh
@onready var original_material = body_mesh.get_surface_override_material(0)

const SPEED = 3.0
var health := 5
var damage_color := preload("res://dark_red_material.tres")

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	nav_agent.set_velocity(new_velocity)
	
func update_target_location(target_location):
	# This will make the enemy continuously chase the player
	nav_agent.target_position = target_location
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func take_damage(damage: int):
	health -= damage
	
	# Flash red when hit
	flash_damage()
	
	# Check if health drops to zero
	if health <= 0:
		die()

func flash_damage():
	# Temporarily flash dark red color
	body_mesh.set_surface_override_material(0, damage_color)
	
	# Revert back after 0.3 seconds
	await get_tree().create_timer(0.3).timeout
	body_mesh.set_surface_override_material(0, original_material)
	
func die():
	# Despawn the enemy when dead
	queue_free()
