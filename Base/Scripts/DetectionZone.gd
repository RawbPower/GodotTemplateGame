extends Area2D

var target = null

func can_see_player():
	return target != null

func _on_body_entered(body):
	target = body


func _on_body_exited(_body):
	target = null
