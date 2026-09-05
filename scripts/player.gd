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
@onready var death: Node2D = get_tree().root.find_child("Death", true, false)
# Carreguem en una variable l'escena de quan el jugador mor.
@onready var hud: CanvasLayer = get_tree().root.find_child("HUD", true, false)
# Carreguem en una variable l'escena del HUD.
@onready var damage_area: Area2D = $DamageArea
# Carreguem el node de l'Area2D que detecta si el jugador rep dany.
@onready var damage_sfx: AudioStreamPlayer = $DamageSFX
# Carreguem el node de l'audio de quan el jugador rep dany.
@onready var camera_2d: Camera2D = $Camera2D
# Carreguem el node de la càmera del personatge.

var canTakeDamage = true
# Variable per saber si el jugador por rebre dany.
var invincible_time: float = 3.0
# Variable per emmagatzemar el temps que el jugador tindrà invencibilitat quan rebi dany.
var flickering: bool = false
# Variable per determinar si l'sprite del jugador està parpellejant.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren a l'arbre d'escenes.
	# CHECKPOINTS
	if GameManager.checkpoint_pos != Vector2(-999, -999):
	# Si la posició en la qual volem que el jugador aparegui no coincideix amb la predeterminada (és
	# a dir, el jugador ha activat un checkpoint):
		global_position = GameManager.checkpoint_pos
		# Igualem la posició global del jugador amb la posició en la qual volem que el jugador aparegui.
		camera_2d.position_smoothing_enabled = false
		await get_tree().create_timer(0.2).timeout
		camera_2d.position_smoothing_enabled = true
		# Fem que la càmera del jugador es mogui immediatament cap a ell desactivant "position_smoothing_enabled"
		# per 0.2 segons per si ha tocat un checkpoint, així es posiciona amunt d'ell.

func _physics_process(delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per
# a les físiques.
	# Utilitzant el node de mort, obtenim, des de l'script del node, el valor de la variable que determina si el
	# jugador ha mort o no.
	if GameManager.shouldMove and not GameManager.level_beaten:
	# Per evitar que el jugador es pugui moure quan ha mort o s'ha passat un nivell, col·loquem la resta del codi
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
	
	if "Spike" in get_tile_data():
	# Si la tile la qual el jugador està tocant és del tipus "Spike" (punxes):
		get_damage()
		# El jugador rep dany.

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

func get_damage() -> void:
# Funció que s'executa quan el jugador és atacat per un enemic.
	if !canTakeDamage:
	# Si el jugador no pot rebre dany:
		return
		# Retornem per evitar que el jugador rebi dany constantment.
	
	canTakeDamage = false
	# Declarem que el jugador no pot rebre dany.
	damage_area.monitoring = false
	# Deixem de monitorejar l'àrea que detecta si el jugador rep dany.
	GameManager.health -= 1
	# Li restem 1 a la salut del jugador.
	if GameManager.health > 0:
		# Si el jugador no s'ha quedat sense vida:
		# Li treiem 1 punt de vida.
		flicker_sprite()
		# Cridem la funció que fa parpellejar l'sprite del jugador.
		damage_sfx.play()
		# Reproduïm l'efecte de so de rebre dany.
	else:
	# Sinó:
		death.playerDies()
		# Cridem la funció dins de l'escena de mort per matar el jugador.
		animated_sprite.visible = false
		# Fem invisible l'sprite del personatge.
		return
		
	await get_tree().create_timer(invincible_time).timeout
	# Creem un temporitzador amb el temps d'invencibilitat i esperem a que s'acabi.
	damage_area.monitoring = true
	# Tornem a monitorejar l'àrea que detecta si el jugador rep dany.
	canTakeDamage = true
	# Declarem que el jugador ja pot rebre dany.

func flicker_sprite():
# Funció per fer parpellejar l'sprite del jugador.
	if flickering:
	# Si l'sprite de jugador està parpellejant:
		return
		# Sortim de la funció (si el jugador ja estava parpellejant, evitem que
		# entri en diversos estats de parpelleig).

	flickering = true
	# Determinem que el jugador està parpellejant.
	var time_taken: float = 0.0
	# Variable pel temps transcorregut parpellejant.

	while time_taken < (invincible_time - 0.1):
	# Mentres que time_taken sigui menor al temps d'invencibilitat:
	# (Li treiem 0.1 al temps per evitar que no es torni a executar la funció si el jugador
	# rep dany constant).
		animated_sprite.visible = not animated_sprite.visible
		# Canviem el valor de la variable que determina si l'sprite és visible.
		await get_tree().create_timer(0.1).timeout
		# Creem un timer de 0.1 segons i esperem a que s'acabi.
		time_taken += 0.1
		# Sumem 0.1 al temps transcorregut.

	animated_sprite.visible = true
	# Forcem l'sprite del jugador com a visible.
	flickering = false
	# Declarem que ja no estem parpellejant.
