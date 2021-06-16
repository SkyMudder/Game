extends "res://Inventory/InventoryDisplayMaster.gd"


signal queue_updated(index, flag)

onready var InventorySlotDisplay = preload("res://Inventory/InventorySlotDisplay.tscn")
onready var localFurnaceInventoriesIndex = Inventories.newFurnaceInventory()
onready var sourceInventory = Inventories.furnaceInventories[localFurnaceInventoriesIndex]
onready var productInventory = Inventories.furnaceInventories[localFurnaceInventoriesIndex + 1]
onready var sourceContainer = get_node("FurnaceHBoxContainer/InventoryVBoxContainer/SourceHBoxContainer")
onready var productContainer = get_node("FurnaceHBoxContainer/InventoryVBoxContainer/ProductHBoxContainer")
onready var furnace = get_parent()
onready var fuelLabel = get_node("FurnaceHBoxContainer/InventoryVBoxContainer/FuelHBoxContainer/Fuel")

"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _ready():
	tileMap.connect("stopped_placing", self, "_on_stopped_placing")
	
"""When Item changes, update the Inventory Slot Display"""
func _on_items_changed(inventoryChanged, index):
	if inventoryChanged == sourceInventory.id:
		updateInventorySlotDisplay(self, sourceInventory, inventoryChanged, index)
		if Inventories.getInventoryByID(inventoryChanged).items[index] != null:
			emit_signal("queue_updated", index, 0)
		else:
			emit_signal("queue_updated", index, 1)
	elif inventoryChanged == productInventory.id:
		updateInventorySlotDisplay(self, productInventory, inventoryChanged, index)
		if Inventories.getInventoryByID(inventoryChanged).items[index] != null:
			emit_signal("queue_updated", index, 0)
		else:
			emit_signal("queue_updated", index, 1)
	
func addInventorySlotsFurnace(targetInventory, targetContainer, amount):
	for _x in range(amount):
		var slot = InventorySlotDisplay.instance()
		targetContainer.add_child(slot)
	targetInventory.setInventorySize(targetInventory.size)
	
func getSlot(index, inventoryChanged):
	print("1")
	if inventoryChanged == sourceInventory.id:
		return sourceContainer.get_child(index)
	elif inventoryChanged == productInventory.id:
		return productContainer.get_child(index)
	
"""Adds the given Amount of Inventory Slots to the UI
Connects Signal for when Items changed
Updates the Inventory on the UI"""
func _on_stopped_placing(placed):
	if placed:
		print(sourceContainer)
		print(productContainer)
		addInventorySlotsFurnace(sourceInventory, sourceContainer, sourceInventory.size)
		addInventorySlotsFurnace(productInventory, productContainer, productInventory.size)
		columns = sourceInventory.columns
		for x in sourceContainer.get_children():
			x.inventory = sourceInventory
		for x in productContainer.get_children():
			x.inventory = productInventory
		updateInventoryDisplay(self, sourceInventory, sourceInventory.id)
		updateInventoryDisplay(self, productInventory, productInventory.id)
		sourceInventory.connect("items_changed", self, "_on_items_changed")
		productInventory.connect("items_changed", self, "_on_items_changed")
	tileMap.disconnect("stopped_placing", self, "_on_stopped_placing")
