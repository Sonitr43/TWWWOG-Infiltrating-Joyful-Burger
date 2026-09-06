# Funció per la pantalla del menú principal.
extends Control

var bt_scene = load("res://scenes/gui/black_transition.tscn").instantiate()
# Carreguem en una variable l'escena de la pantalla negra de transició. No la col·loquem
# directament en l'escena perquè sinó no funcionen els botons de l'ItemList.
@onready var item_list: ItemList = $VBoxContainer/ItemList
# Carreguem en una variable el node ItemList.
@onready var sfx: AudioStreamPlayer = $SFX
# Carreguem en una variable l'efecte de so de cliquejar en un dels ítems.
var tween_time: float = 2
var tween_ease: Tween.EaseType = Tween.EASE_OUT
var tween_trans: Tween.TransitionType = Tween.TRANS_QUAD
# Variables pel tween de la transició negra.

func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
# Funció que s'executa quan un dels ítems del node ItemList és cliquejat.
	sfx.play()
	# Reproduïm l'efecte de so.
	add_child(bt_scene)
	# Afegim a l'escena la transició negra.
	var black_transition = bt_scene.get_child(0).get_child(0)
	# En una altra variable, carreguem el ColorRect de la transició negra.
	
	black_transition.modulate.a = 0
	# Posem l'alpha de la transició negra com a 0 (invisible).
	var tween = create_tween()
	tween.tween_property(black_transition, "modulate:a", 1, tween_time).set_ease(tween_ease).set_trans(tween_trans)
	# Creem un tween per fer visible la transició negra.
	await tween.finished
	# Esperem a que finalitzi el tween.
	
	match index:
	# Comparem el valor del paràmetre "index" de la funció per poder dir-li al joc a quin
	# nivell ens ha de portar depenent del botó que pulsem.
		0:
			GameManager.current_lv = 0
			get_tree().change_scene_to_file("res://scenes/menus/character_selection.tscn")
			# Canviem l'escena a la de la pantalla de selecció de personatge.
		1:
			get_tree().change_scene_to_file("res://scenes/menus/story.tscn")
			# Canviem l'escena a la del menú on es narra l'història.
		2:
			get_tree().change_scene_to_file("res://scenes/menus/options.tscn")
			# Canviem l'escena a la del menú d'opcions.
		3:
			get_tree().change_scene_to_file("res://scenes/menus/extras.tscn")
			# Canviem l'escena a la del menú dels extres.
