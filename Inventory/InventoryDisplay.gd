extends GridContainer

onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")

onready var allInventories = Inventories.allInventories
onready var inventory

var currentlySelected = 0

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	inventory = Inventories.getInventory()
	inventory.allInventories = allInventories
	addInventorySlots(inventory.size)
	columns = inventory.columns
	for x in get_children():
		x.inventory = inventory
	updateInventoryDisplay(inventory.id)
	inventory.connect("items_changed", self, "_on_items_changed")
	
"""Goes through the whole Inventory and updates the Slots"""
func updateInventoryDisplay(inventoryChanged):
	for itemIndex in allInventories[inventoryChanged].items.size():
		updateInventorySlotDisplay(inventoryChanged, itemIndex)
	
"""Updayes an Inventory Slot at a given Index"""
func updateInventorySlotDisplay(inventoryChanged, itemIndex):
	var inventorySlotDisplay = get_child(itemIndex)
	var item = allInventories[inventoryChanged].items[itemIndex]
	inventorySlotDisplay.displayItem(inventoryChanged, item)
	
"""When Item changes, update the Inventory Slot Display"""
func _on_items_changed(inventoryChanged, index):
	if inventoryChanged == inventory.id:
		updateInventorySlotDisplay(inventoryChanged, index)
	
"""Create Inventory with a given Amount of Slots"""
func addInventorySlots(amount):
	for _x in range(amount):
		var slot = InventorySlotDisplay.instance()
		add_child(slot)
	inventory.setInventorySize(inventory.size)
	
func _input(_event):
	if Input.is_action_just_pressed("scroll_up"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected + 1 > inventory.size - 1):
			currentlySelected += 1
		else:
			currentlySelected = 0
		if get_child(currentlySelected).inventory == allInventories[1]:
			get_child(currentlySelected).select()
	if Input.is_action_just_pressed("scroll_down"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected - 1 < 0):
			currentlySelected -= 1
		else:
			currentlySelected = inventory.size - 1
		if get_child(currentlySelected).inventory == allInventories[1]:
			get_child(currentlySelected).select()
