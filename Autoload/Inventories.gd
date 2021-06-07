extends Node


const Inventory = preload("res://Inventory/Inventory.gd")

var playerInventory = Inventory.new(0, 24, 6)
var toolbar = Inventory.new(1, 10, 10)

onready var allInventories = []

func _ready():
	allInventories.push_back(playerInventory)
	allInventories.push_back(toolbar)
