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

var threadBurn
var threadSmelt

var queue = []

var previousCollisionShape
var previousHurtboxShape

var currentlyBurning = false
var currentlySmelting = false
var waiting
var fuel = 0

const burnDuration = 1.0
const smeltDuration = 4.0

func _ready():
	set_process(false)
	ui.hide()
	ui.connect("queue_updated", self, "_on_queue_updated")
	previousCollisionShape = collision.shape
	previousHurtboxShape = hurtbox.shape
	furnace.texture = furnaceNotPlaceable
	
func _process(_delta):
	if queue != null:
		if !currentlyBurning:
			for x in queue:
				burn(x)
				if getAmount(ui.sourceInventory, x) == null:
					queue.erase(x)
		if !currentlySmelting:
			for x in queue:
				smelt(x)
				if getAmount(ui.sourceInventory, x) == null:
					queue.erase(x)
	else:
		set_process(false)
	
func setBlueprintState(state):
	if state == 0:
		furnace.texture = furnaceNotPlaceable
	elif state == 1:
		furnace.texture = furnacePlaceable
	
func setState(state):
	if state == 0:
		furnace.texture = furnaceOff
	elif state == 1:
		furnace.texture = furnaceOn
	
func setCollision(state):
	if state == 0:
		collision.shape = null
		hurtbox.shape = null
	if state == 1:
		collision.shape = previousCollisionShape
		hurtbox.shape = previousHurtboxShape
	
func checkItemBurnable(itemIndex):
	if ui.sourceInventory.items[itemIndex] != null:
		if ui.sourceInventory.items[itemIndex].burnable:
			return true
	
func checkItemSmeltable(itemIndex):
	if ui.sourceInventory.items[itemIndex] != null:
		if ui.sourceInventory.items[itemIndex].smeltable:
			return true
	
func burn(itemIndex):
	if checkItemBurnable(itemIndex):
		currentlyBurning = true
		while ui.sourceInventory.items[itemIndex].amount > 0 and fuel < 100:
			yield(get_tree().create_timer(burnDuration), "timeout")
			fuel += 20
			removeOne(itemIndex)
			fuelProgress.value = fuel
			if getAmount(ui.sourceInventory, itemIndex) > 0:
				ui.sourceInventory.emit_signal("items_changed", ui.sourceInventory.id, itemIndex)
		currentlyBurning = false
		if getAmount(ui.sourceInventory, itemIndex) == 0:
			ui.sourceInventory.remove(itemIndex)
	
func smelt(itemIndex):
	var amount = 0
	var item
	if checkItemSmeltable(itemIndex):
		currentlySmelting = true
		while getAmount(ui.sourceInventory, itemIndex) > 0 and fuel > 0 and checkSpace():
			print("TARRO")
			yield(get_tree().create_timer(burnDuration), "timeout")
			if Inventories.moving:
				set_process(false)
				print("moving")
				yield(Inventories, "resume")
				Inventories.moving = false
				print("not moving")
				set_process(true)
			fuel -= 20
			removeOne(itemIndex)
			fuelProgress.value = fuel
			if getAmount(ui.sourceInventory, itemIndex) > 0:
				ui.sourceInventory.emit_signal("items_changed", ui.sourceInventory.id, itemIndex)
			amount = getAmount(ui.productInventory, 0)
			if amount != null:
				item = ui.sourceInventory.items[itemIndex].smeltProduct
				item.amount = ui.productInventory.items[0].amount + 1
				ui.productInventory.set(item.duplicate(), 0)
			else:
				item = ui.sourceInventory.items[itemIndex].smeltProduct
				item.amount = 1
				ui.productInventory.set(item.duplicate(), 0)
		currentlySmelting = false
		var tmp = getAmount(ui.sourceInventory, itemIndex)
		if tmp != null:
			if tmp == 0:
				ui.sourceInventory.remove(itemIndex)
	
func removeOne(itemIndex):
	if ui.sourceInventory.items[itemIndex] != null:
		ui.sourceInventory.items[itemIndex].amount -= 1
	
func getAmount(inventory, itemIndex):
	if inventory.items[itemIndex] != null:
		return inventory.items[itemIndex].amount
	
func checkSpace():
	if ui.productInventory.items[0] != null:
		if ui.productInventory.items[0].amount < ui.productInventory.items[0].stackLimit:
			return true
	if ui.productInventory.items[0] == null:
		return true
	return false
	
func _on_queue_updated(itemIndex, flag):
	if flag == 0:
		if !itemIndex in queue:
			queue.push_back(itemIndex)
		set_process(true)
	else:
		if itemIndex in queue:
			queue.erase(itemIndex)
		set_process(true)
	print(queue)
	
func _input(_event):
	if Input.is_action_just_pressed("ui_focus_next") or Input.is_action_just_pressed("mouse_right"):
		ui.hide()
	
func _on_Hurtbox_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("mouse_right"):
		if ui.visible:
			ui.hide()
		else:
			ui.show()
