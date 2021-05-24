extends Node2D


onready var player = get_node("KinematicBody2D")	# Player
onready var tileMapGrass = get_node("Grass")		# Grass TileMap

var root = WorldVariables.getRoot()	# World root

func _ready():
	pass
	
"""Gets called every time the Player moves"""
func _on_KinematicBody2D_on_player_moved():
	var start = OS.get_ticks_msec()
	checkRemoveChunk()
	checkGenerateChunk()
	var end = OS.get_ticks_msec()
	print(end - start)
	
"""Checks if a Chunk should be generated
Based on how close the Player is to it
and if it is not already generated"""
func checkGenerateChunk():
	for x in WorldVariables.getNextToGenerate():
		if player.isCloseToChunk(x) and !WorldVariables.getGeneratedChunks().has(x):
			tileMapGrass.generateChunk(x)
	
"""Checks if a Chunk should be removed
Based on how far the Player is from it"""
func checkRemoveChunk():
	for x in WorldVariables.getGeneratedChunks():
		if player.isFarFromChunk(x):
			tileMapGrass.removeChunk(x)
