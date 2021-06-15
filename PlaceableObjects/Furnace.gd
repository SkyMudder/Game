extends StaticBody2D


onready var furnace = $Furnace
onready var furnaceOff = preload("res://PlaceableObjects/FurnaceOff.png")
onready var furnaceOn = preload("res://PlaceableObjects/FurnaceOn.png")
onready var furnaceNotPlaceable = preload("res://PlaceableObjects/FurnaceBlueprintNotPlaceable.png")
onready var furnacePlaceable = preload("res://PlaceableObjects/FurnaceBlueprintPlaceable.png")
onready var collision = get_node("CollisionShape2D")
onready var hurtbox = get_node("Hurtbox").get_child(0)
onready var ui = get_node("FurnaceView")
onready var fuelProgress = get_node("FurnaceView/FurnaceHBoxContainer/InventoryVBoxContainer/FuelHBoxContainer/Fuel")

var queue = []

var previousCollisionShape
var previousHurtboxShape

var currentlyBurning = false
var currentlySmelting = false

var fuel = 0

const burnDuration = 0.5
const smeltDuration = 1.0

"""Deactivate _process, meaning Burning or Smelting
Connect the Signal for updating the Queue
Make the Furnace ready for Blueprint
Collisions and UI are deactivated"""
func _ready():
	set_process(false)
	ui.hide()
	ui.connect("queue_updated", self, "_on_queue_updated")
	previousCollisionShape = collision.shape
	previousHurtboxShape = hurtbox.shape
	furnace.texture = furnaceNotPlaceable
	
"""Runs while there are Items in the Queue"""
func _process(_delta):
	var start = OS.get_ticks_usec()
	if queue.size() > 0:
		if readyToBurn():
			burn()
		if readyToSmelt():
			smelt()
	else:
		print(queue)
		set_process(false)
	var end = OS.get_ticks_usec()
	print(end - start)
	
"""Set the Texture using a Blueprint State"""
func setBlueprintState(state):
	if state == 0:
		furnace.texture = furnaceNotPlaceable
	elif state == 1:
		furnace.texture = furnacePlaceable
	
"""Set the Texture using a Furnace State"""
func setState(state):
	if state == 0:
		furnace.texture = furnaceOff
	elif state == 1:
		furnace.texture = furnaceOn
	
"""Toggle Collision"""
func setCollision(state):
	if state == 0:
		collision.shape = null
		hurtbox.shape = null
	if state == 1:
		collision.shape = previousCollisionShape
		hurtbox.shape = previousHurtboxShape
	
"""Burn a Stack until the Fuel has reached its max Value
Or until the Stack has no Items"""
func burn():
	var sourceItems = ui.sourceInventory.items
	var index = findBurnable()
	if index != null:
		currentlyBurning = true
		while fuel < 100 and sourceItems[index].amount > 0:
			yield(get_tree().create_timer(burnDuration), "timeout")
			if !checkBurnable(sourceItems[index]):
				break
			sourceItems[index].amount -= 1
			fuel += 20
			fuelProgress.value = fuel
			if sourceItems[index].amount > 0:
				ui.sourceInventory.set(sourceItems[index], index)
			else:
				ui.sourceInventory.remove(index)
				break
		currentlyBurning = false
	
"""Burn a Stack until there is no Fuel anymore,
Until the Stack has no Items
Or until the Product Inventory is full
Also does multiple Checks to guarantee that an Item like Wood
Does not have its value incremented when put in the Product Inventory
"""
func smelt():
	var sourceItems = ui.sourceInventory.items
	var targetItems = ui.productInventory.items
	var index = findSmeltable()
	if index != null:
		var item = getProductFromSource(sourceItems[index])
		currentlySmelting = true
		while fuel > 0 and sourceItems[index].amount > 0:
			if targetItems[0] != null:
				if targetItems[0].amount == item.stackLimit:
						break
			yield(get_tree().create_timer(smeltDuration), "timeout")
			if Inventories.moving:
				yield(Inventories, "resume")
			if !checkSmeltable(sourceItems[index]) or checkSmeltable(targetItems[0]) or checkBurnable(targetItems[0]):
				break
			sourceItems[index].amount -= 1
			fuel -= 20
			fuelProgress.value = fuel
			if sourceItems[index].amount > 0:
				ui.sourceInventory.set(sourceItems[index], index)
			else:
				ui.sourceInventory.remove(index)
			if targetItems[0] == null:
				item.amount = 1
				ui.productInventory.set(item.duplicate(), 0)
			else:
				item = targetItems[0].duplicate()
				item.amount += 1
				ui.productInventory.set(item.duplicate(), 0)
		currentlySmelting = false
	
"""Return the first burnable Item Index found in the Queue
If no Item is found, null is returned"""
func findBurnable():
	for x in queue:
		if checkBurnable(ui.sourceInventory.items[x]):
			return x
	
"""Checks if a specific Item is Burnable
Returns a Boolean"""
func checkBurnable(item):
	if item != null:
		return item.burnable
	return false
	
"""Return the first smeltable Item Index found in the Queue
If no Item is found, null is returned"""
func findSmeltable():
	for x in queue:
		if checkSmeltable(ui.sourceInventory.items[x]):
			return x
	
"""Checks if a specific Item is Smeltable
Returns a Boolean"""
func checkSmeltable(item):
	if item != null:
		return item.smeltable
	return false
	
"""Check if Items are already being burned"""
func readyToBurn():
	if !currentlyBurning:
		return true
	return false
	
"""Check if Items are already being smelted"""
func readyToSmelt():
	if !currentlySmelting:
		return true
	return false
	
func getProductFromSource(item):
	return item.smeltProduct
	
"""This gets called when Items enter or leave the Furnace
They are added or removed from the Queue accordingly"""
func _on_queue_updated(itemIndex, flag):
	if flag == 0:
		if !itemIndex in queue:
			queue.push_back(itemIndex)
			set_process(true)
	else:
		queue.erase(itemIndex)
	print(queue)
	
"""For closing the Furnace Inventory when opening the Main Inventory
Or right Clicking anywhere"""
func _input(_event):
	if Input.is_action_just_pressed("ui_focus_next") or Input.is_action_just_pressed("mouse_right"):
		ui.hide()
	
"""Toggle the Furnace UI Visibility"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("mouse_right"):
		if ui.visible:
			ui.hide()
		else:
			ui.show()
