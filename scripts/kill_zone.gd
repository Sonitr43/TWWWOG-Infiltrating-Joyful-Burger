# Script pels precipicis.
extends Area2D

@onready var death: Node2D = get_tree().root.find_child("Death", true, false)
# Carreguem en una variable l'escena de quan el jugador mor.

func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	death.playerDies()
	# Cridem la funció que es trova dins l'escena de mort per quan el jugador mor.
