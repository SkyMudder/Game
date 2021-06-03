extends Node2D


onready var player = get_node("KinematicBody2D")
onready var tileMapGrass = get_node("Grass")
onready var mousePointer = preload("res://Sprites/MousePointer.png")
onready var inventory = get_node("KinematicBody2D/InventoryWrapper/InventoryTabs")

var root = WorldVariables.getRoot()
	
"""Changes how the Mouse Pointer looks"""
func _ready():
	Input.set_custom_mouse_cursor(mousePointer)
	
func _input(_event):
	if Input.is_action_pressed("ui_focus_next"):
		inventory.show()
	else:
		inventory.hide()
	
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
			tileMapGrass.generateChunk(x)
	
"""Checks if a Chunk should be removed
Based on how far the Player is from it"""
func checkRemoveChunk():
	for x in WorldVariables.getGeneratedChunks():
		if player.isFarFromChunk(x):
			tileMapGrass.removeChunk(x)


func _on_InventoryTabs_renamed():
	pass # Replace with function body.
