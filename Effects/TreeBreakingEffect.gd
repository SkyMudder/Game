extends Node2D


onready var animatedSprite = get_node("AnimatedSprite")

func _ready():
	animatedSprite.play("Animate")

func _on_AnimatedSprite_animation_finished():
	queue_free()
