extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.connect("animation_finished", _on_animation_finished)

func _on_animation_finished():
	queue_free()
