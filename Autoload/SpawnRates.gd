extends Node


"""Sets the Spawnrates"""
func _ready():
	dirt.rock = 60
	dirt.copper = 30
	dirt.rocksmall = 30
	grass.tree = 60
	grass.stick = 20
	grassdark.treedark = grass.tree
	
"""Percentage of Spawnrates"""

# Base Value, basically sets the Spawnrate Precision
const __percentage : int = 1000

"""Getters"""

func getPercentage() -> int:
	return __percentage

"""World"""
var dirt = {}
var grass = {}
var grassdark = {}
var grassTop : int = 100
