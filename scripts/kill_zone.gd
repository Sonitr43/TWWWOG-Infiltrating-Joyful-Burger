# Script pels precipicis.
extends Area2D

@onready var death_scene: PackedScene = preload("res://scenes/death.tscn")
# Precarreguem en una variable l'escena de quan el jugador mor.

func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	var death = death_scene.instantiate()
	# Creem una variable i l'assignem l'escena de mort instantiada.
	get_tree().current_scene.add_child(death)
	# Afegim a l'arbre d'escenes l'escena de mort.
	death.playerDies()
	# Cridem la funció que es trova dins l'escena de mort per quan el jugador mor.
