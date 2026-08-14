class_name PlayerBase
# Declarem l'escena del jugador base com a una classe.
extends CharacterBody2D

@export var speed: int = 125
@export var max_speed: float = speed * 1.5
@export var jump: float = -325.0
@export var gravity: int = speed*8
@export var down_gravity_factor: float = 1.1
@export var acceleration: float = 7.5
# Utilitzem "export" per poder modificar els valors d'aquestes variables des de la pestanya
# "Inspector" de Godot.

@onready var kill_zone: Area2D = $"../Level/Boundaries/KillZone"
# Carreguem el node de quan el jugador mor.
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Carreguem el node de les animacions del jugador.
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
# Carreguem el node del temporitzador del salt.
@onready var coyote_timer: Timer = $CoyoteTimer
# Carreguem el node del temporitzador coyote. Aquest temporitzador és per a poder saltar després de caure
# d'una plataforma dins un petit marge de temps.
@onready var fall_ground_timer: Timer = $FallGroundTimer
# Carreguem el node del temporitzador per a caure a través de terra del tipus "one way".

func _physics_process(delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per
# a les físiques.
	# Utilitzant el node de mort, obtenim, des de l'script del node, el valor de la variable que determina si el
	# jugador ha mort o no.
	if not GameManager.isDead:
	# Per evitar que el jugador es pugui moure quan ha mort, col·loquem la resta del codi
	# dins d'aquest condicional.
		handle_input()
		update_movement(delta)
		update_states()
		update_animations()
		# Executem totes les funcions una darrere l'altra.
		move_and_slide()
		# Aquest mètode està dins de la classe "CharacterBody2D", és a dir, la del jugador.
		# Serveix per manejar lliscaments.

func handle_input() -> void:
# Funció per a manejar l'input del jugador i moure el personatge.
	var direction := Input.get_axis("move_left", "move_right")
	# Obtenim la direcció del jugador: -1 (esquerra), 1 (dreta), 0 (no es prema res)
	
	if Input.is_action_just_pressed("jump"):
	# Si el jugador prema el botó de saltar i està al terra:
		jump_buffer_timer.start()
		# Comencem el temporitzador del salt.
	
	# CAPGIRAR L'SPRITE
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
	
	# MOVIMENT HORITZONTAL
	if direction:
	# Si el jugador es mou:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration)
		# Actualitzem la seva posició X i l'afegim acceleració.
	if direction && Input.is_action_pressed("run"):
	# Si el jugador es mou i està pulsant el botó de córrer:
		velocity.x = move_toward(velocity.x, max_speed * direction, acceleration*1.1)
		# Actualitzem la seva posició X i augmentem la seva velocitat una mica més lentament.
	if not is_on_floor() and not direction:
	# Si el jugador no està al terra i no s'està movent:
		return
		# La seva velocitat es queda igual.
	if not direction:
	# Si el jugador no s'està movent:
		velocity.x = move_toward(velocity.x, 0, acceleration*1.5)
		# Deixem d'actualitzar la seva posició X suaument.
	
	# CAURE D'UN TERRA DEL TIPUS "ONE WAY"
	if velocity.x == 0 && Input.is_action_just_pressed("move_down"):
	# Si no ens estem movent i premem el botó per mirar abaix:
		fall_ground_timer.start()
		# Comencem el temporitzador per a caure.
	if fall_ground_timer.time_left <= 0.05 and fall_ground_timer.time_left >= 0.01 && Input.is_action_pressed("move_down"):
	# Si el temps restant del temporitzador es trova entre 0.05 i 0.01 i el jugador encara està prement el botó d'abaix:
	# (Com que els temporitzadors quan encara no estan iniciats tenen un valor de 0.0, no podem fer servir "fall_ground_timer.timeout"
	# perquè abans d'iniciar el temporitzador ja seria cert el bool, per tant no funcionaria la lògica)
		set_collision_mask_value(10, false)
		# Desactivem la Collision Mask (màscara de col·lisió) del terra del tipus "one way" perquè el jugador pugui atravesar-ho.
	if fall_ground_timer.is_stopped():
	# Si s'acava el temporitzador:
		set_collision_mask_value(10, true)
		# Reactivem la màscara de col·lisió del terra.
		
func update_movement(_delta: float) -> void:	
	pass
		
func update_states() -> void:
# Funció per manejar les canvis d'estat del jugador.
	pass
		
func update_animations() -> void:
# Funció per a reproduir les animacions del personatge.
	pass
