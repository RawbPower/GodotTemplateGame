extends Node2D

@export var break_effect : Resource

func create_grass_effect():
	var breakEffect = break_effect.instantiate()
	get_parent().add_child(breakEffect)
	breakEffect.global_position = global_position


func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
