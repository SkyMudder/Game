extends StaticBody2D


onready var inventory = Inventories.allInventories[0]

var item = preload("res://Items/Stone.tres")
var amount = 1
var exists = 1

"""Creates an Effect and makes the Object disappear
when the Object gets left clicked"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var RockBreakingEffect = load("res://Effects/RockBreakingEffect.tscn")
		var rockBreakingEffect = RockBreakingEffect.instance()
		var world = get_tree().current_scene
		world.add_child(rockBreakingEffect)
		rockBreakingEffect.global_position = global_position
		queue_free()
		if exists == 1:
			item.name = "Rock"
			inventory.add(item)
		exists = 0
