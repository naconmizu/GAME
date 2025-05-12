extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var jump := true

@onready var textura := $animation as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		textura.play("pular")

	# Handle jump.
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		textura.play("agachar")
		
	if Input.is_action_just_pressed("ui_right"):
		textura.play("atacar")
			
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * (SPEED+10)
		textura.play("correr")
		textura.scale.x = direction
		if !jump:
			textura.play("correr")
		elif is_on_floor():
			jump = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		textura.play("parado")

	move_and_slide()
