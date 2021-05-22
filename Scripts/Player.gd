extends KinematicBody2D



var velocity = Vector2.ZERO

signal on_player_moved

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * 2
	else:
		velocity = Vector2.ZERO
		print(WorldVariables.getGeneratedChunks().size())
		print(WorldVariables.getNextToGenerate().size())

	move_and_collide(velocity)
	emit_signal("on_player_moved")
	WorldVariables.updateNextToGenerate()

func isCloseToChunk(chunk):
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) < WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
		
func isFarFromChunk(chunk):
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) > WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
