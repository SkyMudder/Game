extends Particles2D

signal finished

var exists = 1

func _ready():
	if exists == 1:
		yield(get_tree().create_timer(lifetime), "timeout")
		emit_signal("finished")
		exists = 0
