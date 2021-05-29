extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var textureRect = get_node("TextureRect")
onready var itemAmount = get_node("TextureRect/ItemAmount")
onready var emptySlotTexture = preload("res://Items/EmptyInventorySlot.png")

"""Shows a given Item on the UI"""
func displayItem(item):
	if item is Item and item.amount > 0:
		textureRect.texture = item.texture
		itemAmount.text = str(item.amount)
	else:
		textureRect.texture = emptySlotTexture
		itemAmount.text = ""
		# Sets the Object to null because nothing is there anymore
		inventory.items[inventory.items.find(item)] = null
	
func get_drag_data(_position):
	var itemIndex = get_index()
	var item = inventory.items[itemIndex]
	# For half-splitting Item Stacks
	if Input.is_action_pressed("ctrl"):
		if item is Item:
			var data = {}
			data.previousAmount = item.amount
			item.amount /= 2
			data.item = item.duplicate()
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
		if item is Item:
			var data = {}
			data.item = item
			data.itemIndex = itemIndex
			data.previousAmount = item.amount
			var dragPreview = TextureRect.new()
			dragPreview.texture = item.texture
			set_drag_preview(dragPreview)
			return data
		inventory.emit_signal("items_changed", [itemIndex])
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var itemIndex = get_index()
	var item = inventory.items[itemIndex]
	
	# Check if the Source is an Item and if it is of the same Type
	if item is Item and item.name == data.item.name:
		# Check if the Source Slot is the same as the Target Slot
		# The Item will not be moved and will restore it's previous Value
		if itemIndex == data.itemIndex:
			item.amount = data.previousAmount
			inventory.set(item, itemIndex)
			inventory.emit_signal("items_changed", [itemIndex])
			return
		# Check if the items are of the same Type
		# And if the Source Stack has been split
		if item.name == data.item.name and !data.has("split"):
			var space = inventory.stackLimit - item.amount
			# Check if the split Stack has enough Space to be merged
			# With the new Stack
			if item.amount + data.item.amount < inventory.stackLimit:
				item.amount += data.item.amount
				data.item.amount = 0
			# If not, add what has Space and readd the Rest to the Source Stack
			else:
				item.amount += space
				data.item.amount -= space
		# Check if the Source Item Stack was Split and had an uneven number
		elif data.has("split") and data.item.name == item.name:
			var space = inventory.stackLimit - item.amount
			# Check if the split Stack has enough Space to be merged
			# With the new Stack
			if item.amount + data.item.amount < inventory.stackLimit:
				item.amount += data.item.amount
				# Add one if the Number of the full Stack was uneven
				# Due to the Integer Decimal part being discarded
				if data.previousAmount % 2 != 0:
					item.amount += 1
			# If not, add what has Space and readd the Rest to the Source Stack
			else:
				item.amount += space
				data.item.amount = data.previousAmount - space
		inventory.set(item, itemIndex)
		inventory.set(data.item, data.itemIndex)
	# Check if the Source Stack was Split
	elif data.has("split"):
		# Check if the Item is not null
		# So it doesn't get merged and it's old Value gets restored
		# To avoid merging different Types of Objects with each other
		if item != null:
			data.item.amount = data.previousAmount
			inventory.set(data.item, data.itemIndex)
		# Check if the Target Slot is empty, add the split Stack to it
		else:
			# Add one if the Number of the full Stack was uneven
			# Due to the Integer Decimal part being discarded
			# Duplicate the Item in Order for it not to share the same value
			# With the Source Stack
			if data.previousAmount % 2 != 0:
				inventory.set(data.item.duplicate(), data.itemIndex)
				data.item.amount += 1
			inventory.set(data.item, itemIndex)
	# For simply swapping Items
	else:
		inventory.swap(itemIndex, data.itemIndex)
		inventory.set(data.item, itemIndex)
