extends Node2D
@onready var platformer = get_node("Platformer")
@onready var bubble_pop_timer = get_node("BubblePopTimer")

var bubble_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	platformer.bubble_touched.connect(_on_platformer_bubble_touched)
	platformer.fan_shot.connect(_on_platformer_fan_shot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_platformer_bubble_touched(collider):
		if(bubble_pop_timer.time_left == 0):
			bubble_pop_timer.start()
			if(!bubble_queue.has(collider)):
				bubble_queue.append(collider)

func _on_platformer_fan_shot(position):
	var wind_vec = Vector2(1, 0)
	var wind = load("res://src/wind.tscn").instantiate()
	add_child(wind)
	wind.global_position = position
	wind.linear_velocity = wind_vec * 300
 
func _on_bubble_pop_timer_timeout() -> void:
	var bubble_to_remove = bubble_queue.pop_front()
	if bubble_to_remove:
		remove_child(bubble_to_remove)
