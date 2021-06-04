extends GridContainer


onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")

var inventory = Inventories.playerInventory
var allInventories = Inventories.allInventories

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	addInventorySlots(inventory.size)
	columns = inventory.columns
	for x in get_children():
		x.inventory = inventory
	updateInventoryDisplay(inventory.id)
	inventory.connect("items_changed", self, "_on_items_changed")
	
"""Goes through the whole Inventory and updates the Slots"""
func updateInventoryDisplay(inventory):
	for itemIndex in allInventories[inventory].items.size():
		updateInventorySlotDisplay(inventory, itemIndex)
	
"""Updayes an Inventory Slot at a given Index"""
func updateInventorySlotDisplay(inventory, itemIndex):
	var inventorySlotDisplay = get_child(itemIndex)
	var item = allInventories[inventory].items[itemIndex]
	inventorySlotDisplay.displayItem(inventory, item)
	
"""When Item changes, update the Inventory Slot Display"""
func _on_items_changed(inventories, indexes):
	print("INVENTORY")
	print(inventory.items)
	for currentInventory in inventories:
		for itemIndex in indexes:
			updateInventorySlotDisplay(currentInventory, itemIndex)
	
"""Create Inventory with a given Amount of Slots"""
func addInventorySlots(amount):
	for _x in range(amount):
		var slot = InventorySlotDisplay.instance()
		add_child(slot)
	inventory.setInventorySize(inventory.size)
