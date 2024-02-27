extends Area2D

signal invincibility_start
signal invincibility_end

@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D

var invincible : bool = false
			
func start_invincibilty(duration):
	invincible = true
	emit_signal("invincibility_start")
	timer.start(duration)

func _on_timer_timeout():
	invincible = false
	emit_signal("invincibility_end")

func _on_invincibility_start():
	collision_shape_2d.set_deferred ("disabled", true)

func _on_invincibility_end():
	collision_shape_2d.disabled = false
