extends StaticBody2D

onready var forge = $Forge
onready var forgeOff = preload("res://PlaceableObjects/ForgeOff.png")
onready var forgeOn = preload("res://PlaceableObjects/ForgeOn.png")
onready var forgeNotPlaceable = preload("res://PlaceableObjects/ForgeBlueprintNotPlaceable.png")
onready var forgePlaceable = preload("res://PlaceableObjects/ForgeBlueprintPlaceable.png")
onready var collision = get_node("CollisionShape2D")
onready var hurtbox = get_node("Hurtbox").get_child(0)

var previousCollisionShape
var previousHurtboxShape

var fuel

func _ready():
	previousCollisionShape = collision.shape
	previousHurtboxShape = hurtbox.shape
	forge.texture = forgeNotPlaceable
	
func setBlueprintState(state):
	if state == 0:
		forge.texture = forgeNotPlaceable
	elif state == 1:
		forge.texture = forgePlaceable
	
func setState(state):
	if state == 0:
		forge.texture = forgeOff
	elif state == 1:
		forge.texture = forgeOn
	
func setCollision(state):
	if state == 0:
		collision.shape = null
		hurtbox.shape = null
	if state == 1:
		collision.shape = previousCollisionShape
		hurtbox.shape = previousHurtboxShape
