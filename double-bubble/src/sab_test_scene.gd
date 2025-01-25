extends Node2D
@onready var platformer = get_node("Platformer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	platformer.bubble_touched.connect(_on_platformer_bubble_touched)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_platformer_bubble_touched(collider):
	remove_child(collider)
