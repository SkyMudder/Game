extends Node

"""Percentage of Spawnrates"""

const __percentage : int = 1000	# 100%

"""Getters"""

func getPercentage():
	return __percentage

"""World"""

const __grass : int = 200
const __rock : int = 50
const __tree : int = 100

"""Getters"""

func getGrass():
	return __grass

func getRock():
	return __rock

func getTree():
	return __tree
