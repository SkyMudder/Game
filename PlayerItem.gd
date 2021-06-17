extends Sprite


onready var toolbar = get_node("../../InventoryWrapper/CenterPlayerInventory/ToolbarDisplay")
var item

func _ready():
	toolbar.connect("item_switched", self, "_on_item_switched")
	
func _on_item_switched(_flag):
	if item != null:
		texture = item.texture
	else:
		texture = null
