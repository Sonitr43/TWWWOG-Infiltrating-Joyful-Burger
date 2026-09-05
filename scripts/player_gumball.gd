class_name PlayerGumball
# Declarem l'escena de Darwin, que hereta la del jugador base, com a una classe.
extends PlayerBase
# Aquest script és una extensió del que té el node pare de l'escena del jugador base.

@onready var climb_timer: Timer = $ClimbTimer
# Carreguem el node del temporitzador de l'escalada. 
@onready var jump_sfx: AudioStreamPlayer = $JumpSFX
# Carreguem el node de l'audio de l'efecte de so de saltar.

enum State {IDLE, WALK, RUN, JUMP, FALL, DOWN, CLIMB}
# Utilitzant el tipus de dada "enum", guardem diverses constants consecutives que representen
# els estats en els quals el personatge pot estar. Cada estat té un int associat (0, 1, 2,...)
var current_state: State = State.IDLE
# Creem una variable per a l'estat actual en què es pugui trobar el jugador, i per defecte
# el deixem en l'inactiu.

# VARIABLES PER ESCALAR
var alreadyClimbed = false
# Bool que determina si ja hem escalat. 
var climbing = false
# Bool que dtermina si estem escalant.

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
		jump_sfx.play()
		# Reproduïm l'efecte de so de saltar.
		velocity.y = jump
		# Saltem.
		current_state = State.JUMP
		# Canviem l'estat al de saltar.
		jump_buffer_timer.stop()
		# Parem el temporitzador del salt.
		coyote_timer.stop()
		# Parem el temporitzador coyote.
		
	if "WaterTop" in get_tile_data():
	# Si el jugador intenta entrar en aigua:
		velocity.y = jump
		# Saltem per evitar que entri.
		current_state = State.JUMP
		# Canviem l'estat al de saltar.
	
	# ESCALAR PARETS + GRAVETAT
	var wants_to_climb = (
		is_on_wall_only()
		&& Input.is_action_pressed("run")
		&& Input.is_action_pressed("move_up")
		&& not alreadyClimbed
		&& not Input.is_action_pressed("move_down")
	)
	# Variable del tipus bool amb les condicions per a començar l'escalada (només es detecta un cop).
	
	if wants_to_climb && not climbing:
	# Si volem començar l'escalada i el joc no detecta que estem escalant:
		climb_timer.start()
		# Començem el temporitzador de l'escalada.
		current_state = State.CLIMB
		# Canviem l'estat al d'escalar.
		climbing = true
		# Declarem que ja estem escalant.
		
	if climbing:
	# Si estem escalant:
		velocity.y = jump/4
		# Augmentem progresivament la nostra posició en l'eix vertical.
		if Input.is_action_just_released("run") or Input.is_action_just_released("move_up") or not is_on_wall():
		# Si deixem de córrer, o de pulsar el botó d'amunt, o ja no estem en una paret: 
			climb_timer.stop()
			# Detenim el temporitzador d'escalar.
			alreadyClimbed = true
			# Declarem que ja hem escalat.
			climbing = false
			# Declarem que ja no estem escalant.
			current_state = State.FALL
			# Canviem l'estat al de caure.
			
	if alreadyClimbed == true and is_on_floor():
	# Si ja hem escalat i estem al terra:
		alreadyClimbed = false
		# Reiniciem la variable que detecta si ja hem escalat.
		
	if current_state == State.JUMP:
	# Si l'estat actual és el del salt:
		velocity.y += gravity * delta
		# Li donem gravetat a la velocitat vertical.
	else:
	# Sinó (si estem caient):
		velocity.y += gravity * down_gravity_factor * delta
		# Fem la gravetat més forta. 
		
	# VARIAR L'ALÇÀRIA DEL SALT
	if velocity.y < 0.0:
	# Si la velocitat vertical és major a 0 (el jugador no està caient):
		if Input.is_action_just_released("jump"):
		# Y si el jugador deixa anar el botó de saltar:
			velocity.y *= 0.5
			# Li dividim la velocitat vertical per la meitat.
			# Això serveix per poder fer un salt amb una alçada variable.
	
func _on_climb_timer_timeout() -> void:
# Funció per a detectar quan s'acaba el temporitzador de l'escalada.
	if climbing:
	# Si estem escalant:
		alreadyClimbed = true
		# Declarem que ja hem escalat.
		climbing = false
		# Declarem que ja no estem escalant.
		current_state = State.FALL
		# Canviem l'estat al de caure.
	
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
		
		State.CLIMB when is_on_floor():
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
		State.CLIMB: animated_sprite.play("run")
