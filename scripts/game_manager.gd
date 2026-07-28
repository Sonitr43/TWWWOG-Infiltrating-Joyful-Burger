extends Node

var current_lv = 1
var lv_path = "res://scenes/levels/"
# Guardem en unes variables certes dates per poder efectuar el canvi de nivell.

func next_level(_body):
# Funció per a canviar de nivell.
	current_lv += 1
	# Li sumem 1 a la variable que emmagatzema el nivell actual.
	var full_path = lv_path + "level_" + str(current_lv) + ".tscn"
	# Obtenim la ruta exacta del nivell nou que volem carregar.
	if get_tree().change_scene_to_file(full_path) == OK:
		# Obtenim l'arbre del node en el que estem i canviem l'escena actual a la del nou nivell.
		print("El jugador ha passat al nivell " + str(current_lv))
	else:
		print("El nivell no existeix!")
