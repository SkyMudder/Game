extends Resource
class_name Inventory


signal items_changed(inventoryChanged, indexes)

var items = []
	
var allInventories
	
var id
var size
var columns
	
var scheduledRemovalInventories = []
var scheduledRemovalIndexes = []
var scheduledRemovalAmounts = []
	
func _init(inventoryId, inventorySize, inventoryColumns):
	id = inventoryId
	size = inventorySize
	columns = inventoryColumns
	
"""Automatically determines where to add an Item to the Inventory and adds it"""
func add(item):
	for x in range(items.size()):
		if items[x] != null:
			if items[x].name == item.name and items[x].amount < item.stackLimit:
				items[x].amount += 1
				emit_signal("items_changed", id, [x])
				return
	for x in range(items.size()):
		if items[x] == null:
			set(item.duplicate(), x)
			items[x].amount = 0
			items[x].amount += 1
			emit_signal("items_changed", id, [x])
			return
	
"""Seeks a specific Amount of an Item in the Inventory
If there is not enough in one Stack it searches in another Stack
Schedules the previous Stack for Removal by adding it to an Array
with the respective Amount that might be removed in another Array
But doesn't remove it directly
Because more Items might not be found
Returns True if enough Items have been found, False if not"""
func seek(item, amount):
	var amountTaken = 0
	var need = amount - amountTaken
	for inventoryChanged in allInventories:
		var x = inventoryChanged.items.size() - 1
		while x >= 0:
			if inventoryChanged.items[x] != null and need:
				if inventoryChanged.items[x].name == item.name:
					if inventoryChanged.items[x].amount >= need:
						scheduledRemovalInventories.push_back(allInventories.find(inventoryChanged))
						scheduledRemovalIndexes.push_back(x)
						scheduledRemovalAmounts.push_back(need)
						amountTaken += need
						return true
					else:
						var available = inventoryChanged.items[x].amount
						scheduledRemovalInventories.push_back(allInventories.find(inventoryChanged))
						scheduledRemovalIndexes.push_back(x)
						scheduledRemovalAmounts.push_back(available)
						amountTaken += available
			if amountTaken == amount:
				return true
			x -= 1
	return false

func set(item, itemIndex):
	var previousItem = items[itemIndex]
	items[itemIndex] = item
	emit_signal("items_changed", id, [itemIndex])
	return previousItem
	
func swap(sourceInventory, targetInventory, itemIndex, targetItemIndex):
	var tmp = allInventories[targetInventory].items[targetItemIndex]
	allInventories[targetInventory].items[targetItemIndex] = allInventories[sourceInventory].items[itemIndex]
	allInventories[sourceInventory].items[itemIndex] = tmp
	emit_signal("items_changed", sourceInventory, [itemIndex])
	emit_signal("items_changed", targetInventory, [targetItemIndex])
	
func remove(itemIndex):
	var previousItem = items[itemIndex]
	items[itemIndex] = null
	emit_signal("items_changed", id, [itemIndex])
	return previousItem
	
"""Removes scheduled Items from the Inventory
Clears the Arrays after the Action is complete"""
func removeScheduled():
	for x in range(scheduledRemovalIndexes.size()):
		allInventories[scheduledRemovalInventories[x]].items[scheduledRemovalIndexes[x]].amount -= scheduledRemovalAmounts[x]
	for x in range(scheduledRemovalInventories.size()):
		allInventories[scheduledRemovalInventories[x]].emit_signal("items_changed", scheduledRemovalInventories[x], [scheduledRemovalIndexes[x]])
	scheduledRemovalIndexes.clear()
	scheduledRemovalAmounts.clear()
	
func setInventorySize(inventorySize):
	for _x in range(inventorySize):
		items.push_back(null)
