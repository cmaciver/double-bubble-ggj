extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0
signal bubble_touched
signal fan_shot
var is_aiming = false
var aim_dir = Vector2()

@onready var aim_display = $AimDisplay

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("platform_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("platform_aim"):
		is_aiming = true
		aim_display.show()
		velocity = Vector2()
		
	if Input.is_action_just_released("platform_aim"):
		is_aiming = false
		aim_display.hide()
		fan()
		
	if is_aiming:
		aim_dir = Input.get_vector("platform_left", "platform_right", "platform_up", "platform_down")
		print(aim_dir.angle())
		aim_display.rotation_degrees = rad_to_deg(aim_dir.angle())
		


	if(!is_aiming):
		var direction := Input.get_axis("platform_left", "platform_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Bubble":
			bubble_touched.emit(collision.get_collider())

func fan():
	fan_shot.emit(self.position, aim_dir)
