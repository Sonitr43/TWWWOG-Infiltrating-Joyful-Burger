# Script global (un "singleton")

extends Node

var current_lv = 1
var lv_path = "res://scenes/levels/"
# Guardem en unes variables certes dates per poder efectuar el canvi de nivell.

var PlayerCharacter: int = -1
# Variable per saber amb quin personatge estem jugant (0: Gumball, 1: Darwin).

func next_level(_body):
# Funció per a canviar de nivell.
	current_lv += 1
	# Li sumem 1 a la variable que emmagatzema el nivell actual.
	var full_path = lv_path + "level_" + str(current_lv) + ".tscn"
	# Obtenim la ruta exacta del nivell nou que volem carregar.
	if get_tree().change_scene_to_file(full_path) == OK:
	# Si el nivell existeix:
		# Obtenim l'arbre del node en el que estem i canviem l'escena actual a la del nou nivell.
		print("El jugador ha passat al nivell " + str(current_lv))
	else:
	# Si el nivell no existeix:
		print("El nivell no existeix!")
