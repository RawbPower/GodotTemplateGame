extends CharacterBody2D

@export var acceleration : float = 150
@export var max_speed : float = 30
@export var friction : float = 200
@export var death_effect : Resource

enum { IDLE, WANDER, PURSUE }

var knockback = Vector2.ZERO

var state = IDLE

@onready var status = $Status
@onready var detection_zone = $DetectionZone
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var soft_collision = $SoftCollision

func _physics_process(delta):
	# Incorporate this into other movement
	knockback = knockback.move_toward(Vector2.ZERO, 250 * delta)	
	move_and_collide(knockback * delta)
	
	process_FSM(delta)
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_direction() * delta * 500
	move_and_slide()

func process_FSM(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		WANDER:
			pass
		PURSUE:
			var target = detection_zone.target
			if target != null:
				var move_direction = (target.global_position - global_position).normalized()
				velocity = velocity.move_toward(move_direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			animated_sprite_2d.flip_h = velocity.x > 0
				
			
func seek_player():
	if detection_zone.can_see_player():
		state = PURSUE
	
func _on_hurtbox_area_entered(area):
	if area is Hitbox:
		status.health -= area.damage
		knockback = area.knockback_direction * 150

func _on_status_no_health():
	queue_free()
	var enemyDeathEffect = death_effect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
