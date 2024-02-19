extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 800.0
@export var friction = 1000.0

enum { NO_ACTION, ROLL, ATTACK}

var state = NO_ACTION

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var sword_animation_player = $Sword/AnimationPlayer
@onready var sword = $Sword
@onready var sword_sprite_2d = $Sword/Node2D/Sprite2D

func _ready():
	pass
	
func _physics_process(delta):
	var input_horizontal = Input.get_axis("move_left", "move_right")
	var input_vertical = Input.get_axis("move_up", "move_down")
	var input_vector = Vector2(input_horizontal, input_vertical)
	
	process_movement(input_vector, delta)
	
	match state:
		NO_ACTION:
			update_weapon()
			if (Input.is_action_just_pressed("attack")):
				state = ATTACK
		ROLL:
			pass
		ATTACK:
			process_attack()
			
	apply_friction(input_vector, delta)
	
	#move_and_collide(velocity * delta)
	move_and_slide()
	
	update_animations(input_vector)
	
func process_movement(input_vector, delta):
	var velocity_direction = Vector2.ZERO
	if input_vector.x:
		velocity_direction.x = input_vector.x
		
	if input_vector.y:
		velocity_direction.y = input_vector.y
		
	velocity_direction = velocity_direction.normalized()
	
	velocity = velocity.move_toward(velocity_direction * speed, acceleration * delta)
	
func apply_friction(input_vector, delta):
	if input_vector.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if input_vector.y == 0.0:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
		
func update_animations(input_vector):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x:
		sprite_2d.flip_h = mouse_direction.x < 0
	
	if input_vector != Vector2.ZERO:
		animation_player.play("run")
	else:
		animation_player.play("idle")
		
func update_weapon():
	var mouse_direction: Vector2 = (get_global_mouse_position() - sword.global_position).normalized()
	sword.rotation = mouse_direction.angle()
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	if sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
func process_attack():
	if (sword_animation_player.current_animation != "attack"):
		sword_animation_player.play("attack")
		await sword_animation_player.animation_finished
		sword_animation_player.play("idle")
		state = NO_ACTION
