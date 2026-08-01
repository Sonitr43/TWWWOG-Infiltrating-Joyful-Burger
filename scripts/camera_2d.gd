# Script per determinar els límits de la càmera segons el nivell en què es trobi el jugador.

extends Camera2D

var current_lv = GameManager.current_lv
# Obtenim el valor del nivell actual en què es trova el jugador.

func _enter_tree() -> void:
# Funció que es crida quan el node entra a l'escena per primer cop.
	if current_lv == 1:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_BOTTOM, 74)
	if current_lv == 2:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_BOTTOM, 74)
