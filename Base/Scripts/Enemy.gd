extends CharacterBody2D

@export var death_effect : Resource

var knockback = Vector2.ZERO

@onready var status = $Status

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 250 * delta)
	velocity = knockback
	move_and_slide()

func _on_hurtbox_area_entered(area):
	if area is Hitbox:
		status.health -= area.damage
		knockback = area.knockback_direction * 120

func _on_status_no_health():
	queue_free()
	var enemyDeathEffect = death_effect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
