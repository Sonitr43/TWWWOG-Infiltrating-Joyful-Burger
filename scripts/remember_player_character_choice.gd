# Script pels nivells per saber quin personatge carregar segons la nostra elecció.

extends Node2D

var gumball_player = preload("res://scenes/player_gumball.tscn")
var darwin_player = preload("res://scenes/player_darwin.tscn")
# Precarreguem les escenes dels personatges.

var new_player: PlayerBase
# Creem una variable del tipus "Player" (la classe de l'escena del personatge base).

func _ready() -> void:
	match GameManager.PlayerCharacter:
	# Comparem el valor de la variable dins de l'script global la qual indica amb quin personatge
	# volem jugar:
	# (Aquest valor l'obtenim després de seleccionar un personatge).
		0:
		# Si la variable té de valor 0 (el personatge és Gumball):
			new_player = gumball_player.instantiate()
			# Iniciem l'escena de Gumball.
		1:
		# Si la variable té de valor 1 (el personatge és Darwin):
			new_player = darwin_player.instantiate()
			# Iniciem l'escena de Darwin.
	add_child(new_player)
	# Afegim el node del jugador a l'escena del nivell.
