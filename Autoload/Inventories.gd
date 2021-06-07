extends Node


const Inventory = preload("res://Inventory/Inventory.gd")

var current = 0

var playerInventory = Inventory.new(0, 24, 6)
var toolbar = Inventory.new(1, 10, 10)

onready var allInventories = []

func _ready():
	allInventories.push_back(playerInventory)
	allInventories.push_back(toolbar)

func getInventory():
	current += 1
	return allInventories[current - 1]
