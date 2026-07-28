extends CharacterBody2D

@export var speed: int = 125
@export var max_speed: float = speed * 1.5
@export var jump: int = -325
@export var gravity: int = speed*8
@export var down_gravity_factor: float = 1.1
@export var acceleration: float = 7.5
# Utilitzem "export" per poder modificar els valors d'aquestes variables des de la pestanya
# "Inspector" de Godot.

@onready var kill_zone: Area2D = %KillZone
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

enum State {IDLE, WALK, RUN, JUMP, FALL, DOWN, BRAKE}
# Utilitzant el tipus de dada "enum", guardem diverses constants consecutives que representen
# els estats en els quals el personatge pot estar. Cada estat té un int associat (0, 1, 2,...)
var current_state: State = State.IDLE
# Creem una variable per a l'estat actual en què es pugui trobar el jugador, i per defecte
# el deixem en l'inactiu.

func _physics_process(delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per
# a les físiques.
	var isDead = kill_zone.isDead
	# Utilitzant el node de mort, obtenim, des de l'script del node, el valor de la variable que determina si el
	# jugador ha mort o no.
	if not isDead:
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
		
func update_movement(delta: float) -> void:
	# AJUPIR-SE
	if is_on_floor() && Input.is_action_pressed("move_down"):
	# Si el jugador està al terra i pulsa el botó d'apujir-se:
		current_state = State.DOWN
		# Canviem l'estat al d'ajupir-se.
		if not Input.is_action_pressed("run"):
		# Si el jugador no està corrent:
			velocity.x = move_toward(velocity.x, 0, acceleration*1.3)
			# Deixem d'actualitzar la seva posició X suaument.
		else:
		# Però si el jugador sí està corrent:
			velocity.x = move_toward(velocity.x, 0, acceleration*2.4)
			# Desaccelerem més lentament.
		
	# SALTAR
	if (is_on_floor() || coyote_timer.time_left > 0) && jump_buffer_timer.time_left > 0:
	# Si el jugador està al terra (o el temporitzador coyote no s'ha acabat) i el temporitzador del salt no s'ha acabat:
		velocity.y = jump
		# Saltem.
		current_state = State.JUMP
		# Canviem l'estat al de saltar.
		jump_buffer_timer.stop()
		# Parem el temporitzador del salt.
		coyote_timer.stop()
		# Parem el temporitzador coyote.
		
	# VARIAR L'ALÇÀRIA DEL SALT
	elif velocity.y < 0.0:
	# Si la velocitat vertical és major a 0 (el jugador no està caient):
		if Input.is_action_just_released("jump"):
		# Y si el jugador deixa anar el botó de saltar:
			velocity.y *= 0.5
			# Li dividim la velocitat vertical per la meitat.
			# Això serveix per poder fer un salt amb una alçada variable.
	
	# AFEGIR GRAVETAT AL SALT
	if current_state == State.JUMP:
	# Si l'estat actual és el del salt:
		velocity.y += gravity * delta
		# Li donem gravetat a la velocitat vertical.
	else:
	# Sinó (si estem caient):
		velocity.y += gravity * down_gravity_factor * delta
		# Fem la gravetat més forta.
		
func update_states() -> void:
# Funció per manejar les canvis d'estat del jugador.
	var running: bool = Input.is_action_pressed("run")
	# Guardem en un bool si el jugador està corrent o no.
	match current_state:
	# Comparem l'estat actual en què es trova el personatge i el canviem a un d'altre si una de les
	# següents condicions es compleix.
	
		State.IDLE when velocity.x != 0:
		# Si estem quiets i la velocitat horitzontal canvia de 0:
			current_state = State.WALK
			# Canviem l'estat al de caminar.
			
		State.WALK when running:
		# Si estem caminant i premem el botó de córrer:
			current_state = State.RUN
			# Canviem a l'estat de córrer.
			
		State.WALK:
		# Dins de l'estat de caminar, hi ha 2 escenaris:
			if velocity.x == 0:
			# Si la velocitat horitzontal es torna 0:
				current_state = State.IDLE
				# Canviem a l'estat inactiu.
			if not is_on_floor() && velocity.y > 0:
			# Si caiem d'una plataforma sense saltar:
				current_state = State.FALL
				# Canviem a l'estat de caure.
				coyote_timer.start()
				# Comencem el temporitzador coyote.
		
		State.RUN:
		# Dins de l'estat de córrer:
			if not running && velocity.x != 0:
			# Si estem corrent i deixem anar el botó de córrer i no estem quiets:
				current_state = State.WALK
				# Canviem a l'estat de caminar.
			if not is_on_floor() && velocity.y > 0:
			# Si caiem d'una plataforma sense saltar:
				current_state = State.FALL
				# Canviem l'estat al de caure.
				coyote_timer.start()
				# Comencem el temporitzador coyote.
			if running && velocity.x == 0:
			# Si tenim pres el botó de córrer i ens detenim:
				current_state = State.IDLE
				# Canviem a l'estat inactiu.
				
		State.JUMP when velocity.y > 0:
		# Si estem en l'estat del salt i la velocitat vertical es fa menor de 0:
			current_state = State.FALL
			# Canviem a l'estat de caure.
		# (Quan saltem, la Y és negativa. Quan caiem, es fa positiva)
		
		State.FALL when is_on_floor():
		# Si estem en l'estat de caure i arribem al terra:
			if velocity.x == 0:
			# Si no ens estem movent:
				current_state = State.IDLE
				# Canviem a l'estat inactiu.
			else:
			# Sinó:
				if running:
				# Si el botó de córrer està pres:
					current_state = State.RUN
					# Canviem a l'estat de córrer.
				else:
				# Sinó està pres:
					current_state = State.WALK
					# Canviem a l'estat de caminar.
					
		State.DOWN when Input.is_action_just_released("move_down"):
			if velocity.x == 0:
				current_state = State.IDLE
			else:
				if running:
					current_state = State.RUN
				else:
					current_state = State.WALK
		
		State.BRAKE:
		# Dins de l'estat de frenar:
			if velocity.x == 0:
			# Si ens detenim:
				current_state = State.IDLE
				# Pasem a l'estat inactiu.
			else:
			# Sinó:
				if running:
				# Si seguim corrent:
					current_state = State.RUN
					# Tornem a l'estat de córrer.
				else:
				# Sinó:
					current_state = State.WALK
					# Canviem a l'estat de caminar.
		
func update_animations() -> void:
# Funció per a reproduir les animacions del personatge.
	var current_frame_run = animated_sprite.get_frame()
	var current_progress_run = animated_sprite.get_frame_progress()
	var current_frame_walk = animated_sprite.get_frame()
	var current_progress_walk = animated_sprite.get_frame_progress()
	# Utilitzarem aquestes variables per poder sincronitzar animacions.
		
	match current_state:
	# Comparem l'estat actual en què es trova el personatge.
	# Depenent de l'estat en què es trobi, reprodueix una animació o una altra.
		State.IDLE: animated_sprite.play("idle")
		State.WALK:
		# Dins de l'estat de caminar:
			animated_sprite.play("walk")
			# Reproduïm l'animació de caminar.
			if Input.is_action_just_released("run"):
			# Si estàvem corrent:
				animated_sprite.set_frame_and_progress(current_frame_run, current_progress_run)
				# Sincronitzem l'animació de caminar amb la prèvia.
		State.RUN:
		# Dins de l'estat de caminar:
			if abs(velocity.x) >= max_speed:
			# Si alcanzem la velocitat màxima (sense importar el sentit en el què ens trovem):
				animated_sprite.play("run")
				# Reproduïm l'animació de córrer.
			else:
			# Sinó:
				animated_sprite.play("pre-run")
				# Reproduïm la animació de caminar però accelerada.
				animated_sprite.set_frame_and_progress(current_frame_walk, current_progress_walk)
				# Sincronitzem l'animació amb la prèvia.
		State.JUMP: animated_sprite.play("jump")
		State.FALL: animated_sprite.play("fall")
		State.DOWN: animated_sprite.play("idle")
		State.BRAKE: animated_sprite.play("brake")
