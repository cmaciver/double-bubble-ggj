extends CharacterBody2D

const SPEED = 400.0
var jump_velocity = -500.0
signal bubble_touched
signal fan_shot
var is_aiming = false
var aim_dir = Vector2()
var jump_mult : float = 0.0
var is_jumping: bool
var is_bouncing: bool
var bounce_timer = 0.0

@onready var wind : Area2D = $WindGun

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false
		
	if bounce_timer > 0.0:
		bounce_timer -= 0.03;
		if(bounce_timer <= 0.0):
			bounce_timer = 0
			is_jumping = false
			print("no longer bouncing")
		
		
	if(Input.is_action_just_pressed("platform_jump") and bounce_timer > 0.0):
		is_jumping = true

	# If you release jump set jumping to false.
	if(Input.is_action_just_released("platform_jump")):
		is_jumping = false
	
	# If you start pressing jump and you're on the floor, start the jump with starting velocity
	if Input.is_action_just_pressed("platform_jump") and is_on_floor():
		is_jumping = true;
		velocity.y = jump_velocity
		
	elif is_jumping and Input.is_action_pressed("platform_jump") and jump_velocity > -600:
		jump_velocity *= 1.01;
		velocity.y = jump_velocity
		
	elif !Input.is_action_pressed("platform_jump") and is_on_floor():
		jump_velocity = -500
		
	if velocity.y > 0:
		velocity.y *= 1.01
		
		
	if Input.is_action_just_pressed("platform_aim"):
		is_aiming = true
		wind.show()
		
	if Input.is_action_just_released("platform_aim"):
		is_aiming = false
		wind.hide()
		#fan()
		
	if is_aiming:
		pass
		#velocity.y = JUMP_VELOCITY
	
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
		#wind.hide()
		var direction := Input.get_axis("platform_left", "platform_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("pop"):
			#bubble_touched.emit(collision.get_collider())
			if(position.y < collision.get_collider().position.y):
				print("what is good")
				bounce_timer = .8;
				jump_velocity = -500;
				velocity.y = jump_velocity;
