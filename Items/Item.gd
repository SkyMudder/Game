extends Resource
class_name Item

export(String) var name
export(Texture) var texture
export(int) var amount = 1
export(int) var stackLimit
export(float) var damageMultiplier
export(int) var type
export(bool) var burnable
export(bool) var smeltable
export(Resource) var smeltingProduct
export(int) var level
export(bool) var placeable
export(int) var placeableObject

func getObject():
	return WorldVariables.placeableObjects[placeableObject]
