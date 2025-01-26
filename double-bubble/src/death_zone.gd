extends Area2D

var spawn_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp = get_parent().find_children("SpawnPoint")
	if (temp != null):
		spawn_point = temp[0]
		print(spawn_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is PlatformerCharacter:
		if (spawn_point != null):
			body.position = spawn_point.position
			body.velocity = Vector2()
		
		
