extends Area3D
var speed : float = 200.0
var damage : int = 1
func _process(delta):
	translate(-Vector3.FORWARD * speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
func destroy():
	queue_free()
	
func _ready() -> void:
	look_at(-Vector3.FORWARD)
	
