extends GridContainer


signal item_switched(flag)	# Flag: 0 if the Player Item should be updated
							# Flag: 1 if the Building Object should be updated

onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")
onready var tileMap = get_node("/root/Main/Dirt")
onready var allInventories = Inventories.allInventories
onready var inventory

var currentlySelected = 1

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
	if inventory == allInventories[1]:
		get_child(currentlySelected).select()
	inventory.add(preload("res://Items/Forge.tres"))
	inventory.connect("items_changed", self, "_on_items_changed")
	inventory.emit_signal("items_changed", 0, 0)
	inventory.emit_signal("items_changed", 1, 0)
	for x in get_children():
		x.connect("slot_updated", self, "_on_slot_updated")
	
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
	
"""Update Slots when a new Slot is selected"""
func _input(event):
	if event.is_action_pressed("scroll_up"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected - 1 < 0):
			currentlySelected -= 1
		else:
			currentlySelected = inventory.size - 1
		if get_child(currentlySelected).inventory == allInventories[1]:
			get_child(currentlySelected).select()
		emit_signal("item_switched", 1)
	if event.is_action_pressed("scroll_down"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected + 1 > inventory.size - 1):
			currentlySelected += 1
		else:
			currentlySelected = 0
		if get_child(currentlySelected).inventory == allInventories[1]:
			get_child(currentlySelected).select()
		emit_signal("item_switched", 1)
	
"""For updating the Player Item
When an Item is placed in an already selected Slot"""
func _on_slot_updated(index):
	get_child(index).select()
	emit_signal("item_switched", 0)
