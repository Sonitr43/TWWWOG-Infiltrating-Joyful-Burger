extends Area2D

var isDead = false
# Variable per a poder determinar facilment el l'script de les físiques del jugador
# si ha mort o no.

@onready var timer: Timer = $Timer
# Creem una variable per al temporitzador i l'assignem al node Timer.
# La propietat "one_shot" està definida com a "true" perquè s'executi només un cop el temporitzador.

func _on_body_entered(_body: Node2D) -> void:
# Funció per a detectar quan un node del tipus colisió entra en aquesta àrea.
	print("Has mort!")
	isDead = true
	# Declarem que el jugador ha mort, per tant ja no ens podem moure.
	timer.start()
	# Comencem un temporitzador que en acabar-se ens retorna a l'inici del nivell.

func _on_timer_timeout() -> void:
# Funció que s'executa quan s'acaba un temporitzador.
	get_tree().reload_current_scene()
	# Accedim a l'arbre dins de l'escena en la que estem actualment ("game") i la reiniciem.
