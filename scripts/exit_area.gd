# Script per poder passar de nivell.
extends Area2D

var player
# Creem una variable pel jugador, la qual li donem un valor en _ready().
var is_player_close: bool = false
# Variable per determinar si el jugador està a prop de l'àrea o no.
@onready var color_rect: ColorRect = get_tree().root.find_child("BlackTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc negre que fa de transició.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fill entren en l'arbre d'escenes.
	await get_tree().process_frame
	# Esperem a que tot l'arbre d'escenes es carregui per tal de poder trovar el node del jugador.
	player = get_tree().root.find_child("Player", true, false)
	# Obtenim el node del jugador dins de l'arbre d'escenes.

func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	is_player_close = true
	# Declarem que el jugador està a prop.

func _on_body_exited(_body: Node2D) -> void:
# Funció per quan un cos surt de l'àrea 2D.
	is_player_close = false
	# Declarem que el jugador ha sortit.

func _process(_delta: float) -> void:
# Funció que s'executa cada frame.
	if is_player_close and Input.is_action_just_pressed("move_up"):
	# Si el jugador està a prop i pulsa el botó d'amunt:
		GameManager.current_lv += 1
		# Li sumem 1 a la variable que determina en quin nivell el jugador es trova,
		# així es pot passar de nivell.
		GameManager.lv_completed = true
		# Li fem saber al joc que el jugador ha passat de nivell.
		GameManager.shouldMove = false
		# Fem que el jugador no es pugui moure.
		if get_name().begins_with("Tutorial"):
		# Si el node de la porta comença amb "Tutorial" (estem en un ExitArea del tutorial):
			var tween = create_tween()
			tween.tween_property(color_rect, "modulate:a", 1, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# Creem un tween que fa visible el bloc negre de transició.
			await tween.finished
			# Esperem a que el tween finalitzi.
			get_tree().change_scene_to_file("res://scenes/levels/jb_start.tscn")
			# Passem a la pantalla de càrrega.
		elif get_name().begins_with("JB") && player.is_on_floor():
		# Si el node de la porta comença amb "JB" (estem en l'ExitArea del passadís de Joyful Burger) i el jugador està al terra:
			var tween = create_tween()
			tween.tween_property(color_rect, "modulate:a", 1, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# Creem un tween que fa visible el bloc negre de transició.
			await tween.finished
			# Esperem a que el tween finalitzi + 1 segon.
			get_tree().change_scene_to_file("res://scenes/level elements/lv_loader.tscn")
			# Passem a la pantalla de càrrega.
		else:
		# Sinó:
			get_tree().change_scene_to_file("res://scenes/level elements/lv_loader.tscn")
			# Passem a la pantalla de càrrega directament.
