extends StaticBody2D

func _on_Tree_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var TreeBreakingEffect = load("res://Effects/TreeBreakingEffect.tscn")
		var treeBreakingEffect = TreeBreakingEffect.instance()
		var world = get_tree().current_scene
		world.add_child(treeBreakingEffect)
		treeBreakingEffect.global_position = global_position
		queue_free()
