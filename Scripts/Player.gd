extends KinematicBody2D


var velocity = Vector2.ZERO	# Player Velocity

signal on_player_moved	# Signal used to notify other Nodes of a Player Movement

"""Gets User Input to determine Player Movement and collide with Objects
Emits a Signal every time the Player moves"""
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * 2
	else:
		velocity = Vector2.ZERO 

	move_and_collide(velocity)
	emit_signal("on_player_moved")

"""Checks if the Player is close to a Chunk
Close is defined by the Render Distance"""
func isCloseToChunk(chunk):
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) < WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
	
"""Checks if a Player is far from a Chunk
Far is defined by the Render Distance"""
func isFarFromChunk(chunk):
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) > WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
