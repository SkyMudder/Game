extends GridContainer


onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")
var player = load("res://Scripts/Player.gd")

var inventory = preload("res://Inventory/Inventory.tres")

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	addInventorySlots(player.inventorySize)
	inventory.setInventorySize(player.inventorySize)
	updateInventoryDisplay()
	inventory.connect("items_changed", self, "_on_items_changed")
	
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
	
"""Create Inventory with a given Amount of Slots"""
func addInventorySlots(amount):
	for _x in range(amount):
		var slot = InventorySlotDisplay.instance()
		add_child(slot)
