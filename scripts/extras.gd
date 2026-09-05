# Script pel menú dels extres.
extends Control

@onready var credits_button: Button = $VBoxContainer/CreditsButton
@onready var lv_select_button: Button = $VBoxContainer/LvSelectButton
# Importem en unes variables els botons del menú.

var bt_scene = load("res://scenes/black_transition.tscn").instantiate()
# Carreguem en una variable l'escena de la pantalla negra de transició. No la col·loquem
# directament en l'escena perquè sinó no funcionen els botons de l'ItemList.
@onready var select_sfx: AudioStreamPlayer = $SelectSFX
# Carreguem en una variable l'efecte de so per quan es prema el botó.

var tween_time: float = 2
var tween_ease: Tween.EaseType = Tween.EASE_OUT
var tween_trans: Tween.TransitionType = Tween.TRANS_QUAD
# Variables pel tween de la transició negra.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	lv_select_button.disabled = !GameManager.gameBeaten
	# Determinem si el botó per entrar en el menú del selector de nivells està desabilitat o no
	# depenent de si el jugador s'ha passat el joc o no.

func button_pressed(scene: String) -> void:
# Funció que s'executa quan un dels botons és pulsat.
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
	await fadeIn.finished
	# Esperem a que finalitzi el tween.
	
	get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn")
	# Canviem l'escena a la del menú en qüestió.

func _on_credits_button_pressed() -> void:
# Funció que s'executa quan el botó dels crèdits és pulsat.
	button_pressed("credits")
	# Cridem la funció dels botons i declarem que volem anar a l'escena dels crèdits.

func _on_lv_select_button_pressed() -> void:
# Funció que s'executa quan el botó del selector de nivells és pulsat.
	button_pressed("level_select")
	# Cridem la funció dels botons i declarem que volem anar a l'escena del selector de nivells.
