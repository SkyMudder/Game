class_name Farmable


var __hp = 5
var __farmableType = type.TREE
enum type {TREE, ROCK}
var texture : Texture

func _init(farmableType):
	if __farmableType == type.ROCK:
		texture = preload("res://Sprites/Rock.png")

func getTexture():
	return texture
