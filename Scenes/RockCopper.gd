extends StaticBody2D


onready var inventory = Inventories.playerInventory

var item = preload("res://Items/Copper.tres")
var amount = 1
var exists = 1

"""Creates an Effect and makes the Object disappear
when the Object gets left clicked"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var CopperBreakingEffect = preload("res://Effects/RockBreakingEffect.tscn")
		var copperBreakingEffect = CopperBreakingEffect.instance()
		var world = get_tree().current_scene
		world.add_child(copperBreakingEffect)
		copperBreakingEffect.global_position = global_position
		queue_free()
		if exists == 1:
			inventory.add(item)
			exists = 0
