# Script per determinar els límits de la càmera segons el nivell i àrea en què es trobi el jugador.
extends Camera2D

var current_lv = GameManager.current_lv
# Obtenim el valor del nivell actual en què es trova el jugador.
var current_area
# Creem una variable per l'àrea en què es trova el jugador. L'assignarem un valor
# en _process() per poder actualitzar en temps real la variable.

func _ready() -> void:
# Funció que es crida quan el node entra a l'escena per primer cop.
	if current_lv == 1:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_RIGHT, 5456)
		set_limit(SIDE_BOTTOM, 80)
		set_limit(SIDE_TOP, -416)
	if current_lv == 2:
		set_limit(SIDE_LEFT, -160)
		set_limit(SIDE_RIGHT, 6288)
		set_limit(SIDE_BOTTOM, 80)
		set_limit(SIDE_TOP, -720)
	if current_lv == 4:
		set_limit(SIDE_LEFT, -80)
		set_limit(SIDE_RIGHT, 896)
		set_limit(SIDE_BOTTOM, 32)
		set_limit(SIDE_TOP, -144)

func _process(_delta: float) -> void:
# Funció similar a process() (s'executa constantment), però dissenyada per a les físiques.
	current_area = GameManager.current_area
	# Obtenim el valor de l'àrea actual en què es trova el jugador.
	if current_lv == 0:
		if current_area == 0:
			set_limit(SIDE_LEFT, -160)
			set_limit(SIDE_RIGHT, 416)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 64)
		if current_area == 1:
			set_limit(SIDE_LEFT, 416)
			set_limit(SIDE_RIGHT, 1440)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 64)
		if current_area == 2:
			set_limit(SIDE_LEFT, 1440)
			set_limit(SIDE_RIGHT, 3024)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 96)
		if current_area == 3:
			set_limit(SIDE_LEFT, 3024)
			set_limit(SIDE_RIGHT, 3354)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 64)
		if current_area == 4:
			set_limit(SIDE_LEFT, 3360)
			set_limit(SIDE_RIGHT, 4432)
			set_limit(SIDE_TOP, -400)
			set_limit(SIDE_BOTTOM, 64)
		if current_area == 5:
			set_limit(SIDE_LEFT, 4432)
			set_limit(SIDE_RIGHT, 5808)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 288)
		if current_area == 6:
			set_limit(SIDE_LEFT, 5808)
			set_limit(SIDE_RIGHT, 6656)
			set_limit(SIDE_TOP, -120)
			set_limit(SIDE_BOTTOM, 64)
			
	if current_lv == 3:
		if current_area == 0:
			set_limit(SIDE_LEFT, -160)
			set_limit(SIDE_RIGHT, 5456)
			set_limit(SIDE_TOP, -720)
			set_limit(SIDE_BOTTOM, 80)
		if current_area == 1:
			set_limit(SIDE_LEFT, -16)
			set_limit(SIDE_RIGHT, 4432)
			set_limit(SIDE_TOP, -960)
			set_limit(SIDE_BOTTOM, -720)
