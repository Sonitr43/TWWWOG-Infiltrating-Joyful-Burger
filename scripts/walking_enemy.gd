# Script pels enemics que caminen.
extends CharacterBody2D

@export var speed: int = 45
# Creem una variable exportada per la velocitat de l'enemic.
@export var gravity: float = speed*16
# Creem una variable exportada per la gravetat de l'enemic.
@export var stay_on_platform: bool = true
# Creem una variable exportada per determinar si l'enemic cau de les plataformes.
@export var add_gravity: bool = true
# Creem una variable exportada per determinar si l'enemic té gravetat o no.
@export var collide: bool = true
# Creem una variable exportada per determinar si l'enemic col·lisiona amb parets i el terra o no.
@export var defeatable: bool = true
# Creem una variable exportada per determinar si l'enemic es pot matar o no.
var direction: int = -1
# Variable per determinar la direcció de l'enemic (1 = dreta, -1 = esquerra).
var notDead: bool = true
# Variable per saber si l'enemic està viu o no.
var player
var playerHitArea
# Creem una variable pel jugador buida, la qual carregarem dins de _ready().
var healthScene
var healthSceneSprite
# Creem variables pel cor i el seu sprite, el qual l'enemic pot deixar anar en morir.
var flip_sprite: int = 1
# Variable per girar l'sprite (1 = girar-lo, -1 = no girar-lo).
var flickering: bool = false
# Variable per determinar si l'sprite està parpellejant.
var preparingAttack: bool = false
# Variable per saber si l'enemic està preparant un atac o no (exclusiu de HotDog).
var damage_area_extended
# Creem una variable buida per l'àrea de dany extendida de HotDog.

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
# Importem els nodes de RayCast.
# Son uns raigs en l'espai que detecten si l'enemic ha col·lisionat amb una paret.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Importem el node dels sprites de l'enemic.
@onready var death_timer: Timer = $DeathTimer
# Importem el node del temporitzador per treure l'enemic quan mor.
@onready var hud_scene = get_tree().root.find_child("HUD", true, false)
# Busquem el node de l'escena del HUD dins de l'arbre d'escenes.
@onready var damage_area: Area2D = $DamageArea
# Importem l'Area2D de l'enemic que fa dany al jugador.
@onready var hit_area: Area2D = $HitArea
# Importem l'Area2D de l'enemic que el mata si el jugador la toca.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# Importem la CollisionShape2D de l'enemic.
@onready var stomp_sfx: AudioStreamPlayer = $StompSFX
# Importem l'àudio de l'efecte de so de mort de l'enemic.

func _ready() -> void:
	await get_tree().process_frame
	# Esperem que l'arbre d'escenes es carregui totalment.
	player = get_tree().root.find_child("Player", true, false)
	# Carreguem en aquesta variable el node del jugador.
	playerHitArea = player.get_tree().root.find_child("HitArea", true, false)
	# Carreguem en aquesta variable el node del HitArea del jugador.
	set_physics_process(true)
	# Fem que la funció "_physics_process()" es torni a executar per si l'enemic ha mort.
	if name.begins_with("HotDog"):
	# Si l'enemic és un HotDog:
		damage_area_extended = $DamageAreaExtended
		# Carreguem l'àrea de dany extendida.
	if !collide:
	# Si la variable "collide" és falsa:
		ray_cast_right.enabled = false
		ray_cast_left.enabled = false
		ray_cast_down_right.enabled = false
		ray_cast_down_left.enabled = false
		collision_shape_2d.disabled = true
		# Desactivem tots els RayCast i la col·lisió de l'enemic.
	if !defeatable:
	# Si la variable "defeatable" és falsa:
		hit_area.monitoring = false
		# Desactivem l'àrea que detecta si el jugador ha saltat amunt d'un enemic, per tant,
		# no es pot matar.

func _physics_process(delta: float) -> void:
# Funció que s'executa cada frame, dissenyada per les físiques.
	if !GameManager.level_beaten:
	# Si el jugador no s'ha passat el nivell encara:
		update_movement(delta)
		apply_gravity(delta)
		update_sprite()
		move_and_slide()
		# Executem tota la lògica de l'enemic.
	else:
	# Sinó:
		animated_sprite_2d.stop()
		# Detenim la seva animació + tot el seu moviment.

func _process(_delta: float) -> void:
# Funció que s'executa cada frame.
	if healthScene != null:
	# Si l'escena del cor existeix:
		if healthScene.isObtained:
			# Si el jugador ha obtingut el cor:
				await get_tree().create_timer(1).timeout
				# Creem un temporitzador de 2 segons i esperem a que acabi.
				queue_free()
				# Esborrem aquest node i els seus fills directament.
	
func update_movement(_delta: float) -> void:
# Funció per actualitzar el moviment dels enemics.
	if !preparingAttack:
	# Si l'enemic no està preparant un atac:
	# (Variable que s'aplica només a HotDog)
		if ray_cast_right.is_colliding():
		# Si el RayCast de la dreta ha col·lisionat:
			direction = -1
			flip_sprite = 1
			# Canviem la direcció de l'enemic perquè vagi a l'esquerra i el girem.
			if name.begins_with("HotDog"):
				damage_area_extended.get_child(0).position.x = -15
			
		elif ray_cast_left.is_colliding():
		# Si el RayCast de l'esquerra ha col·lisionat:
			direction = 1
			flip_sprite = -1
			# Canviem la direcció de l'enemic perquè vagi a la dreta i el girem.
			if name.begins_with("HotDog"):
				damage_area_extended.get_child(0).position.x = 15
		
		if stay_on_platform:
		# Si l'enemic pot caure de les plataformes:
			if direction == -1 and not ray_cast_down_left.is_colliding():
			# Si va cap a l'esquerra i el RayCast d'abaix de l'esquerra no detecta terra:
				direction = 1
				flip_sprite = -flip_sprite
				# Canviem la direcció de l'sprite i el girem.
			elif direction == 1 and not ray_cast_down_right.is_colliding():
			# Si va cap a la dreta i el RayCast d'abaix de la dreta no detecta terra:
				direction = -1
				flip_sprite = -flip_sprite
				# Canviem la direcció de l'sprite i el girem.
			
		if notDead:
		# Si l'enemic està viu:
			velocity.x = direction * speed
			# Actualitzem la posició de l'enemic.
	else:
	# Sinó:
		pass
		# No fem res (detenim el seu moviment).
		
func apply_gravity(delta: float) -> void:
# Funció per aplicar gravetat.
	if not is_on_floor() and add_gravity:
	# Si l'enemic no està al terra i volem que tingui gravetat:
		velocity.y += gravity * delta
		# Li afegim gravetat.

func update_sprite() -> void:
# Funció per girar l'sprite depenent del valor de "flip_sprite".
	if flip_sprite == -1:
		animated_sprite_2d.flip_h = true
	if flip_sprite == 1:
		animated_sprite_2d.flip_h = false

func _on_damage_area_area_entered(area: Area2D) -> void:
# Funció que s'executa quan el jugador entra en la DamageBox d'un enemic (és atacat).
	if area.is_in_group("PlayerDamageArea"):
		player.get_damage()
		# Cridem la funció del jugador quan és atacat.

var random = RandomNumberGenerator.new()
# En una variable, instanciem la classe "RandomNumberGenerator", la qual serveix per
# generar nombres aleatoris.

func _on_hit_area_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una àrea entra en l'àrea de dany de l'enemic.
	if area.is_in_group("PlayerHitArea"):
	# Si l'àrea està dins del grup de l'àrea d'atacar del jugador:
		if player.velocity.y > 0:
		# Si el jugador està caient:
			stomp_sfx.play()
			# Reproduïm l'efecte de so de mort de l'enemic.
			set_physics_process(false)
			# Fem que la funció "_physics_process()" ja no s'executi.
			damage_area.monitoring = false
			# Deixem de detectar si el jugador entra en l'àrea de l'enemic que el fa rebre
			# dany, així el jugador no és atacat quan derriva un enemic.
			notDead = false
			# Declarem que l'enemic ha mort.
			animated_sprite_2d.play("death")
			# Reproduïm l'animació de mort de l'enemic.
			GameManager.add_points(100)
			# Li sumem 100 punts al jugador.
			death_timer.start()
			# Comencem el temporitzador de mort.
			random = randi_range(0, 2)
			# Generem un nombre enter aleatori.

func _on_death_timer_timeout() -> void:
# Funció que s'executa quan el temporitzador de mort de l'enemic s'acava.
	if random == 2:
	# Si el nombre aleatori és 2:
		healthScene = load("res://scenes/level elements/heart.tscn").instantiate()
		# Carreguem l'escena dels cors que li donen 1 punt de salut al jugador i l'instanciem.
		add_child(healthScene)
		# Afegim el node a l'arbre d'escenes.
		animated_sprite_2d.visible = false
		# Amaguem l'sprite de l'enemic.
		hit_area.monitoring = false
		# Deixem de monitorar l'àrea de dany de l'enemic, fent que el jugador ja no pugui
		# tornar a matar-lo.
		await get_tree().create_timer(3).timeout
		# Creem un temporitzador i esperem a que s'acabi.
		flicker_sprite()
		# Cridem la funció que fa parpellejar l'sprite del cor.
	else:
	# Sinó:
		queue_free()
		# Esborrem aquest node i els seus fills directament.
		
func flicker_sprite():
# Funció per fer parpellejar l'sprite del cor.
	var flicker_time: float
	# Variable per emmagatzemar el temps que triga l'sprite en canviar d'estar visible i no.
	if GameManager.flashing_lights:
	# Si les llums intermitents estan activades:
		flicker_time = 0.1
		# Fem que el temps sigui 0.1 segons.
	else:
	# Sinó:
		flicker_time = 0.3
		# Fem que el temps sigui 0.3 segons.
		
	if healthScene != null:
	# Si l'escena del cor existeix (el jugador encara no l'ha agafat):
		healthSceneSprite = healthScene.get_child(0)
		# Accedim al node de l'sprite de l'escena del cor.
		if flickering:
		# Si l'sprite de jugador està parpellejant:
			return
			# Sortim de la funció (si el jugador ja estava parpellejant, evitem que
			# entri en diversos estats de parpelleig).

		flickering = true
		# Determinem que el jugador està parpellejant.
		var time_taken: float = 0.0
		# Variable pel temps transcorregut parpellejant.

		while time_taken < 2 and !healthScene.isObtained:
		# Mentres que time_taken sigui menor al temps que triga en desaparèixer
		# i el cor no hagi sigut agafat:
			if healthScene != null:
			# Si l'escena del cor existeix (el jugador encara no l'ha agafat):
				healthSceneSprite.visible = not healthSceneSprite.visible
				# Canviem el valor de la variable que determina si l'sprite és visible.
				await get_tree().create_timer(flicker_time).timeout
				# Creem un timer de 0.1 segons i esperem a que s'acabi.
				time_taken += 0.1
				# Sumem 0.1 al temps transcorregut.
