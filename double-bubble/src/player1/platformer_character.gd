extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0
signal bubble_touched
signal fan_shot
var is_aiming = false
var aim_dir = Vector2()

var wind : Node2D
var wind_area

func _ready():
	wind = Node2D.new()
	call_deferred("add_sibling", wind)
	wind.position = position
	wind_area = load("res://src/wind_area.tscn").instantiate()
	wind.add_child(wind_area)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("platform_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("platform_aim"):
		is_aiming = true
		wind_area.show()
		
	if Input.is_action_just_released("platform_aim"):
		is_aiming = false
		wind_area.hide()
		#fan()
		
	if is_aiming:
		aim_dir = Input.get_vector("platform_left", "platform_right", "platform_up", "platform_down")
		print(aim_dir.angle())
		wind.position = position
		wind.rotation_degrees = rad_to_deg(aim_dir.angle())
		if is_on_floor():
			velocity = Vector2()

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

#func fan():
	#fan_shot.emit(self.position, aim_dir)
