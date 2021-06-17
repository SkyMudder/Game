extends StaticBody2D


onready var furnace = $Furnace
onready var furnaceOff = preload("res://PlaceableObjects/FurnaceOff.png")
onready var furnaceOn = preload("res://PlaceableObjects/FurnaceOn.png")
onready var furnaceNotPlaceable = preload("res://PlaceableObjects/FurnaceBlueprintNotPlaceable.png")
onready var furnacePlaceable = preload("res://PlaceableObjects/FurnaceBlueprintPlaceable.png")
onready var collision = get_node("CollisionShape2D")
onready var hurtbox = get_node("Hurtbox").get_child(0)
onready var ui = get_node("FurnaceViewWrapper/FurnaceView")
onready var fuelProgress = get_node("FurnaceViewWrapper/FurnaceView/FurnaceHBoxContainer/InventoryVBoxContainer/FuelHBoxContainer/Fuel")

var queue = []
var productItem

var previousCollisionShape
var previousHurtboxShape

var currentlyBurning = false
var currentlySmelting = false

var exists = true

var fuel = 0

const burnDuration = 1
const smeltDuration = 4

"""Deactivate _process, meaning Burning or Smelting
Connect the Signal for updating the Queue
Make the Furnace ready for Blueprinting
Meaning Collisions and UI are deactivated"""
func _ready():
	set_process(false)
	ui.hide()
	ui.connect("queue_updated", self, "_on_queue_updated")
	productItem = ui.productInventory.items
	previousCollisionShape = collision.shape
	previousHurtboxShape = hurtbox.shape
	furnace.texture = furnaceNotPlaceable
	
"""Runs while there are Items in the Queue"""
func _process(_delta):
	if queue.size() > 0:
		if readyToBurn():
			setState(1)
			burn()
		if readyToSmelt():
			setState(1)
			if productItem[0] != null:
				if productItem[0].amount < productItem[0].stackLimit:
					smelt()
			else:
				smelt()
	else:
		print(queue)
		setState(0)
		set_process(false)
	
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
	var index = findBurnable()	# First Slot with a burnable Item
	if index != null:	# Only burn if an Item was found
		currentlyBurning = true
		# Only burn if there is enough Space for Fuel
		# And if there are enough burnable Resources
		if fuel < 100 and sourceItems[index].amount > 0:
			# Wait a specific Amount of Time to simulate the Furnace burning
			yield(get_tree().create_timer(burnDuration), "timeout")
			# Only smelt if the Item is burnable
			# The Check has to be done again in case the Item was removed while
			# the Furnace was burning the Item
			if checkBurnable(sourceItems[index]):
				# Remove the burnt Item and add it as Fuel
				sourceItems[index].amount -= 1
				fuel += 20
				# Update the Fuel on the UI
				fuelProgress.value = fuel
				# Set the new Item Value on the UI unless the Amount is 0
				# Then the Item gets removed from the Inventory
				if sourceItems[index].amount > 0:
					ui.sourceInventory.set(sourceItems[index], index)
				else:
					ui.sourceInventory.remove(index)
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
	# Check if there is enough Fuel and a smeltable Item was found
	if index != null and fuel > 0:
		# Get the Source Item and determine what the Product is
		var item = getProductFromSource(sourceItems[index]).duplicate()
		currentlySmelting = true
		# Wait a specific Amount of Time to simulate the Furnace smelting
		yield(get_tree().create_timer(smeltDuration), "timeout")
		# If an Item is currently being moved, wait until it's dropped again
		# To avoid Bugs regarding the Amount of the Product
		if Inventories.moving:
			yield(Inventories, "resume")
		# Check if the Item is smeltable
		# and make sure that the Item in the Product Inventory is
		# the Smelting Product of the Source Item
		# To avoid that any Resource being placed there
		# can have its Amount incremented
		if checkSmeltable(sourceItems[index]):
			if targetItems[0] != null:
				if targetItems[0].name == getProductFromSource(sourceItems[index]).name:
					smeltUpdateValues(sourceItems[index], index, targetItems[0], item)
			else:
				smeltUpdateValues(sourceItems[index], index, targetItems[0], item)
		currentlySmelting = false
	
func smeltUpdateValues(sourceItem, index, targetItem, item):
	# Remove the smelted Item and the Fuel
	sourceItem.amount -= 1
	fuel -= 20
	# Update the Fuel on the UI
	fuelProgress.value = fuel
	# If there is no Item in the Product Inventory, add one
	# Else, increment its Value
	# Set the Items
	if targetItem == null:
		ui.productInventory.set(item.duplicate(), 0)
	else:
		item = targetItem
		item.amount += 1
		ui.productInventory.set(item, 0)
	# Set the Source Item, as its Value was decremented earlier
	ui.sourceInventory.set(sourceItem, index)
	
"""Return the first burnable Item Index found in the Queue
If no Item is found, null is returned"""
func findBurnable():
	for x in queue:
		if checkBurnable(ui.sourceInventory.items[x]):
			return x
	
"""Return the first smeltable Item Index found in the Queue
If no Item is found, null is returned"""
func findSmeltable():
	for x in queue:
		if checkSmeltable(ui.sourceInventory.items[x]):
			return x
	
"""Checks if a specific Item is Burnable
Returns a Boolean"""
func checkBurnable(item):
	if item != null:
		return item.burnable
	return false
	
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
	return item.smeltingProduct
	
"""This gets called when Items enter or leave the Furnace
They are added or removed from the Queue accordingly
Starts the Process when something entered the Queue"""
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
	if Input.is_action_just_pressed("ui_focus_next") or Input.is_action_just_pressed("mouse_right") or Input.is_action_just_pressed("ui_cancel"):
		ui.hide()
	
"""Handles the Furnace Input"""
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	# Toggle the Furnace UI Visibility
	if Input.is_action_just_pressed("mouse_right"):
		if ui.visible:
			ui.hide()
		else:
			ui.show()
	# Destroy the Furnace
	if Input.is_action_just_pressed("mouse_left"):
		if Input.is_action_pressed("ctrl"):
			if exists:
				Inventories.playerInventory.add(preload("res://Items/Furnace.tres"))
				Inventories.removeFurnaceInventory(ui.sourceInventory.id)
				queue_free()
				exists = false
