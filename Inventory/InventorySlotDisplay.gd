extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var textureRect = get_node("TextureRect")
onready var itemAmount = get_node("TextureRect/ItemAmount")
onready var emptySlotTexture = preload("res://Items/EmptyInventorySlot.png")

"""Shows a given Item on the UI"""
func displayItem(item):
	if item is Item:
		textureRect.texture = item.texture
		itemAmount.text = str(item.amount)
	else:
		textureRect.texture = emptySlotTexture
		itemAmount.text = ""
	
func get_drag_data(_position):
	var itemIndex = get_index()
	var item = inventory.items[itemIndex]
	# For half-splitting Item Stacks
	if Input.is_action_pressed("ctrl"):
		if item is Item:
			var data = {}
			data.previousAmount = item.amount
			print(data.previousAmount)
			item.amount /= 2
			data.item = item.duplicate()
			if item.amount == 0:
				inventory.remove(itemIndex)
			inventory.emit_signal("items_changed", [itemIndex])
			data.itemIndex = itemIndex
			data.split = true
			var dragPreview = TextureRect.new()
			dragPreview.texture = item.texture
			set_drag_preview(dragPreview)
			return data
	# For moving Items
	else:
		item = inventory.remove(itemIndex)
		inventory.emit_signal("items_changed", [itemIndex])
		if item is Item:
			var data = {}
			data.item = item
			data.itemIndex = itemIndex
			var dragPreview = TextureRect.new()
			dragPreview.texture = item.texture
			set_drag_preview(dragPreview)
			return data
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var itemIndex = get_index()
	var item = inventory.items[itemIndex]
	# If there is already an Item of the same Type in the Target Item Slot
	if item is Item and item.name == data.item.name:
		item.amount += data.item.amount
		# If the previous Item Stack was Split and had an uneven number
		if data.has("split") and data.previousAmount % 2 != 0:
			item.amount += 1
		inventory.emit_signal("items_changed", [itemIndex])
	# If the previous Stack was Split
	elif data.has("split"):
		# If there is nothing at the Target Item Slot
		if inventory.items[itemIndex] == null:
			inventory.set(data.item, itemIndex)
		# If there is already an Item of the same Type in the Target Item Slot
		elif inventory.items[itemIndex].name == data.item.name:
			inventory.items[itemIndex].amount += data.item.amount
		# If the previous Item Stack was Split and had an uneven number
		if data.previousAmount % 2 != 0:
			inventory.items[itemIndex].amount += 1
		inventory.emit_signal("items_changed", [itemIndex, data.itemIndex])
	# For simply swapping Items
	else:
		inventory.swap(itemIndex, data.itemIndex)
		inventory.set(data.item, itemIndex)
		inventory.emit_signal("items_changed", [itemIndex, data.itemIndex])
