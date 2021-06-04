extends Resource
class_name Inventory


signal items_changed(indexes)

export(Array, Resource) var items = []
const stackLimit : int = 5
	
var scheduledRemovalIndexes = []
var scheduledRemovalAmounts = []
	
"""Automatically determines where to add an Item to the Inventory and adds it"""
func add(item):
	for x in range(items.size()):
		if items[x] != null:
			if items[x].name == item.name and items[x].amount < stackLimit:
				items[x].amount += 1
				emit_signal("items_changed", [x])
				return
	for x in range(items.size()):
		if items[x] == null:
			set(item.duplicate(), x)
			items[x].amount = 0
			items[x].amount += 1
			emit_signal("items_changed", [x])
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
	var x = items.size() - 1
	while x >= 0:
		if items[x] != null and need:
			if items[x].name == item.name:
				if items[x].amount >= need:
					scheduledRemovalIndexes.push_back(x)
					scheduledRemovalAmounts.push_back(need)
					amountTaken += need
					return true
				else:
					var available = items[x].amount
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
	emit_signal("items_changed", [itemIndex])
	return previousItem
	
func swap(itemIndex, targetItemIndex):
	var tmp = items[targetItemIndex]
	items[targetItemIndex] = items[itemIndex]
	items[itemIndex] = tmp
	emit_signal("items_changed", [itemIndex, targetItemIndex])
	
func remove(itemIndex):
	var previousItem = items[itemIndex]
	items[itemIndex] = null
	emit_signal("items_changed", [itemIndex])
	return previousItem
	
"""Removes scheduled Items from the Inventory
Clears the Arrays after the Action is complete"""
func removeScheduled():
	for x in range(scheduledRemovalIndexes.size()):
		items[scheduledRemovalIndexes[x]].amount -= scheduledRemovalAmounts[x]
	emit_signal("items_changed", scheduledRemovalIndexes)
	scheduledRemovalIndexes.clear()
	scheduledRemovalAmounts.clear()
	
func setInventorySize(size):
	for _x in range(size):
		items.push_back(null)
