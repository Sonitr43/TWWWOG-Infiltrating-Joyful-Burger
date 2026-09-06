# Script per la pantalla d'advertència.
extends Control

var bt_scene = load("res://scenes/gui/black_transition.tscn").instantiate()
# Carreguem en una variable l'escena de la pantalla negra de transició. No la col·loquem
# directament en l'escena perquè sinó no funcionen els botons de l'ItemList.
@onready var item_list: ItemList = $VBoxContainer/ItemList
# Carreguem en una variable el node ItemList.
@onready var select_sfx: AudioStreamPlayer = $SelectSFX
# Carreguem en una variable l'efecte de so de cliquejar en un dels nivells.
var tween_time: float = 2
var tween_ease: Tween.EaseType = Tween.EASE_OUT
var tween_trans: Tween.TransitionType = Tween.TRANS_QUAD
# Variables pel tween de la transició negra.

func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
# Funció que s'executa quan un dels ítems del node ItemList és cliquejat.
	var isTransitioning: bool = false
	# Variable per determinar si el jugador està transicionant o no.
	if !isTransitioning:
	# Si no estem transicionant:
		select_sfx.play()
		# Reproduïm l'efecte de so.
		isTransitioning = true
		# Declarem que ja estem transicionant.
		add_child(bt_scene)
		# Afegim a l'escena la transició negra.
		var black_transition = bt_scene.get_child(0).get_child(0)
		# En una altra variable, carreguem el ColorRect de la transició negra.
		
		black_transition.modulate.a = 0
		# Posem l'alpha de la transició negra com a 0 (invisible).
		var fade_in = create_tween()
		fade_in.tween_property(black_transition, "modulate:a", 1, tween_time).set_ease(tween_ease).set_trans(tween_trans)
		# Creem un tween per fer visible la transició negra.
		await fade_in.finished
		# Esperem a que finalitzi el tween.
		
		match index:
		# Comparem el valor del paràmetre "index" de la funció per poder dir-li al joc a quina
		# opció l'hem fet click.
			0:
			# Si hem seleccionat que sí:
				GameManager.flashing_lights = false
				# Desactivem les llums intermitents.
			1:
			# Si hem seleccionat que no:
				GameManager.flashing_lights = true
				# Activem les llums intermitents.
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
		 # Finalment, canviem l'escena a la de la pantalla del menú principal.
