extends Node3D
var ammo:= 6

@onready var muzzle = $"Muzzle"
@onready var bulletScene = preload("res://scenes/Bullet.tscn")
@onready var animation_player = $AnimationPlayer 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and ammo > 0 and not animation_player.is_playing():
		shoot()
		
	if (Input.is_action_just_pressed("reload") or ammo <= 0) and not animation_player.is_playing() and ammo!=6: 
		animation_player.play("reload")
		# Automatically trigger a reload when animation is done
		animation_player.animation_finished.connect(_on_reload_finished, CONNECT_ONE_SHOT)
		
func _on_reload_finished(anim_name):
	if anim_name == "reload":
		ammo = 6 # Refill ammo after reload
		animation_player.stop()

func shoot():
	# Instantiate the bullet
	var bullet = bulletScene.instantiate()
	var levelRoot = get_tree().get_root()
	levelRoot.add_child(bullet)

	# 💯 Always set the global transform BEFORE recoil affects it
	bullet.global_transform = muzzle.global_transform

	# Reduce ammo
	ammo -= 1

	# Stop any running animation first
	animation_player.stop()

	# 🚀 Play the recoil animation
	animation_player.play("recoil", -1)

	# ✅ Wait exactly 0.1 seconds, then STOP the recoil cleanly
	await get_tree().create_timer(0.1).timeout
	animation_player.stop()

	# 🧠 Reset the gun's transform after the recoil
	muzzle.global_transform = $Muzzle.global_transform



	
