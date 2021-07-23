extends KinematicBody2D

onready var inventory : Inventory = Inventories.playerInventory
onready var toolbar : Inventory = Inventories.toolbar

var velocity : = Vector2.ZERO	# Player Velocity

const MAX_SPEED : int = 1000
const ACCELERATION : int = 500
const FRICTION : int = 500

signal on_player_moved	# Signal used to notify other Nodes of a Player Movement

"""Gets User Input to determine Player Movement and collide with Objects
Emits a Signal every time the Player moves"""
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta * 10)
		
	velocity = move_and_slide(velocity)
	emit_signal("on_player_moved")
	
"""Checks if the Player is close to a Chunk
Close is defined by the Render Distance"""
func isCloseToChunk(chunk) -> bool:
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) < WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
	
"""Checks if the Player is far from a Chunk
Far is defined by the Render Distance"""
func isFarFromChunk(chunk) -> bool:
	if self.position.distance_to(chunk * WorldVariables.getChunkSizePixels()) > WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels():
		return true
	else:
		return false
	
"""Checks if the Player is far from an Object
Far is defined by the Render Distance"""
func isFarFromObject(pos) -> bool:
	if self.position.distance_to(pos) > WorldVariables.getRenderDistance() * WorldVariables.getChunkSizePixels() + 150:
		return true
	else:
		return false
