extends Node

onready var InventorySlot = load("res://Inventory/InventorySlot.gd")

var inventorySlots = []

func add(resourceType, resourceAmount):
	for x in inventorySlots:
		if resourceType == x.getResourceType():
			x.setResourceAmount(resourceAmount)
			return
	var inventorySlot = InventorySlot.new(resourceType, resourceAmount)
	inventorySlots.push_back(inventorySlot)
