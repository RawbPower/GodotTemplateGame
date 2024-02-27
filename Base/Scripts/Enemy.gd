extends CharacterBody2D

@export var acceleration : float = 150
@export var max_speed : float = 30
@export var friction : float = 200
@export var death_effect : Resource
@export var hurt_sound : PackedScene

enum { IDLE, WANDER, PURSUE }

var knockback = Vector2.ZERO

var state = IDLE

@onready var status = $Status
@onready var detection_zone = $DetectionZone
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController
@onready var hurtbox = $Hurtbox
@onready var blink_animation = $BlinkAnimation

func _ready():
	randomize()

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
			
			if state == IDLE && wander_controller.get_time_left() <= 0:
				update_wander()
		WANDER:
			seek_player()
			
			if state == WANDER && wander_controller.get_time_left() <= 0:
				update_wander()
				
			var move_direction = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(move_direction * max_speed, acceleration * delta)
			
			if global_position.distance_squared_to(wander_controller.target_position) <= max_speed * delta:
				update_wander()
			animated_sprite_2d.flip_h = velocity.x > 0
		PURSUE:
			var target = detection_zone.target
			if target != null:
				var move_direction = global_position.direction_to(target.global_position)
				velocity = velocity.move_toward(move_direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			animated_sprite_2d.flip_h = velocity.x > 0
				
			
func seek_player():
	if detection_zone.can_see_player():
		state = PURSUE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_timer(randf_range(1,3))
	
func _on_hurtbox_area_entered(area):
	if area is Hitbox:
		status.health -= area.damage
		knockback = area.knockback_direction * 150
		hurtbox.start_invincibilty(0.4)
		if (hurt_sound):
			var hurtSound = hurt_sound.instantiate()
			get_tree().current_scene.add_child(hurtSound)

func _on_status_no_health():
	queue_free()
	var enemyDeathEffect = death_effect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_hurtbox_invincibility_start():
	blink_animation.play("start")

func _on_hurtbox_invincibility_end():
	blink_animation.play("stop")

