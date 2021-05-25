extends StaticBody2D


var resourceType = WorldVariables.type.TREE
var amount = 1
var exists = 1

"""Creates an Effect and makes the Object disappear
when the Object gets left clicked"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var TreeBreakingEffect = load("res://Effects/TreeBreakingEffect.tscn")
		var treeBreakingEffect = TreeBreakingEffect.instance()
		var world = get_tree().current_scene
		world.add_child(treeBreakingEffect)
		treeBreakingEffect.global_position = global_position
		queue_free()
		if exists == 1:
			Inventory.add(resourceType, amount)
		exists = 0
