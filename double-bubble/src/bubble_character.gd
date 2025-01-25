extends RigidBody2D
class_name BubbleCharacter

@export var max_bubbles = 3
@export var current_bubbles = 0
var bubble_scene = preload("res://src/bubble.tscn")

static var hovered_bubble = null

@export var SCAN_WIDTH = 10 # in degrees
@onready var center_ray = $RayCast2DCenter
@onready var left_ray = $RayCast2DLeft
@onready var right_ray = $RayCast2DRight

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_action_just_pressed("l_click"):
		if (hovered_bubble != null): # a bubble was clicked, pop it
			pass
		else:
			spawn_bubble()
			
		
		
	if Input.is_action_just_pressed("r_click"):
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
		
func spawn_bubble():
	if (current_bubbles + 1 > max_bubbles):
		# maybe do a sound effect later?
		return
		
	var new_bubble : Bubble = bubble_scene.instantiate()
	current_bubbles += 1
	call_deferred("add_sibling", new_bubble)
	var dir = get_global_mouse_position() - position
	new_bubble.position = position + dir.normalized() * 100
	new_bubble.apply_force(dir * 10)
	
