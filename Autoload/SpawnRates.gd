extends Node

"""Percentage of Spawnrates"""

# Base Value, basically sets the Spawnrate precision
const __percentage : int = 1000

"""Getters"""

func getPercentage():
	return __percentage

"""World"""

const __dirt : int = 300
const __grass : int = 100
const __rock : int = 60
const __tree : int = 60
const __stick : int = 20
const __copper : int = 10

"""Getters"""

func getDirt():
	return __dirt

func getGrass():
	return __grass

func getRock():
	return __rock

func getTree():
	return __tree

func getStick():
	return __stick

func getCopper():
	return __copper
