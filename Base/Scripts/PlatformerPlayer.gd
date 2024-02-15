extends CharacterBody2D

@export var movement_data : PlatformerPlayerMovementData

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jump = false
var just_wall_jumped = false
var last_wall_normal = Vector2.ZERO

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var coyote_wall_jump_timer = $CoyoteWallJumpTimer
@onready var starting_position = global_position


func _physics_process(delta):
	apply_gravity(delta)
	process_wall_jump()
	process_jump()
	var input_horizontal = Input.get_axis("move_left", "move_right")	
	process_movement(input_horizontal, delta)
	apply_friction(input_horizontal, delta)
	apply_air_resistance(input_horizontal, delta)

	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		last_wall_normal = get_wall_normal()
		
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0.0
	if just_left_ledge:
		coyote_jump_timer.start()
		
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		coyote_wall_jump_timer.start()
		
	just_wall_jumped = false
	
	update_animations(input_horizontal)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta
		if (is_on_wall_only() and velocity.y > 0.0):
			velocity.y -= movement_data.wall_slide_drag * delta
		
func process_jump():
	if is_on_floor() : air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
			coyote_jump_timer.stop()
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("jump") and air_jump and not just_wall_jumped:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false
			
func process_wall_jump():
	if not is_on_wall_only() and coyote_wall_jump_timer.time_left <= 0.0: return
	
	var wall_normal = get_wall_normal()
	if coyote_wall_jump_timer.time_left > 0.0:
		wall_normal = last_wall_normal
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		just_wall_jumped = true
		coyote_wall_jump_timer.stop()
			
func process_movement(input_horizontal, delta):
	if is_on_floor():
		if input_horizontal:
			velocity.x = move_toward(velocity.x, movement_data.speed * input_horizontal, movement_data.acceleration * delta)
	else:
		if input_horizontal:
			velocity.x = move_toward(velocity.x, movement_data.speed * input_horizontal, movement_data.air_acceleration * delta)
			
func apply_friction(input_horizontal, delta):
	if input_horizontal == 0.0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		
func apply_air_resistance(input_horizontal, delta):
	if input_horizontal == 0.0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func update_animations(input_horizontal):	
	if input_horizontal:
		animated_sprite_2d.flip_h = input_horizontal < 0
	
	if (is_on_floor()):
		if input_horizontal:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	elif (is_on_wall_only()):
		animated_sprite_2d.play("wall_slide")
	else:
		if (velocity.y < 0.0):
			animated_sprite_2d.play("jump_up")
		else:
			animated_sprite_2d.play("jump_down")


func _on_hurtbox_area_entered(_area):
	global_position = starting_position
