# Script per Area2Ds que serveixen com a transicions dins dels nivells.
extends Area2D

@onready var black_transition: ColorRect = get_tree().root.find_child("BlackTransition", true, false).get_child(0).get_child(0)
# Creem una variable i importem el bloc negre de transició.
@export var fade_in_duration: float = 1
@export var fade_out_duration: float = 1
@export var tween_ease_initial: Tween.EaseType = Tween.EASE_OUT
@export var tween_ease_final: Tween.EaseType = Tween.EASE_IN
@export var tween_trans: Tween.TransitionType = Tween.TRANS_QUAD
@export var destination_marker: Marker2D
@export var destination_area: int
@export var music_to_play: AudioStreamPlayer
@export var music_to_remove: AudioStreamPlayer
# Creem variables exportades per a l'inspector de Godot per poder modificar el comportament de la transició.

var isTransitioning: bool = false
# Variable per saber si el jugador està transicionant.
var player
# Creem una variable buida per al jugador que omplirem en _ready().

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	await get_tree().process_frame
	# Esperem a que l'arbre d'escenes s'hagi executat totalment.
	player = get_tree().root.find_child("Player", true, false)
	# Importem el node del jugador.

func _on_body_entered(_body: Node2D) -> void:
# Funció que s'executa quan un cos entra en l'Area2D.
	if !isTransitioning:
	# Si no estem transicionant:
		isTransitioning = true
		# Declarem que ja ho estem, així evitem errades fent que aquesta funció només es pugui executar un cop.
		GameManager.shouldMove = false
		# Declarem que el jugador no es pot moure.
		var fadeIn = create_tween()
		fadeIn.tween_property(black_transition, "modulate:a", 1, fade_in_duration).set_ease(tween_ease_initial).set_trans(tween_trans)
		# Creem un tween per al "fade-in" de la transició.
		var musicFadeOut = create_tween()
		musicFadeOut.tween_property(music_to_remove, "volume_db", -80, fade_in_duration)
		# Creem un altre tween per a treure la música de l'àrea actual.
		await fadeIn.finished
		# Esperem a que acabi el primer tween.
		
		change_location()
		# Cridem la funció que actualitza la posició del jugador.
		music_to_remove.stop()
		music_to_play.volume_db = GameManager.volume_music
		# Detenim la reproducció de la música de l'àrea anterior i reiniciem el seu volum.
		await get_tree().create_timer(1).timeout
		# Creem un temporitzador d'un segon i esperem a que acabi.
		
		var fadeOut = create_tween()
		fadeOut.tween_property(black_transition, "modulate:a", 0, fade_out_duration).set_ease(tween_ease_final).set_trans(tween_trans)
		# Creem un tween per al "fade-out" de la transició.
		music_to_play.play()
		# Reproduïm la cançó de l'àrea nova.
		await fadeOut.finished
		# Esperem a que acabi.
		
		player.find_child("Camera2D", true, false).position_smoothing_enabled = true
		# Declarem com a vertadera aquesta variable de la càmera del jugador perquè ja s'ha acabat el "fade-out".
		GameManager.shouldMove = true
		# Declarem que el jugador ja es pugui moure.
		isTransitioning = false
		# Declarem que el jugador ja no està transicionant.

func change_location():
# Funció que canvia la posició del jugador.
	player.find_child("Camera2D", true, false).position_smoothing_enabled = false
	# Declarem com a falsa aquesta variable del node "Camera2D" del jugador per fer que la càmera estigui ja posicionada al seu lloc
	# abans que el "fade-ou" comenci.
	player.global_position = destination_marker.global_position
	# Igualem la posició global del jugador amb la del node "Marker2D" assignat a aquest node, el qual marca la posició on volem que
	# el jugador sigui transportat.
	GameManager.current_area = destination_area
	# Actualitzem la variable dins del singleton que determina en quina àrea del nivell ens trobem amb l'assignada a aquest node,
	# així podem canviar els límits de la càmera.
