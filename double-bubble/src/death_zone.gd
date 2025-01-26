extends Area2D

var spawn_point
var bubble_girl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp = get_parent().find_children("SpawnPoint")
	if (temp != null):
		spawn_point = temp[0]
		
	bubble_girl = get_parent().find_child("Bubble Character")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is PlatformerCharacter:
		if (spawn_point == null):
			return
			
		body.position = spawn_point.position
		body.velocity = Vector2()
		
		bubble_girl.linear_velocity = Vector2()
		bubble_girl.set_pos(spawn_point.position + Vector2(100,-100))
			
		var bubbles = get_parent().find_children("B?")
		print(bubbles)
		
		for b in bubbles:
			b.pop()
			
		
		
