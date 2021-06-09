extends StaticBody2D


onready var inventory = Inventories.playerInventory
onready var sprite = get_child(0)
onready var collision = get_child(1)
onready var breakingEffect = sprite.get_child(0)
onready var damagingEffect = sprite.get_child(1)

var hp

var item
var amount

var exists = true

func _ready():
	set_process(false)
	
"""While active, removes HP
Unbound from Framerate
When HP reach 0, the Particles stop emitting and the Object gets destroyed"""
func _process(delta):
	hp -= 60 * delta
	if hp < 0:
		damagingEffect.emitting = false
		destroy()
		set_process(false)
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		set_process(false)
		damagingEffect.emitting = false
	
"""While LMB is held on the Object, it gets damaged
Meaning the _process Method is active
Emits Particles with the Colors of the Object while damaged"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		set_process(true)
		damagingEffect.emitting = true
	
"""On Destroy, the Resource of the Object gets added to the Inventory
A new explosive Particle Effect gets emitted
Texture and Collision of the Object get deactivated on Particel Emission
The Object gets freed after the time the Particle Effect needs to process"""
func destroy():
	if exists:
		item.amount = amount
		inventory.add(item)
		exists = false
		sprite.texture = null
		collision.shape = null
		breakingEffect.emitting = true
		yield(get_tree().create_timer(breakingEffect.lifetime), "timeout")
		queue_free()
	
"""Assigns the Objects Values"""
func assignVariables(vars):
	hp = vars[0]
	item = vars[1]
	amount = vars[2]
	
func _on_Hurtbox_mouse_exited():
	set_process(false)
	damagingEffect.emitting = false
