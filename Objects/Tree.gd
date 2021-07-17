extends "res://Objects/Object.gd"


onready var sprite = get_child(0)
onready var collision = get_child(1)
onready var breakingEffect = sprite.get_child(0)
onready var damagingEffect = sprite.get_child(1)
onready var playerItem = get_node("/root/Main/KinematicBody2D/PlayerItem")

var damageType = WorldVariables.type.WOOD
var level = 1
var hp = 400
var item = preload("res://Items/Wood.tres")
var amount = 6

var exists = true

func _ready():
	set_process(false)
	
func _process(delta):
	damage(self, delta)
	
"""While LMB is held on the Object, it gets damaged
Meaning the _process Method is active
Emits Particles with the Colors of the Object while damaged"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		set_process(true)
	
"""When the Mouse exits the Object, damaging stops"""
func _on_Hurtbox_mouse_exited():
	set_process(false)
	damagingEffect.emitting = false
