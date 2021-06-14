extends GridContainer


onready var playerInventories = Inventories.playerInventories
onready var furnaceInventories = Inventories.furnaceInventories
onready var tileMap = get_node("/root/Main/Dirt")
	
"""Goes through the whole Inventory and updates the Slots"""
func updateInventoryDisplay(object, inventory, inventoryChanged):
	for itemIndex in inventory.items.size():
		object.updateInventorySlotDisplay(object, inventory, inventoryChanged, itemIndex)
	
"""Updates an Inventory Slot at a given Index"""
func updateInventorySlotDisplay(object, inventory, inventoryChanged, itemIndex):
	var inventorySlotDisplay = object.getSlot(itemIndex, inventoryChanged)
	var item = inventory.items[itemIndex]
	inventorySlotDisplay.displayItem(inventory, item)
	
"""Create Inventory with a given Amount of Slots"""
func addInventorySlots(object, amount):
	for _x in range(amount):
		var slot = object.InventorySlotDisplay.instance()
		object.add_child(slot)
	object.inventory.setInventorySize(object.inventory.size)
	
"""Load Inventory with a given Amount of Slots"""
func loadInventorySlots(object, amount):
	for _x in range(amount):
		var slot = object.InventorySlotDisplay.instance()
		object.add_child(slot)
	for x in range(amount):
		if object.inventory.items[x] != null:
			object.get_child(x).textureRect.texture = object.inventory.items[x].texture
			object.get_child(x).itemAmount.text = str(object.inventory.items[x].amount)
