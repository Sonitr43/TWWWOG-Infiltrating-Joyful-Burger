# Script per quan el jugador mor.
extends Area2D
class_name Death
# Declarem l'escena de quan el jugador mor com a una classe.

@onready var timer: Timer = $Timer
# Creem una variable per al temporitzador i l'assignem al node Timer.
# La propietat "one_shot" està definida com a "true" perquè s'executi només un cop el temporitzador.

func playerDies() -> void:
# Funció que s'executa quan el jugador mor.
	GameManager.isDead = true
	# Declarem que el jugador ha mort, per tant ja no ens podem moure.
	timer.start()
	# Comencem un temporitzador que en acabar-se ens retorna a l'inici del nivell.

func _on_timer_timeout() -> void:
# Funció que s'executa quan s'acaba un temporitzador.
	if GameManager.lifes > 0:
	# Si el jugador no s'ha quedat sense vides:
		GameManager.lifes -= 1
		# Li treiem una.
		get_tree().change_scene_to_file("res://scenes/level elements/lv_loader.tscn")
		# Portem el jugador cap a la pantalla de càrregua dels nivells.
	else:
	# Si el jugador s'ha quedat sense vides:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		# El portem a la pantalla de fi de joc.
