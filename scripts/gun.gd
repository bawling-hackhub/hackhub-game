extends Node3D
var ammo:= 500

@onready var muzzle = $"Beretta Pistol/Muzzle"
@onready var bulletScene = preload("res://scenes/Bullet.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and ammo>0:
		shoot()
		
func shoot():
	var bullet = bulletScene.instantiate()
	var levelRoot = get_tree().get_root()
	levelRoot.add_child(bullet)

	
	bullet.global_transform = muzzle.global_transform
	ammo -= 1
	
