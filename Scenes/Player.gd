extends CharacterBody2D


@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -200.0
@export var double_jump_velocity: float = -150
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped: bool = false
var is_locked = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			has_double_jumped = false
			jump()
			
			if was_in_air == true:
				land()
				
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true

			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", 'up', 'down')
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	update_animation()
	change_direction()
	


func update_animation():
	if not is_locked:
		if direction.x != 0:
			animated_sprite.play('run')
		else:
			animated_sprite.play("idle")
		
		if direction.y > 0:
			animated_sprite.play('jump start')

func change_direction():
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false


func jump():
	velocity.y += direction.y
	animated_sprite.play('jump_start')
	is_locked = true
func land():
	animated_sprite.play("jumo_Pend")
	is_locked = true
	pass
