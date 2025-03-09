extends Camera3D

@export var randomStrength: float = 1
@export var shakeFade: float = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func apply_shake():
	shake_strength = randomStrength
	
func randomRotation() -> Vector3:
	return Vector3(
		rng.randf_range(-shake_strength,shake_strength),
		rng.randf_range(-shake_strength,shake_strength),
		0)
	
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength,0.0,shakeFade * delta)
		rotation = randomRotation()


	
