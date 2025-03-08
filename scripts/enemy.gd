extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var body_mesh = $MeshInstance3D # Enemy body mesh
@onready var original_material = body_mesh.get_surface_override_material(0)

const SPEED = 3.0
var health := 3
var damage_color := preload("res://dark_red_material.tres")

func _physics_process(delta: float) -> void:
	# Move the enemy toward the player
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	nav_agent.set_velocity(new_velocity)
	
	# 💀🔥 FIX: Only rotate if the enemy is far enough from the target
	if current_location.distance_to(next_location) > 0.1:
		look_at(Vector3(next_location.x, global_position.y, next_location.z))
		rotate_y(deg_to_rad(180)) # Corrects the backwards mesh

func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func take_damage(damage: int):
	health -= damage
	
	# Flash dark red when hit
	flash_damage()
	
	# Check if health drops to zero
	if health <= 0:
		Autoscript.score +=1
		die()

func flash_damage():
	# Override the entire mesh material in one shot
	body_mesh.material_override = damage_color
	
	# Smoothly fade back to normal color
	await get_tree().create_timer(0.1).timeout
	body_mesh.material_override = null  # Resets back to normal

func die():
	queue_free()
