# Script per la pantalla final del joc.
extends Control

@onready var music: AudioStreamPlayer = $Music
# Creem una variable i importem el node de l'àudio de la cançó.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	GameManager.gameBeaten = true
	# Declarem que el jugador s'ha passat el joc.
	GameManager.score = 0
	# Reiniciem el marcador de la puntuació.

func _on_sfx_finished() -> void:
# Funció que s'executa quan l'efecte de so que es reprodueix en començar l'escena s'acava.
	await get_tree().create_timer(1).timeout
	# Creem un temporitzador d'un segon i esperem a que s'acabi.
	music.play()
	# Reproduïm la cançó.
