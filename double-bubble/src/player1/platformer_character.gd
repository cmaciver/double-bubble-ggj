extends CharacterBody2D
class_name PlatformerCharacter

# movement speed
const SPEED = 300.0

#default jump velocity @ start of jump
const JUMP_DEFAULT = -350.0

#jump velocity, updated as you jump
var jump_velocity : float

#is shift being held
var is_aiming = false

#direction of fan aim
var aim_dir = Vector2()

var is_jumping: bool
var was_on_floor: bool = true

#window of time where you can heighten jump after bouncing off bubble
var bounce_timer = 0.0

@onready var wind : Area2D = $WindGun
@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if animation_player.animation.contains("fan"):
		animation_player.offset.y = 3
	else:
		animation_player.offset.y = 0
	#Animation
	if is_aiming:
		var aim_angle = round(rad_to_deg(aim_dir.angle()))
		animation_player.offset.y = 3
		match aim_angle:
			0.0: 
				animation_player.play('fan_side')
				animation_player.flip_h = false
			45.0: 
				animation_player.play('fan_angle_down')
				animation_player.flip_h = false
			90.0:
				animation_player.play('fan_down')
				animation_player.flip_h = false	
			135.0: 
				animation_player.play('fan_angle_down')
				animation_player.flip_h = true
			180.0: 
				animation_player.play('fan_side')
				animation_player.flip_h = true
			-135.0: 
				animation_player.play('fan_angle_up')
				animation_player.flip_h = true
			-90.0: 
				animation_player.play('fan_up')
				animation_player.flip_h = false
			-45.0: 
				animation_player.play('fan_angle_up')
				animation_player.flip_h = false
			_:
				pass
			
	elif Input.is_action_just_pressed("platform_jump") or (!is_on_floor() and was_on_floor):
		animation_player.play('platform_jump')
	elif(animation_player.animation == "platform_land" and animation_player.is_playing()):
		pass
	elif is_on_floor() and !was_on_floor:
		animation_player.play("platform_land")
	elif Input.get_axis("platform_left", "platform_right") < 0:
		if is_on_floor():
			animation_player.play("platform_run")
		animation_player.flip_h = true
	elif Input.get_axis("platform_left", "platform_right") > 0:
		if is_on_floor():
			animation_player.play("platform_run")
		animation_player.flip_h = false
	elif is_on_floor() and !animation_player.is_playing() or animation_player.animation == "platform_run":
		animation_player.play("platform_idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_on_floor = false
	else:
		was_on_floor = true
		if(Input.is_action_pressed("platform_jump")):
			is_jumping = true
			jump_velocity = JUMP_DEFAULT
			velocity.y = jump_velocity
		else: 
			is_jumping = false
		
	#if you're bouncing, count down on the bounce timer
	if bounce_timer > 0.0:
		bounce_timer -= 0.03;
		if(bounce_timer <= 0.0):
			bounce_timer = 0
		
	#if you pressed jump soon after bouncing off bubble
	if(Input.is_action_just_pressed("platform_jump") and bounce_timer > 0.0):
		is_jumping = true

	# If you release jump, set jumping to false.
	if(Input.is_action_just_released("platform_jump")):
		is_jumping = false
	
	# If you start pressing jump and you're on the floor, start the jump with starting velocity
	if Input.is_action_just_pressed("platform_jump") and is_on_floor():
		is_jumping = true;
		velocity.y = jump_velocity
		
	#otherwise if you're already jumping, increase velocity if you keep holding jump up to a maximum velocity
	elif is_jumping and Input.is_action_pressed("platform_jump") and jump_velocity > -450:
		jump_velocity *= 1.01;
		velocity.y = jump_velocity
	
		
	#otherwise reset the velocity
	elif !Input.is_action_pressed("platform_jump") and is_on_floor():
		jump_velocity = JUMP_DEFAULT
		
	#make falling a bit faster than jumping
	if velocity.y > 0:
		velocity.y *= 1.01
		
	aim_dir = Input.get_vector("platform_left", "platform_right", "platform_up", "platform_down")
		
	if Input.is_action_just_released("platform_aim") or (is_aiming and aim_dir == Vector2()):
		is_aiming = false
		wind.hide()
		wind.gravity_direction = Vector2(0,0)
	
	# Aiming
	if Input.is_action_pressed("platform_aim"):
		
		if aim_dir != Vector2():
				wind.show()
				is_aiming = true
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
	
	#collide with bubble and bounce accordinlgyd
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is Bubble:
			collision.get_collider().pop()
			if(position.y < collision.get_collider().position.y):
				bounce_timer = .8;
				jump_velocity = JUMP_DEFAULT;
				velocity.y = jump_velocity;
