# Script per la pantalla de fi del joc.
extends Control

@onready var timer: Timer = $Timer
# Creem una variable pel temporitzador que determina quan sortim d'aquesta pantalla.

func _ready() -> void:
# Funció per quan aquest node i els seus fills han entrat en l'arbre d'escenes.
	AudioServer.set_bus_mute(1, false)
	# Com que el jugador ha mort, declarem com a no silenciada la música del joc.
	timer.start()
	# Comencem el temporitzador.
	
func _on_timer_timeout() -> void:
# Funció per quan s'acaba un temporitzador.
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	# Canviem l'escena a la del menú principal.
