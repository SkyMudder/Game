extends Area2D


var flag : int = 0

func _process(delta):
	if flag == 0:
		global_position += Vector2(1, 0)
		flag = 1
	if flag == 1:
		global_position -= Vector2(1, 0)
		flag = 0
