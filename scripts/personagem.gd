extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var textura: AnimatedSprite2D = $animação

func _ready() -> void:
	textura.animation_finished.connect(_on_ataque_finalizado)
	textura.animation_changed.connect(_on_anim_changed)

func _physics_process(delta: float) -> void:
	aplicar_gravidade(delta)
	tratar_input_movimento(delta)
	move_and_slide()



func _process(delta: float) -> void:
	checar_morte()
	if Input.is_action_just_pressed("ataque"):
		atacar()
	print("animation:", textura.animation)   # <<< aqui!


func aplicar_gravidade(delta: float) -> void:
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta



func tratar_input_movimento(delta: float) -> void:
	
	if textura.animation == "atacar":
		print("n ta pulando por isso")
		return
	# Pulo
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var dir := Input.get_axis("ui_left", "ui_right")

	if dir != 0:
		velocity.x = dir * SPEED
		textura.scale.x = dir
		if is_on_floor() and textura.animation != "atacar":
			textura.play("correr")
	else:
		# Desaceleração suave
		velocity.x = move_toward(velocity.x, 0, 800 * delta)
		if is_on_floor() and textura.animation != "atacar":
			textura.play("parado")

	# DEBUG opcional
	print("Eixo: ", dir)

func checar_morte() -> void:
	# Se cair abaixo de certo Y, “reset” de posição
	if position.y > 350:
		position = Vector2(13, 304)


func atacar() -> void:
	if is_on_floor() and textura.animation != "atacar":
		textura.play("atacar")


 
func _on_ataque_finalizado() -> void:
	# só volto pro "parado" se a animação atual for mesmo "atacar"
	if textura.animation == "atacar":
		textura.play("parado")



func _on_anim_changed() -> void:
	# checa diretamente a propriedade textura.animation
	
	if textura.animation == "atacar":
		textura.position = Vector2(0, -20)
	else:
		textura.position = Vector2(0,-10)
