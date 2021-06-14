extends Node


const Inventory = preload("res://Inventory/Inventory.gd")

signal resume

onready var currentInventory = 0
var currentFurnace = 0

var moving

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
	currentInventory += 1
	furnaceInventories.push_back(Inventory.new(currentInventory, 1, 1))
	currentInventory += 1
	currentFurnace += 2
	return currentFurnace - 2
	
func removeFurnaceInventory(inventoryID):
	for x in furnaceInventories:
		if x.id == inventoryID:
			furnaceInventories.remove(inventoryID - currentInventory + currentFurnace)
			furnaceInventories.remove(inventoryID - currentInventory + currentFurnace)
			currentFurnace -= 2
			currentInventory -= 2
	
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
	
func notifyMoving(_inventoryID, status):
	if status:
		moving = true
	else:
		emit_signal("resume")
