# Script pels nivells.
extends Node

var gumball_player = preload("res://scenes/player_gumball.tscn")
var darwin_player = preload("res://scenes/player_darwin.tscn")
# Precarreguem les escenes dels personatges.

@onready var black_rect: ColorRect = get_tree().root.find_child("BlackTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc negre que fa de transició.
@onready var white_rect_text: Label = get_tree().root.find_child("WhiteTransition", true, false).find_child("Label", true, false)
# Creem una variable i l'assignem el text del bloc blanc que fa de transició.
@onready var white_rect: ColorRect = get_tree().root.find_child("WhiteTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc blanc que fa de transició.

var new_player: PlayerBase
# Creem una variable del tipus "Player" (la classe de l'escena del personatge base).

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	white_rect.modulate.a = 0
	white_rect_text.modulate.a = 0
	# Fem invisible el bloc blanc de transició i el seu text.
	if GameManager.current_lv != 0 and GameManager.current_lv != 4:
	# Si no estem al tutorial ni en l'últim nivell:
		black_rect.modulate.a = 0
		# Fem invisible el bloc negre de transició.

	# RECORDAR LA SELECCIÓ DELS PERSONATGES
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
		_:
		# Si la variable té qualsevol altre valor:
			new_player = gumball_player.instantiate()
			# Iniciem l'escena de Gumball per evitar que peti el joc.
	
	new_player.name = "Player"
	# Li posem de nom al node del jugador "Player".
	add_child(new_player)
	# Afegim el node del jugador a l'escena del nivell.
