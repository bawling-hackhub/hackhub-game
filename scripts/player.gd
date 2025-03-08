extends CharacterBody3D

const SPRINT_SPEED := 6.0
const WALK_SPEED := 4.0
const CROUCH_SPEED := 2.0
const JUMP_VELOCITY := 7
const MOUSE_SENS := 0.2
const LERP_SPEED := 10.0
const GRAVITY := 20.0  # Define gravity as a constant

@onready var head = $Head
@onready var standing_collision_shape = $StandCollisionShape
@onready var crouching_collision_shape = $CrouchCollisionShape
@onready var raycast = $RayCast3D
@onready var score = $Head/Camera3D/Score

var current_speed := 3.0
var direction := Vector3.ZERO
var CROUCHING_DEPTH := -0.5
var is_paused := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if is_paused and event is not InputEventKey:
		return

		
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENS))
		head.rotate_x(-deg_to_rad(event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta: float) -> void:
	if is_paused:
		return
	
	if Input.is_action_pressed("crouch"):
		current_speed = CROUCH_SPEED
		head.position.y = lerp(head.position.y, 0.8 + CROUCHING_DEPTH, LERP_SPEED * delta)
		crouching_collision_shape.disabled = false
		standing_collision_shape.disabled = true
	elif !raycast.is_colliding(): 
		crouching_collision_shape.disabled = true
		standing_collision_shape.disabled = false
		head.position.y = lerp(head.position.y, 0.8, LERP_SPEED * delta)
		if Input.is_action_pressed('sprint'):
			current_speed = SPRINT_SPEED
		else:
			current_speed = WALK_SPEED
	
	# Handle gravity - fixed version
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * LERP_SPEED)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	score.text = "Score: " + str(Autoscript.score)
	
	move_and_slide()
