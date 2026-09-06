# Script per l'escena de la pantalla de càrregua dels nivells.
extends Control

@onready var darwin_container: HBoxContainer = $DarwinContainer
# Creem una variable pel contenidor que emmagatzema l'sprite i vides de Darwin.
@onready var gumball_container: HBoxContainer = $GumballContainer
# Creem una variable pel contenidor que emmagatzema l'sprite i vides de Gumball.
@onready var loading_timer: Timer = $LoadingTimer
# Creem una variable pel temporitzador de la pantalla de càrregua.
@onready var level_text: Label = $LevelText
# Creem una variable pel text que mostra quin nivell es jugarà.
@onready var lifes_darwin: Label = $DarwinContainer/LifesDarwin
# Creem una variable pel comptador de vides de Darwin.
@onready var lifes_gumball: Label = $GumballContainer/LifesGumball
# Creem una variable pel comptador de vides de Gumball.
@onready var v_box_container: VBoxContainer = $VBoxContainer
# Creem una variable pel contenidor que té el text i els botons per poder saltar el tutorial.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills han entrat a l'arbre d'escenes.
	GameManager.level_beaten = false
	# Marquem aquesta variable del singleton com a falsa per si el jugador s'ha passat un nivell,
	# així reiniciem el seu valor.
	if GameManager.current_lv == 0:
	# Si estem al tutorial:
		gumball_container.hide()
		# Amaguem el contenidor de Darwin.
		darwin_container.hide()
		# Amaguem el contenidor de Darwin.
		v_box_container.visible = true
		# Fem visible el text i els botons per poder saltar el tutorial.
	elif GameManager.current_lv == 4:
	# Si estem al nivell del passadís de Joyful Burger:
		get_tree().change_scene_to_file("res://scenes/levels/level_4.scn")
		# Passem directament al nivell.
	else:
	# Sinó:
		v_box_container.visible = false
		# Fem invisible el text i els botons per poder saltar el tutorial.
		GameManager.shouldMove = true
		GameManager.health = 3
		# Declarem la variable que determina si el jugador es pot moure o no com a vertadera i reiniciem
		# la salut del jugador per jugador per si ha mort, així pot tornar a moure's i té la HP restaurada.
		AudioServer.set_bus_mute(1, false)
		# Per si el jugador ha mort, declarem com a no silenciada la música del joc.
		match GameManager.PlayerCharacter:
		# Comparem el valor de la variable dins de l'script global la qual indica amb quin personatge
		# estem jugar:
		# (Aquest valor l'obtenim després de seleccionar un personatge).
			0:
			# Si la variable té de valor 0 (el personatge és Gumball):
				lifes_gumball.text = "x " + str(GameManager.lifes)
				# Actualitzem el text de les vides de Gumball per mostrar-les.
				darwin_container.hide()
				# Amaguem el contenidor de Darwin.
			1:
			# Si la variable té de valor 1 (el personatge és Darwin):
				lifes_darwin.text = "x " + str(GameManager.lifes)
				# Actualitzem el text de les vides de Darwin per mostrar-les.
				gumball_container.hide()
				# Amaguem el contenidor de Gumball.
			_:
			# Si la variable té qualsevol altre valor:
				lifes_gumball.text = "x " + str(GameManager.lifes)
				# Actualitzem el text de les vides de Gumball per mostrar-les.
				darwin_container.hide()
				# Amaguem el contenidor de Darwin.
			pass
		
		match GameManager.current_lv:
		# Comparem el valor de la variable dins de l'script global que determina en quin nivell es
		# trova el jugador, això per determinar què escrivim en el text que mostra quin nivell es jugarà.
			1:
			# Si estem en el primer nivell, ho escrivim.
				level_text.text = "NIVELL 1"
			2:
			# Si estem en el segon nivell, ho escrivim.
				level_text.text = "NIVELL 2"
			3:
			# Si estem en el tercer nivell, ho escrivim.
				level_text.text = "NIVELL 3"
			_:
			# Si estem en un nivell desconegut, ho escrivim.
				level_text.text = "NIVELL -1"
		
		loading_timer.start()
		# Comencem el temporitzador.

func _on_loading_timer_timeout() -> void:
# Funció per a quan s'acaba el temporitzador.
	match GameManager.current_lv:
	# Comparem la variable del nivell en el què el jugador es trova per saber qual carreguem.
		1:
		# Si estem en el primer, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/level_1.scn")
		2:
		# Si estem en el segon, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/level_2.scn")
		3:
		# Si estem en el tercer, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/level_3.scn")
		_:
		# Si estem en un de desconegut, carreguem el nivell de prova.
			get_tree().change_scene_to_file("res://scenes/levels/test.tscn")

func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
# Funció que s'executa quan un dels botons per saltar (o no) el tutorial és pulsat.
	match index:
	# Comparem el valor del botó que es prema (0 = Sí, 1 = No).
		0:
			GameManager.current_lv += 1
			get_tree().reload_current_scene()
			# Si saltem el tutorial, li sumem 1 a la variable que indica en quin nivell ens trobem
			# i reiniciem l'escena, així ara carregarà el primer nivell.
		1:
			get_tree().change_scene_to_file("res://scenes/levels/tutorial.scn")
			# Si no saltem el tutorial, carreguem la seva escena.
