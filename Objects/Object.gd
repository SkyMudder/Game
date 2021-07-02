extends StaticBody2D


onready var inventory : Inventory = Inventories.playerInventory

"""While active, removes HP
Unbound from Framerate
When HP reaches 0, the Particles stop emitting and the Object gets destroyed"""
func damage(object, delta) -> void:
	if object.playerItem.item != null:
		if object.type == object.playerItem.item.type and object.level <= object.playerItem.item.level:
			object.damagingEffect.emitting = true
			var remove = 60 * delta
			if object.playerItem.item != null:
				remove *= object.playerItem.item.damageMultiplier
			object.hp -= remove
			if object.hp < 0:
				object.damagingEffect.emitting = false
				destroy(object)
				object.set_process(false)
			if !Input.is_mouse_button_pressed(BUTTON_LEFT):
				object.set_process(false)
				object.damagingEffect.emitting = false
	
"""On Destroy, the Resource of the Object gets added to the Inventory
A new explosive Particle Effect gets emitted
Texture and Collision of the Object get deactivated on Particle Emission
The Object gets freed after the time the Particle Effect needs to process"""
func destroy(object) -> void:
	if object.exists:
		object.item.amount = object.amount
		object.inventory.add(object.item)
		object.exists = false
		object.sprite.texture = null
		object.collision.shape = null
		object.breakingEffect.emitting = true
		yield(get_tree().create_timer(object.breakingEffect.lifetime), "timeout")
		object.queue_free()
