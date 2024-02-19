extends Node2D

@export var break_effect : Resource

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var breakEffect = break_effect.instantiate()
		var world = get_tree().current_scene
		world.add_child(breakEffect)
		breakEffect.global_position = global_position
		queue_free()
