extends Node


signal resume

const Inventory = preload("res://Inventory/Inventory.gd")

onready var currentInventory = 0
var currentFurnace = 0

var moving
var open = false
var unhandledData = {}

var playerInventory = Inventory.new(0, 24, 6)
var toolbar = Inventory.new(1, 10, 10)

onready var playerInventories = []
onready var furnaceInventories = []

func _ready():
	playerInventories.push_back(playerInventory)
	currentInventory += 1
	playerInventories.push_back(toolbar)
	currentInventory += 1
	
func newFurnaceInventory():
	furnaceInventories.push_back(Inventory.new(currentInventory, 3, 1))
	print("NEW INVENTORY " + str(currentInventory))
	currentInventory += 1
	furnaceInventories.push_back(Inventory.new(currentInventory, 1, 1))
	print("NEW INVENTORY " + str(currentInventory))
	currentInventory += 1
	print("NEW INVENTORY FURNACE " + str(currentFurnace))
	currentFurnace += 2
	print(furnaceInventories)
	return currentFurnace - 2
	
func removeFurnaceInventory(inventoryID):
	furnaceInventories.erase(getInventoryByID(inventoryID))
	print("REMOVE INVENTORY " + str(inventoryID))
	furnaceInventories.erase(getInventoryByID(inventoryID + 1))
	print("REMOVE INVENTORY " + str(inventoryID + 1))
	currentInventory -= 2
	currentFurnace -= 2
	print(furnaceInventories)
	
func getInventoryByID(inventoryID):
	var inventory = getPlayerInventoryByID(inventoryID)
	if inventory != null:
		return inventory
	inventory = getFurnaceInventoryByID(inventoryID)
	if inventory != null:
		return inventory
	
func getPlayerInventoryByID(inventoryID):
	for x in playerInventories:
		if x.id == inventoryID:
			return x
	
func getFurnaceInventoryByID(inventoryID):
	for x in furnaceInventories:
		if x.id == inventoryID:
			return x
	
func notifyMoving(state):
	if state:
		moving = true
	else:
		moving = false
		emit_signal("resume")
	
func setUnhandledData(inventory, item, amount, index):
	unhandledData.inventory = inventory
	unhandledData.item = item
	unhandledData.amount = amount
	unhandledData.index = index
