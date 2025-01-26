extends RigidBody2D
class_name Bubble

var is_popped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	BubbleCharacter.hovered_bubble = self


func _on_mouse_exited() -> void:
	BubbleCharacter.hovered_bubble = null


func pop() -> bool:	
	if is_popped:
		return false
	
	is_popped = true
	# add animation data & sound effect later
	collision_layer = 0
	collision_mask = 0
	BubbleCharacter.hovered_bubble = null
	BubbleCharacter.current_bubbles -= 1
	queue_free()
	
	return true
