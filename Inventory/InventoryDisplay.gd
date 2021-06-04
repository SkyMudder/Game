extends GridContainer


onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")

var inventory = Inventories.playerInventory

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	addInventorySlots(inventory.size)
	columns = inventory.columns
	for x in get_children():
		x.inventory = inventory
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
	print("INVENTORY")
	print(inventory.items)
	for itemIndex in indexes:
		updateInventorySlotDisplay(itemIndex)
	
"""Create Inventory with a given Amount of Slots"""
func addInventorySlots(amount):
	for _x in range(amount):
		var slot = InventorySlotDisplay.instance()
		add_child(slot)
	inventory.setInventorySize(inventory.size)
