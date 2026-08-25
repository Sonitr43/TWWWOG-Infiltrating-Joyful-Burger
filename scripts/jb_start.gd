# Script pel nivell del passadís de Joyful Burger.
extends Node2D

var player
# Creem una variable pel jugador, la qual li donem un valor en _ready().
@onready var color_rect: ColorRect = $BlackTransition/Control/ColorRect
# Creem una variable i l'assignem el rectangle negre que fa de transició.

func _ready() -> void:
	await get_tree().process_frame
	# Esperem a que tot l'arbre d'escenes es carregui per tal de poder trovar el node del jugador.
	player = get_tree().root.find_child("Player", true, false)
	# Obtenim el node del jugador dins de l'arbre d'escenes.
	player.find_child("Camera2D", true, false).position_smoothing_enabled = false
	# Obtenim el node de la càmera del jugador i 
	GameManager.shouldMove = false
	# Fem que el jugador no es pugui moure.
	color_rect.modulate.a = 1
	# Posem l'alpha del rectangle negre com a 1.
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, 4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Creem un tween per amagar el rectangle negre.
	await tween.finished
	GameManager.shouldMove = true
	# Esperem a que el tween finalitzi i fem que el jugador ja es pugui moure.
	player.find_child("Camera2D", true, false).position_smoothing_enabled = true
