extends CharacterBody3D

const SPRINT_SPEED := 7.0
const WALK_SPEED := 4.0
const CROUCH_SPEED := 2.0
const JUMP_VELOCITY := 9
const MOUSE_SENS := 0.2
const LERP_SPEED := 10.0
const GRAVITY := 20.0  # Define gravity as a constant

var health := 100

@onready var head = $Head
@onready var standing_collision_shape = $StandCollisionShape
@onready var crouching_collision_shape = $CrouchCollisionShape
@onready var raycast = $RayCast3D
@onready var score = $Head/Camera3D/Score
@onready var healthtext = $Head/Camera3D/Health

var current_speed := 3.0
var direction := Vector3.ZERO
var CROUCHING_DEPTH := -0.5
var is_paused := false
var can_take_damage := true

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
	
func take_damage():
	if(!can_take_damage): return
	health -= 20
	health = clamp(health, 0, 100)
	healthtext.text = "Health: " + str(health)
	can_take_damage = false
	$Head/Camera3D.apply_shake()
	$Timer.start(2);
	
	if(health == 0):
		Autoscript.ammo = 6
		Autoscript.score = 0
		$"../CanvasLayer/DeathMenu".turn_on()

func is_dead():
	return health <= 0;

func _on_timer_timeout() -> void:
	can_take_damage = true
