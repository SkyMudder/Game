extends Node

"""Percentage of Spawnrates"""

const __percentage : int = 1000	# Base Value, basically sets the Spawnrate precision

"""Getters"""

func getPercentage():
	return __percentage

"""World"""

const __dirt : int = 200
const __grass : int = 200
const __rock : int = 30
const __tree : int = 30

"""Getters"""

func getDirt():
	return __dirt

func getGrass():
	return __grass

func getRock():
	return __rock

func getTree():
	return __tree
