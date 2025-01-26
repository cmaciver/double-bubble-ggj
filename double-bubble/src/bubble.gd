extends RigidBody2D
class_name Bubble

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
	# add animation data & sound effect later
	collision_layer = 0
	BubbleCharacter.current_bubbles -= 1
	BubbleCharacter.hovered_bubble = null
	queue_free()
	
	return true
