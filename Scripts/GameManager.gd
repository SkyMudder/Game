extends Node2D


onready var player = get_node("KinematicBody2D")	# Player
onready var tileMapFloor = get_node("Floor")		# Floor TileMap

var root = WorldVariables.getRoot()	# World root

func _ready():
	pass
	
"""Gets called every time the Player moves"""
func _on_KinematicBody2D_on_player_moved():
	checkRemoveChunk()
	checkGenerateChunk()
	
"""Checks if a Chunk should be generated
Based on how close the Player is to it
and if it is not already generated"""
func checkGenerateChunk():
	for x in WorldVariables.getNextToGenerate():
		if player.isCloseToChunk(x) and !WorldVariables.getGeneratedChunks().has(x):
			tileMapFloor.generateChunk(x)
	
"""Checks if a Chunk should be removed
Based on how far the Player is from it"""
func checkRemoveChunk():
	for x in WorldVariables.getGeneratedChunks():
		if player.isFarFromChunk(x):
			tileMapFloor.removeChunk(x)
