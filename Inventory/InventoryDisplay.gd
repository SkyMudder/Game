extends "res://Inventory/InventoryDisplayMaster.gd"


onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")
onready var inventory = Inventories.playerInventory
var currentlySelected = 2

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
	inventory.add(preload("res://Items/Furnace.tres"))
	inventory.connect("items_changed", self, "_on_items_changed")
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
	
func getSlot(index, _inventoryChanged):
	return get_child(index)
