extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0
signal bubble_touched
signal fan_shot
var is_aiming = false
var aim_dir = Vector2()
var jump_mult : float = 0.0

@onready var wind : Area2D = $WindGun

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("platform_jump") and is_on_floor():
		jump_mult = 0.0
		#velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("platform_aim"):
		is_aiming = true
		wind.show()
		
	if Input.is_action_just_released("platform_aim"):
		is_aiming = false
		wind.hide()
		#fan()
		
	if is_aiming:
		velocity.y = JUMP_VELOCITY
	
	# Aiming
	if Input.is_action_pressed("platform_aim"):
		wind.show()
		aim_dir = Input.get_vector("platform_left", "platform_right", "platform_up", "platform_down")
		wind.gravity_direction = aim_dir
		wind.rotation = aim_dir.angle()
		if is_on_floor():
			velocity = Vector2()
	
	# Normal Movement
	else:
		wind.hide()
		var direction := Input.get_axis("platform_left", "platform_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("pop"):
			bubble_touched.emit(collision.get_collider())
