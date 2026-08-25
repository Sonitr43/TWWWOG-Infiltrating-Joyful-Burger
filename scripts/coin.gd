# Script per les monedes.
extends Area2D

@onready var hud_scene = get_tree().root.find_child("HUD", true, false)
# Busquem el node de l'escena del HUD dins de l'arbre d'escenes.

@onready var score: Label = hud_scene.find_child("Score", true, false)
# Creem una variable per accedir al text de la puntuació.

func _on_body_entered(_body: Node2D) -> void:
# Funció que s'executa quan un cos entra en l'àrea 2D.
	GameManager.coins += 1
	# Indiquem al joc que el jugador ha obtingut 1 moneda.
	GameManager.score += 50
	# Li sumem 50 punts al jugador.
	hud_scene.get_child(0).update_score()
	# Truquem la funció que actualitza la puntuació del HUD, accedint al node
	# "Control" de l'escena del HUD amb "get_child()".
	queue_free()
	# Eliminem el node de l'escena.
