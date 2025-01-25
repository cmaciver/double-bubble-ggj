extends RigidBody2D

const SPEED = 300.0
@onready var SCAN_WIDTH = 10


@onready var center_ray = $RayCast2DCenter
@onready var left_ray = $RayCast2DLeft
@onready var right_ray = $RayCast2DRight

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:		
	if Input.is_action_pressed("l_click"):
		center_ray.target_position = get_global_mouse_position() - position
		var norm = center_ray.target_position.normalized()
		var mag = center_ray.target_position.length()
		
		left_ray.target_position = norm.rotated(deg_to_rad(-SCAN_WIDTH)) * mag
		right_ray.target_position = norm.rotated(deg_to_rad(SCAN_WIDTH)) * mag
		
		var cool_ray = Vector2(0,0)
		if center_ray.is_colliding():
			cool_ray = center_ray.target_position
		elif left_ray.is_colliding():
			cool_ray = left_ray.target_position
		elif right_ray.is_colliding():
			cool_ray = right_ray.target_position
			
		apply_force(cool_ray.normalized() * 500) # make this scale on distance
			
		
		
	if Input.is_action_just_pressed("r_click"):
		#update_mouse()
		pass
		
