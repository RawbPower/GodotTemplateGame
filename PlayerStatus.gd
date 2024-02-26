extends Node

signal no_health
signal health_changed
signal max_health_changed

@export var max_health : int = 4:
	set(value):
		max_health = value
		emit_signal("max_health_changed", max_health)

var health : int:
	get:
		return health
	set(value):
		health = value
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("no_health")
			
func _ready():
	init()
	
func init():
	health = max_health
