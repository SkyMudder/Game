extends Particles2D

signal finished

func _ready():
		yield(get_tree().create_timer(lifetime), "timeout")
		emit_signal("finished")
