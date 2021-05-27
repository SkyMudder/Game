extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array, Resource) var items = [null, null, null, null, null, null, null, null, null]

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
