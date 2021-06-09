extends StaticBody2D


onready var inventory = Inventories.playerInventory
onready var sprite = $Tree
onready var collision = get_node("CollisionShape2D")
onready var breakingEffect = get_node("Tree/BreakingEffect")
onready var damagingEffect = get_node("Tree/DamagingEffect")

var hp = 400

var item = preload("res://Items/Wood.tres")
var amount = 1
var exists = 1

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

"""While LMB is held on the Object, it gets damaged
Meaning the _process Method is active
Emits Particles with the Colors of the Object while damaged"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		set_process(true)
		damagingEffect.emitting = true
	else:
		damagingEffect.emitting = false
		set_process(false)
	
"""On Destroy, the Resource of the Object gets added to the Inventory
A new explosive Particle Effect gets emitted
Texture and Collision of the Object get deactivated on Particel Emission
The Object gets freed after the time the Particle Effect needs to process"""
func destroy():
	if exists == 1:
			inventory.add(item)
			exists = 0
			sprite.texture = null
			collision.shape = null
			breakingEffect.emitting = true
			yield(get_tree().create_timer(breakingEffect.lifetime), "timeout")
			queue_free()
