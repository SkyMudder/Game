extends Sprite

onready var toolbar = get_node("../InventoryWrapper/CenterPlayerInventory/InventoryDisplay")
var item

func _ready():
	for x in toolbar.get_children():
		x.connect("item_switched", self, "_on_item_switched")
	
func _on_item_switched():
	if item != null:
		texture = item.texture
	else:
		texture = null
