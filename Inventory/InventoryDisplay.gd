extends GridContainer


var inventory = preload("res://Inventory/Inventory.tres")

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	updateInventoryDisplay()
	
"""Goes through the whole Inventory and updates the Slots"""
func updateInventoryDisplay():
	for itemIndex in inventory.items.size():
		updateInventorySlotDisplay(itemIndex)
	
"""Updayes an Inventory Slot at a given Index"""
func updateInventorySlotDisplay(itemIndex):
	var inventorySlotDisplay = get_child(itemIndex)
	var item = inventory.items[itemIndex]
	inventorySlotDisplay.displayItem(item)
	
"""When Item changes, update the Inventory Slot Display"""
func _on_items_changed(indexes):
	for itemIndex in indexes:
		updateInventorySlotDisplay(itemIndex)
