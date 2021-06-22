extends StaticBody2D


onready var inventory : Inventory = Inventories.playerInventory

"""While LMB is held on the Object, it gets damaged
Meaning the _process Method is active
Emits Particles with the Colors of the Object while damaged"""
func addToInventory(object) -> void:
	if object.exists:
			object.item.amount = object.amount
			object.inventory.add(object.item)
			object.exists = false
			object.queue_free()
