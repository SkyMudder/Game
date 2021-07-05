extends Node2D


onready var player = get_node("KinematicBody2D")
onready var groundLayer = get_node("GroundLayer")
onready var mousePointer = preload("res://Sprites/MousePointer.png")
onready var inventoryTabs = get_node("InventoryWrapper/InventoryTabs")
onready var camera = get_node("KinematicBody2D/Camera2D")

var root = WorldVariables.getRoot()

"""Changes how the Mouse Pointer looks"""
func _ready():
	Input.set_custom_mouse_cursor(mousePointer)

"""Checks if a Chunk should be generated
Based on how close the Player is to it
and if it is not already generated"""
func checkGenerateChunk():
	for x in WorldVariables.getNextToGenerate():
		if player.isCloseToChunk(x) and !WorldVariables.getGeneratedChunks().has(x):
			groundLayer.generateChunk(x)
	
"""Checks if a Chunk should be removed
Based on how far the Player is from it"""
func checkRemoveChunk():
	for x in WorldVariables.getGeneratedChunks():
		if player.isFarFromChunk(x):
			groundLayer.removeChunk(x)
	
func _input(_event):
	if Input.is_action_pressed("ui_focus_next"):
		States.inventoryOpen = true
		inventoryTabs.show()
	else:
		States.inventoryOpen = false
		inventoryTabs.hide()
	if Input.is_action_pressed("ctrl"):
		States.zooming = true
		if Input.is_action_pressed("scroll_up"):
			zoomIn()
		elif Input.is_action_pressed("scroll_down"):
			zoomOut()
	if Input.is_action_just_released("ctrl"):
		States.zooming = false
	
func zoomIn():
	if !camera.zoom <= Vector2(0.2, 0.2):
		camera.zoom -= Vector2(0.1, 0.1)
	
func zoomOut():
	if !camera.zoom >= Vector2(0.5, 0.5):
		camera.zoom += Vector2(0.1, 0.1)
	
"""Gets called every time the Player moves"""
func _on_KinematicBody2D_on_player_moved():
	checkGenerateChunk()
	checkRemoveChunk()
