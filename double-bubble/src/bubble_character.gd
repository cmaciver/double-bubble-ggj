extends Bubble
class_name BubbleCharacter

@export var max_bubbles = 3
static var current_bubbles = 0
var bubble_scene = preload("res://src/bubble.tscn")

static var hovered_bubble = null

@export var SCAN_WIDTH = 10 # in degrees
@onready var center_ray = $RayCast2DCenter
@onready var left_ray = $RayCast2DLeft
@onready var right_ray = $RayCast2DRight
@onready var pop_player = $BubblePop

@export var MAX_SPEED = 2200
@export var MAX_SPEED_UNTETHERED = 50

var popped = false

var setting_pos = false
var new_pos: Vector2

func set_pos(pos):
	setting_pos = true
	new_pos = pos
	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if setting_pos:
		setting_pos = false
		position = new_pos
		return
	
	if Input.is_action_just_pressed("l_click"):
		if (hovered_bubble != null): # a bubble was clicked, pop it
			hovered_bubble.pop()
		else:
			spawn_bubble()
		
	#print("yar")
	if Input.is_action_pressed("r_click"):
		#print("har")
		attract_towards_stuff()


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
	
	


func attract_towards_stuff():
	center_ray.target_position = get_global_mouse_position() - position
	var norm = center_ray.target_position.normalized()
	var mag = center_ray.target_position.length()
	
	left_ray.target_position = norm.rotated(deg_to_rad(-SCAN_WIDTH)) * mag
	right_ray.target_position = norm.rotated(deg_to_rad(SCAN_WIDTH)) * mag
	
	var cool_ray = center_ray.target_position.normalized() / 99999999999 / 99999999999 
	
	var tethered = false
	if center_ray.is_colliding():
		cool_ray = center_ray.target_position
		tethered = true
	elif left_ray.is_colliding():
		cool_ray = left_ray.target_position
		tethered = true
	elif right_ray.is_colliding():
		cool_ray = right_ray.target_position
		tethered = true
		
		
	apply_force(cool_ray.normalized() * 5000) # make this scale on distance
	
	if tethered and linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
		
	if not tethered and linear_velocity.length() > MAX_SPEED_UNTETHERED:
		var vel_cap = linear_velocity.normalized() * MAX_SPEED_UNTETHERED
		var weight = 0.9
		linear_velocity = vel_cap *(1-weight) + linear_velocity *(weight)


func pop() -> bool:
	if popped == true: # doesn't actually pop if not refresh
		return false
	pop_player.show()
	pop_player.play("pop")
	animation_player.play("no_bubble")
	popped = true
	$RefreshTimer.start(3)
	collision_layer = 0
	collision_mask = 4
	await pop_player.animation_finished
	modulate = "#FFFFFF40"
	pop_player.hide()
	
	return true


func _on_timer_timeout() -> void:
	modulate = "#FFFFFFFF"
	pop_player.show()
	pop_player.play("unpop")
	await pop_player.animation_finished
	animation_player.play("default")
	pop_player.hide()
	popped = false
	
	collision_layer = 2 + 1
	collision_mask = 1 + 2 + 4
