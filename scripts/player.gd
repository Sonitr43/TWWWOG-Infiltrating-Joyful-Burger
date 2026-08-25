class_name PlayerBase
# Declarem l'escena del jugador base com a una classe.
extends CharacterBody2D

@export var speed: int = 125
@export var swim_speed: float = speed*0.6
@export var max_speed: float = speed * 1.5
@export var jump: float = -325.0
@export var jump_water: float = jump/4
@export var gravity: int = speed*8
@export var gravity_water: float = speed*1.1
@export var down_gravity_factor: float = 1.1
@export var acceleration: float = 7.5
# Utilitzem "export" per poder modificar els valors d'aquestes variables des de la pestanya
# "Inspector" de Godot.

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Carreguem el node de les animacions del jugador.
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
# Carreguem el node del temporitzador del salt.
@onready var coyote_timer: Timer = $CoyoteTimer
# Carreguem el node del temporitzador coyote. Aquest temporitzador és per a poder saltar després de caure
# d'una plataforma dins un petit marge de temps.
@onready var fall_ground_timer: Timer = $FallGroundTimer
# Carreguem el node del temporitzador per a caure a través de terra del tipus "one way".

@onready var tileMap: TileMapLayer = get_tree().root.find_child("Foreground", true, false)
# Amb una variable, fem referència al node TileMapLayer de les tiles exteriors (foreground).
# Obtenim el node arrel de l'arbre de l'escena, i després amb find_child() busquem el TileMapLayer.
# El segon paràmetre de find_child() indica que volem que la recerca sigui recursiva (busca en
# descendents), i el tercer paràmetre indica que no volem que la recerca es limiti a nodes "owned" del
# node actual; busca normalment en l'arbre sense restringir-ho a ownership.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren a l'arbre d'escenes.
	# CHECKPOINTS
	if GameManager.checkpoint_pos != Vector2(-999, -999):
	# Si la posició en la qual volem que el jugador aparegui no coincideix amb la predeterminada (és
	# a dir, el jugador ha activat un checkpoint):
		global_position = GameManager.checkpoint_pos
		# Igualem la posició global del jugador amb la posició en la qual volem que el jugador aparegui.

func _physics_process(delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per
# a les físiques.
	# Utilitzant el node de mort, obtenim, des de l'script del node, el valor de la variable que determina si el
	# jugador ha mort o no.
	if GameManager.shouldMove:
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
	else:
		velocity.x = 0
		animated_sprite.play("idle")
		# Per evitar bugs amb les animacions, fem que el jugador executi l'animació d'estat inactiu,
		# per si ha activat un diàleg mentre es movia.

func handle_input() -> void:
# Funció per a manejar l'input del jugador i moure el personatge.
	var direction := Input.get_axis("move_left", "move_right")
	# Obtenim la direcció del jugador: -1 (esquerra), 1 (dreta), 0 (no es prema res)
	
	if Input.is_action_just_pressed("jump") && not "Water" in get_tile_data():
	# Si el jugador prema el botó de saltar i no està sota l'aigua:
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
		if "Water" in get_tile_data() && GameManager.PlayerCharacter == 1:
		# Si estem jugant com a Darwin i estem nedant:
			velocity.x = move_toward(velocity.x, swim_speed * direction, acceleration*0.5)
			# Ens movem més lentament.
		else:
		# Sinó (moviment normal):
			velocity.x = move_toward(velocity.x, speed * direction, acceleration)
			# Actualitzem la seva posició X i l'afegim acceleració.
	if direction && Input.is_action_pressed("run") && not "Water" in get_tile_data():
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
	
	# CAURE D'UN TERRA D'UN ÚNIC SENTIT
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
# Funció per actualitzar la posició del jugador.
	pass

func update_states() -> void:
# Funció per manejar les canvis d'estat del jugador.
	pass

func update_animations() -> void:
# Funció per a reproduir les animacions del personatge.
	pass

func get_tile_data(targetPosition = global_position):
# Funció que detecta el tipus de tile en la que el jugar està situat, i retorna una cadena depenent del "Type".
# El "Type" és per saber si la tile és "Water" (tile sota l'aigua) o "WaterTop" (tile per entrar/sortir de l'aigua).
# Té de paràmetre "targetPosition", el qual per defecte retorna la posició global del node del personatge.
	var tilePos = tileMap.local_to_map(targetPosition)
	# Amb una variable, convertim posició mon (Vector2) a coordenades de cel·la (grid) del tilemap (Vector2i).
	# "targetPosition" està en coordenades globals (Vector2), i les passem a Vector2i utilitzant local_to_map().
	# El resultat de la variable, per tant, es un Vector2i que identifica la cel·la del tilemap correspondent.
	var tileData: TileData = tileMap.get_cell_tile_data(tilePos)
	# Variable per obtenir informació de la tile TilePos, i només existirà (no serà null) si hi ha una tile.
	
	if tileData:
	# Si hi ha informació dins de TilePos:
		if tileData.get_custom_data("Type") != "":
		# Si el tipus de data és "Type" i no està buit:
			return tileData.get_custom_data("Type")
			# Retornem el tipus de data "Type".
			
	return ""
	# Si no existeix tileData, o Type està buit, retorna una cadena buida.
