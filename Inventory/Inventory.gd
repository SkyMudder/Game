extends Node

onready var InventorySlot = load("res://Inventory/InventorySlot.gd")

var inventorySlots = []

"""Adds new Resources to the Inventory"""
func add(resourceType, resourceAmount):
	for x in inventorySlots:	# Make a new Slot if Resource is not already in the Inventory
		if resourceType == x.getResourceType():
			x.setResourceAmount(resourceAmount)
			return
	var inventorySlot = InventorySlot.new(resourceType, resourceAmount)
	inventorySlots.push_back(inventorySlot)
	
func swap(itemIndex, targetItemIndex):
	var tmp = inventorySlots[targetItemIndex]
	inventorySlots[targetItemIndex] = inventorySlots[itemIndex]
	inventorySlots[itemIndex] = tmp
