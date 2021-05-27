extends Resource
class_name Item

export(String) var name
export(Texture) var texture
export(int) var amount

func setItemAmount(itemAmount):
	amount += itemAmount
