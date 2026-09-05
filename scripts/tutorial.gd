# Script pel tutorial.
extends Node2D

@onready var color_rect: ColorRect = $BlackTransition/Control/ColorRect
# Creem una variable i l'assignem el bloc negre que fa de transició.
@onready var music: AudioStreamPlayer = $Music
# Creem una variable per al node de l'àudio de la cançó de fons.
var dialogue_start = preload("res://dialogues/tutorial/Larry0.dialogue")
# Precarreguem dins d'una variable el diàleg de Larry en entrar al tutorial.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren a l'escena d'arbres.
	GameManager.shouldMove = false
	# Fem que el jugador no es pugui moure.
	var tween = create_tween()
	# Creem una variable per facilitat la creació de tweens.
	tween.tween_property(color_rect, "modulate:a", 0, 3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(0.5)
	# Creem un tween per treure el bloc negre tapant la pantalla en iniciar el tutorial. La propietat "modulate:a" és l'alpha
	# del node ColorRect.
	tween.finished.connect(_on_tween_finished)
	# Connectem la senyal "finished" dels Tweens a una funció per poder activar el diàleg quan acabi la transició.
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	# Connectem la senyal dels diàlegs per quan acaben.
	
func _on_tween_finished() -> void:
# Funció que s'executa quan finalitza el tween de la transició de l'inici.
	DialogueManager.show_dialogue_balloon(dialogue_start, "start")
	# Comencem el diàleg inicial.
	music.play()
	# Reproduïm la cançó.
	
func _on_dialogue_ended(_dialogue):
# Funció que s'executa quan un diàleg acaba.
	GameManager.shouldMove = true
	# Fem que el jugador es pugui moure.
