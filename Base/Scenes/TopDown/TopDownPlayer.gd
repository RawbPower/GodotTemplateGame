extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 800.0
@export var friction = 1000.0

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	pass
	
func _physics_process(delta):
	var input_horizontal = Input.get_axis("move_left", "move_right")
	var input_vertical = Input.get_axis("move_up", "move_down")
	process_movement(input_horizontal, input_vertical, delta)
	apply_friction(input_horizontal, input_vertical, delta)
	
	#move_and_collide(velocity * delta)
	move_and_slide()
	
	update_animations(input_horizontal, input_vertical)
	
func process_movement(input_horizontal, input_vertical, delta):
	var velocity_direction = Vector2.ZERO
	if input_horizontal:
		velocity_direction.x = input_horizontal
		
	if input_vertical:
		velocity_direction.y = input_vertical
		
	velocity_direction = velocity_direction.normalized()
	
	velocity = velocity.move_toward(velocity_direction * speed, acceleration * delta)
	
func apply_friction(input_horizontal, input_vertical, delta):
	if input_horizontal == 0.0:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if input_vertical == 0.0:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
		
func update_animations(input_horizontal, input_vertical):	
	if input_horizontal:
		animated_sprite_2d.flip_h = input_horizontal < 0
	
	if input_horizontal || input_vertical:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
