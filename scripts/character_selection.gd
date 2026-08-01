# Script per la pantalla de selecció de personatge.

extends Control

var transitioning: bool = false
# Bool que determina si estem transicionant o no. Això és per evitar que el jugador
# pugui tornar a cliquejar el botó més d'un cop, la qual cosa pot causar errades.

func _on_button_gumball_pressed() -> void:
# Funció per quan es prema el botó de Gumball.
	if not transitioning:
	# Si no estem transicionant:
		transitioning = true
		# Indiquem que ja ho estem.
		GameManager.PlayerCharacter = 0
		# Indiquem que estem jugant com a Gumball.
		get_tree().change_scene_to_file("res://scenes/levels/test.tscn")
		# Canviem l'escena a la del primer nivell.

func _on_button_darwin_pressed() -> void:
# Funció per quan es prema el botó de Darwin.
	if not transitioning:
	# Si no estem transicionant:
		transitioning = true
		# Indiquem que ja ho estem.
		GameManager.PlayerCharacter = 1
		# Indiquem que estem jugant com a Darwin.
		get_tree().change_scene_to_file("res://scenes/levels/test.tscn")
		# Canviem l'escena a la del primer nivell.
