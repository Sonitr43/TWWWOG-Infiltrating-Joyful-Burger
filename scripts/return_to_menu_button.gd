# Script per al botó per tornar al menú principal.
extends Button

var bt_scene = load("res://scenes/black_transition.tscn").instantiate()
# Carreguem en una variable l'escena de la pantalla negra de transició. No la col·loquem
# directament en l'escena perquè sinó no funcionen els botons de l'ItemList.
@export var song: AudioStreamPlayer
# Creem una variable exportada per poder assignar la cançó que estigui reproduint-se (si n'hi ha).
@export var tween_time: float = 2
@export var tween_ease: Tween.EaseType = Tween.EASE_OUT
@export var tween_trans: Tween.TransitionType = Tween.TRANS_QUAD
# Variables pel tween de la transició negra.
@onready var select_sfx: AudioStreamPlayer = $SelectSFX
# Carreguem en una variable l'efecte de so per quan es prema el botó.

func _on_pressed() -> void:
# Funció que s'executa quan el botó és pulsat.
	select_sfx.play()
	# Reproduïm l'efecte de so.
	
	add_child(bt_scene)
	# Afegim a l'escena la transició negra.
	var black_transition = bt_scene.get_child(0).get_child(0)
	# En una altra variable, carreguem el ColorRect de la transició negra.
	
	black_transition.modulate.a = 0
	# Posem l'alpha de la transició negra com a 0 (invisible).
	var fadeIn = create_tween()
	fadeIn.tween_property(black_transition, "modulate:a", 1, tween_time).set_ease(tween_ease).set_trans(tween_trans)
	# Creem un tween per fer visible la transició negra.
	create_tween().tween_property(song, "volume_db", -80, tween_time)
	# Creem un altre tween per anar treient-li volum a la cançó.
	await fadeIn.finished
	# Esperem a que finalitzi el tween.
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	# Canviem l'escena a la de la pantalla del menú principal.
