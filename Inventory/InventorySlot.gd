class_name InventorySlot


var __resourceType : int
var __resourceAmount : int

func _init(resourceType, resourceAmount):
	self.__resourceType = resourceType
	self.__resourceAmount = resourceAmount
	
"""Getters"""

func getResourceType():
	return __resourceType
	
func getResourceAmount():
	return __resourceAmount
	
"""Setters"""

func setResourceType(type):
	__resourceType = type
	
func setResourceAmount(amount):
	__resourceAmount += amount
