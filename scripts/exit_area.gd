# Script per quan acabem un nivell.
extends Area2D

func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	GameManager.current_lv += 1
	# Li sumem 1 a la variable que determina en quin nivell el jugador es trova,
	# així es pot passar de nivell.
	GameManager.lv_completed = true
	# Li fem saber al joc que el jugador ha passat de nivell.
	get_tree().change_scene_to_file("res://scenes/level elements/lv_loader.tscn")
	# Passem a la pantalla de càrrega 
