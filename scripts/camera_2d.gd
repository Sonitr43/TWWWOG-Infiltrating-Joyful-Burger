extends Camera2D

var current_lv = GameManager.current_lv
# Obtenim el valor del nivell actual en què es trova el jugador.

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
# Funció que es crida quan el node entra a l'escena per primer cop.
	# Aquí determinem els límits de la càmera segons el nivell en què es trobi el jugador.
	if current_lv == 1:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_BOTTOM, 74)
	if current_lv == 2:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_RIGHT, 160)
		set_limit(SIDE_BOTTOM, 74)
