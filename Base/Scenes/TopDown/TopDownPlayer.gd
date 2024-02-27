extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 800.0
@export var friction = 1000.0
@export var roll_speed = 160.0

enum { NO_ACTION, ROLL, ATTACK}

var state = NO_ACTION
var roll_direction = Vector2.RIGHT
var status = PlayerStatus

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var sword_animation_player = $Sword/AnimationPlayer
@onready var sword = $Sword
@onready var sword_sprite_2d = $Sword/Node2D/Sprite2D
@onready var weapon_hitbox = $Sword/WeaponHitbox
@onready var hurtbox = $Hurtbox

func _ready():
	status.init()
	status.connect("no_health", on_no_health)
	weapon_hitbox.knockback_direction = roll_direction
	
func _physics_process(delta):
	var input_horizontal = Input.get_axis("move_left", "move_right")
	var input_vertical = Input.get_axis("move_up", "move_down")
	var input_vector = Vector2(input_horizontal, input_vertical)
	
	match state:
		NO_ACTION:
			process_no_action_state(input_vector)
		ROLL:
			process_roll_state()
		ATTACK:
			process_attack_state()
			
	process_movement(input_vector, delta)
			
	apply_friction(input_vector, delta)
	
	#move_and_collide(velocity * delta)
	move_and_slide()
	
	update_animations(input_vector)
	
func process_movement(input_vector, delta):
	match state:
		NO_ACTION, ATTACK:
			var velocity_direction = Vector2.ZERO
			if input_vector.x:
				velocity_direction.x = input_vector.x
		
			if input_vector.y:
				velocity_direction.y = input_vector.y
		
			velocity_direction = velocity_direction.normalized()
	
			velocity = velocity.move_toward(velocity_direction * speed, acceleration * delta)
		ROLL:
			velocity = roll_direction * roll_speed
	
func apply_friction(input_vector, delta):
	if input_vector.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if input_vector.y == 0.0:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
		
func update_animations(input_vector):
	match state:
		NO_ACTION:
			var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
			if mouse_direction.x:
				sprite_2d.flip_h = mouse_direction.x < 0
	
			if input_vector != Vector2.ZERO:
				animation_player.play("run")
			else:
				animation_player.play("idle")
		ROLL:
			pass
		ATTACK:
			pass
		
func update_weapon():
	var mouse_direction: Vector2 = (get_global_mouse_position() - sword.global_position).normalized()
	sword.rotation = mouse_direction.angle()
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	if sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
func process_no_action_state(input_direction):
	update_weapon()
	if (Input.is_action_just_pressed("attack")):
		state = ATTACK
	elif (Input.is_action_just_pressed("jump")):
		state = ROLL
		
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if (mouse_direction):
		roll_direction = input_direction
		weapon_hitbox.knockback_direction = mouse_direction
		
func process_attack_state():
	if (sword_animation_player.current_animation != "attack"):
		sword_animation_player.play("attack")
		await sword_animation_player.animation_finished
		sword_animation_player.play("idle")
		state = NO_ACTION
		
func process_roll_state():
	if (animation_player.current_animation != "roll"):
		animation_player.play("roll")
		await animation_player.animation_finished
		state = NO_ACTION


func _on_hurtbox_area_entered(area):
	if status.health <= 0:
		return
	status.health -= 1
	hurtbox.start_invincibilty(0.5)
		
func on_no_health():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().reload_current_scene()
