# Script pel personatge Darwin.

class_name PlayerDarwin
# Declarem l'escena de Darwin, que hereta la del jugador base, com a una classe.
extends PlayerBase
# Aquest script és una extensió del que té el node pare de l'escena del jugador base.

enum State {IDLE, WALK, RUN, JUMP, FALL, DOWN, SWIM_IDLE, SWIM_JUMP, SWIM_FALL, SWIM_WALK}
# Utilitzant el tipus de dada "enum", guardem diverses constants consecutives que representen
# els estats en els quals el personatge pot estar. Cada estat té un int associat (0, 1, 2,...)
var current_state: State = State.IDLE
# Creem una variable per a l'estat actual en què es pugui trobar el jugador, i per defecte
# el deixem en l'inactiu.

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
	if "Water" in get_tile_data() && Input.is_action_just_pressed("jump"):
	# Si estem sota l'aigua i saltem:
		velocity.y = jump_water
		# Nedem.
		current_state = State.SWIM_JUMP
		# Canviem a l'estat de saltar sota l'aigua.
	
	if "WaterTop" in get_tile_data() && Input.is_action_just_pressed("jump") || (is_on_floor() || coyote_timer.time_left > 0) && jump_buffer_timer.time_left > 0:
	# Si el jugador està sortint de l'aigua, o està al terra (o el temporitzador coyote no s'ha acabat) i el temporitzador del salt no s'ha acabat:
		velocity.y = jump
		# Saltem.
		current_state = State.JUMP
		# Canviem l'estat al de saltar.
		jump_buffer_timer.stop()
		# Parem el temporitzador del salt.
		coyote_timer.stop()
		# Parem el temporitzador coyote.
		
	# VARIAR L'ALÇÀRIA DEL SALT
	elif velocity.y < 0.0 && not "Water" in get_tile_data():
	# Si la velocitat vertical és major a 0 (el jugador no està caient), i no està nedant:
		if Input.is_action_just_released("jump"):
		# I si el jugador deixa anar el botó de saltar:
			velocity.y *= 0.5
			# Li dividim la velocitat vertical per la meitat.
			# Això serveix per poder fer un salt amb una alçada variable.
	
	# VARIAR LA GRAVETAT
	if not "Water" in get_tile_data():
	# Si no estem nedant:
		velocity.y += gravity * delta
		# Li donem gravetat a la velocitat vertical.
	else:
	# Sinó:
		velocity.y += gravity_water * delta
		# Fem la gravetat menor.
	
	if "WaterTop" in get_tile_data():
	# Si just hem entrat a l'aigua:
		if current_state == State.FALL:
		# Si estem en l'estat de caure:
			velocity.y *= 0.25
			# Dividim per 4 la velocitat vertical.
		if current_state == State.DOWN:
		# Si estem en l'estat d'ajupir-se:
			Input.action_release("move_down")
			# Deixem anar el botó d'abaix.
			velocity.y *= 0.25
			# Dividim per 4 la velocitat vertical.
			current_state = State.SWIM_FALL
			# Canviem a l'estat de caure sota l'aigua.
			
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
			
		State.SWIM_IDLE when velocity.x != 0:
		# Si estem quiets sota l'aigua i la velocitat horitzontal canvia de 0:
			current_state = State.SWIM_WALK
			# Canviem l'estat al de caminar submarí.
			
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
				
		State.SWIM_WALK when velocity.x == 0:
		# Dins de l'estat de caminar submarí, si la velocitat horitzontal es torna 0:
			current_state = State.SWIM_IDLE
			# Canviem a l'estat inactiu submarí.
		
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
		
		State.SWIM_JUMP when velocity.y > 0:
		# Si estem en l'estat del salt submarí i la velocitat vertical es fa menor de 0:
			current_state = State.SWIM_FALL
			# Canviem a l'estat de caure submarí.
		
		State.FALL:
		# Si estem en l'estat de caure 
			if is_on_floor():
			# Si arribem al terra:
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
			if "Water" in get_tile_data():
			# Si estem en l'aigua:
				current_state = State.SWIM_FALL
				# Canviem a l'estat de caure sota l'aigua.
				
		State.SWIM_FALL:
		# Si estem en l'estat de caure sota l'aigua:
			if is_on_floor():
			# Si estem al terra:
				if velocity.x == 0:
				# Si ens quedem quiets:
					current_state = State.SWIM_IDLE
					# Canviem a l'estat inactiu submarí.
				else:
				# Sinó:
					current_state = State.SWIM_WALK
					# Canviem a l'estat de caminar submarí.
					
		State.DOWN when Input.is_action_just_released("move_down"):
		# Si estem en l'estad d'ajupir-se i hem deixat anar el botó d'abaix:
			if velocity.x == 0:
			# Si estem quiets:
				current_state = State.IDLE
				# Canviem a l'estat inactiu.
			else:
			# Sinó:
				if running:
				# Si estem corrent:
					current_state = State.RUN
					# Canviem a l'estat de córrer.
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
		State.SWIM_IDLE: animated_sprite.play("idle")
		State.SWIM_JUMP: animated_sprite.play("jump")
		State.SWIM_FALL: animated_sprite.play("fall")
		State.SWIM_WALK: animated_sprite.play("walk_water")
