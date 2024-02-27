extends Node

signal no_health

@export var stats : EnemyStats

var health : int:
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			emit_signal("no_health")

func _ready():
	health = stats.max_health
