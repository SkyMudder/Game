extends Resource
class_name Inventory


signal items_changed(indexes)

export(Array, Resource) var items = []
const stackLimit : int = 5
	
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
	
func setInventorySize(size):
	for _x in range(size):
		items.push_back(null)
