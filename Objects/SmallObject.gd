extends StaticBody2D


onready var inventory = Inventories.playerInventory

var item
var exists = true

"""While LMB is held on the Object, it gets damaged
Meaning the _process Method is active
Emits Particles with the Colors of the Object while damaged"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if exists:
			inventory.add(item)
			exists = false
			queue_free()
	
func assignVariables(vars):
	item = vars[3]
