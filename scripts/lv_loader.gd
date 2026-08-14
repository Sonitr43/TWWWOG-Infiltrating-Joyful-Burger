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

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills han entrat a l'arbre d'escenes. 
	GameManager.isDead = false
	# Declarem la variable que determina si el jugador ha mort o no com a falsa per si el jugador
	# ha mort, així pot tornar a moure's.
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
	
	match GameManager.current_lv:
	# Comparem el valor de la variable dins de l'script global que determina en quin nivell es
	# trova el jugador, això per determinar què escrivim en el text que mostra quin nivell es jugarà.
		1:
		# Si estem en el primer nivell, ho escrivim.
			level_text.text = "NIVELL 1-1"
		2:
		# Si estem en el segon nivell, ho escrivim.
			level_text.text = "NIVELL 1-2"
		3:
		# Si estem en el tercer nivell, ho escrivim.
			level_text.text = "NIVELL 1-3"
		_:
		# Si estem en un nivell desconegut, ho escrivim.
			level_text.text = "NIVELL  -1"
	
	loading_timer.start()
	# Comencem el temporitzador.

func _on_loading_timer_timeout() -> void:
# Funció per a quan s'acaba el temporitzador.
	match GameManager.current_lv:
	# Comparem la variable del nivell en el què el jugador es trova per saber qual carreguem.
		1:
		# Si estem en el primer, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/test.tscn")
		2:
		# Si estem en el segon, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
		3:
		# Si estem en el tercer, el carreguem.
			get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")
		_:
		# Si estem en un de desconegut, carreguem el nivell de prova.
			get_tree().change_scene_to_file("res://scenes/levels/test.tscn")
