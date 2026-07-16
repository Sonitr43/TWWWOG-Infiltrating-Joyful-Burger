extends CharacterBody2D

const SPEED = 125.0
const JUMP_VELOCITY = -300.0
# Definim constants per a la velocitat horitzontal i vertical del jugador.

@onready var kill_zone: Area2D = %KillZone
# Carreguem el node de quan el jugador mor.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Carreguem el node de les animacions del jugador.

func _physics_process(delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per
# a les físiques.
	var isDead = kill_zone.isDead
	# Utilitzant el node de mort, obtenim el valor de la variable que determina si el
	# jugador ha mort o no.
	if not isDead:
	# Si el jugador ha mort, col·loquem la resta del codi en aquest condicional per
	# evitar que el jugador es pugui moure.
		if not is_on_floor():
		# Si el jugador no està al terra:
			velocity += get_gravity() * delta
			# L'afegim gravetat al salt.

		if Input.is_action_just_pressed("jump") and is_on_floor():
		# Si el jugador prema el botó de saltar i està al terra:
			velocity.y = JUMP_VELOCITY
			# L'apliquem la velocitat vertical a l'eix Y al jugador.

		var direction := Input.get_axis("move_left", "move_right")
		# Obtenim la direcció del jugador: -1 (esquerra), 1 (dreta), 0 (no es prema res)
		
		# CAPGIRAR L'SPRITE
		if direction > 0:
			animated_sprite.flip_h = false
		if direction < 0:
			animated_sprite.flip_h = true
			
		# REPRODUIR ANIMACIONS
		if is_on_floor():
		# Animacions al terra.
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		else:
		# Animacions de salt.
			if velocity.y > 0:
			# Si el jugador just acaba de saltar:
				animated_sprite.play("jump")
			else:
			# Si el jugador està caient:
				animated_sprite.play("fall")
		
		if direction:
		# Si el jugador es mou:
			velocity.x = direction * SPEED
			# Actualitzem la seva posició X.
		else:
		# Sinó:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			# Deixem d'actualitzar la seva posició.

		move_and_slide()
