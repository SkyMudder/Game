extends StaticBody2D


onready var inventory : Inventory = Inventories.playerInventory
onready var player = get_node("/root/Main/KinematicBody2D")

"""Adds the Item to the Player Inventory and removes it from the World"""
func addToInventory(object) -> void:
	if object.exists and pickable(object):
			object.item.amount = object.amount
			object.inventory.add(object.item)
			object.exists = false
			object.queue_free()
	
"""Checks if an Item can be picked up"""
func pickable(object) -> bool:
	if object.global_position.distance_to(player.global_position) < WorldVariables.pickupRange:
		return true
	return false
