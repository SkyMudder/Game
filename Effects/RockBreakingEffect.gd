extends Node2D


onready var animatedSprite = $AnimatedSprite

"""Plays the Animation"""
func _ready():
	animatedSprite.play("Animate")
	
"""Removes the Animation from the World when it has finished"""
func _on_AnimatedSprite_animation_finished():
	queue_free()
