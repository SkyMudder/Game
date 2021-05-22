extends Node2D


onready var player = get_node("KinematicBody2D")
onready var tileMapFloor = get_node("Floor")

var root = Vector2.ZERO

func _ready():
	pass
	
func _on_KinematicBody2D_on_player_moved():
	checkRemoveChunk()
	checkGenerateChunk()
	
		
func checkGenerateChunk():
	for x in WorldVariables.getNextToGenerate():
		if player.isCloseToChunk(x) and !WorldVariables.getGeneratedChunks().has(x):
			tileMapFloor.generateChunk(x)

func checkRemoveChunk():
	for x in WorldVariables.getGeneratedChunks():
		if player.isFarFromChunk(x):
			tileMapFloor.removeChunk(x)
