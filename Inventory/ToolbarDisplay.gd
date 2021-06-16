extends "res://Inventory/InventoryDisplayMaster.gd"


signal item_switched(flag)	# Flag: 0 if the Player Item should be updated
							# Flag: 1 if the Building Object should be updated

onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")
onready var inventory = Inventories.toolbar

var currentlySelected = 9

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	inventory.playerInventories = Inventories.playerInventories
	addInventorySlots(self, inventory.size)
	columns = inventory.columns
	for x in get_children():
		x.inventory = inventory
	updateInventoryDisplay(self, inventory, inventory.id)
	if inventory == playerInventories[1]:
		get_child(currentlySelected).select()
	inventory.connect("items_changed", self, "_on_items_changed")
	for x in get_children():
		x.connect("slot_updated", self, "_on_slot_updated")
	for _x in range(7):
		inventory.add(preload("res://Items/Furnace.tres"))
	inventory.emit_signal("items_changed", 0, 0)
	inventory.emit_signal("items_changed", 1, 0)
	for _x in range(50):
		inventory.add(preload("res://Items/Copper.tres"))
	inventory.emit_signal("items_changed", 0, 0)
	inventory.emit_signal("items_changed", 1, 0)
	for _x in range(50):
		inventory.add(preload("res://Items/Wood.tres"))
	inventory.emit_signal("items_changed", 0, 0)
	inventory.emit_signal("items_changed", 1, 0)
	
"""When Item changes, update the Inventory Slot Display"""
func _on_items_changed(inventoryChanged, index):
	if inventoryChanged == inventory.id:
		updateInventorySlotDisplay(self, inventory, inventoryChanged, index)
	
"""Update Slots when a new Slot is selected"""
func _input(event):
	if event.is_action_pressed("scroll_up"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected - 1 < 0):
			currentlySelected -= 1
		else:
			currentlySelected = inventory.size - 1
		if get_child(currentlySelected).inventory == playerInventories[1]:
			get_child(currentlySelected).select()
	if event.is_action_pressed("scroll_down"):
		get_child(currentlySelected).deselect()
		if !(currentlySelected + 1 > inventory.size - 1):
			currentlySelected += 1
		else:
			currentlySelected = 0
		if get_child(currentlySelected).inventory == playerInventories[1]:
			get_child(currentlySelected).select()
	
"""For updating the Player Item
When an Item is placed in an already selected Slot"""
func _on_slot_updated(index):
	get_child(index).select()
	emit_signal("item_switched", 0)
	
func getSlot(index, _inventoryChanged):
	return get_child(index)
