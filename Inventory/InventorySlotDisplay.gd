extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var textureRect = get_node("TextureRect")
onready var emptySlotTexture = preload("res://Items/EmptyInventorySlot.png")

"""Shows a given Item on the UI"""
func displayItem(item):
	if item is Item:
		textureRect.texture = item.texture
	else:
		textureRect.texture = emptySlotTexture
	
func get_drag_data(_position):
	var itemIndex = get_index()
	var item = inventory.remove(itemIndex)
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
	inventory.swap(itemIndex, data.itemIndex)
	print(itemIndex)
	inventory.set(data.item, itemIndex)
