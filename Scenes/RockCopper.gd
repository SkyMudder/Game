extends StaticBody2D


onready var inventory = Inventories.playerInventory
onready var sprite = $RockCopper
onready var collision = get_node("CollisionShape2D")
onready var breakingEffect = get_node("RockCopper/BreakingEffect")

var item = preload("res://Items/Copper.tres")
var amount = 1
var exists = 1

"""Creates an Effect and makes the Object disappear
when the Object gets left clicked"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if exists == 1:
			inventory.add(item)
			sprite.texture = null
			collision.shape = null
			breakingEffect.emitting = true
			exists = 0
			yield(get_tree().create_timer(breakingEffect.lifetime + 0.1), "timeout")
			queue_free()
