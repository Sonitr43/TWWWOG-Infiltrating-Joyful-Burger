extends Area2D

var player
var scroll_bg
# Creem una variable pel jugador i el fons lliscant, als quals els donem un valor en _ready().
var is_player_close: bool = false
# Variable per determinar si el jugador està a prop de l'àrea o no.
var transitioning: bool = false
# Variable per indicar al joc que hem interactuat amb una porta i estem transicionant.
@onready var color_rect: ColorRect = get_tree().root.find_child("BlackTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc negre que fa de transició.
@export var destination_marker: Marker2D
# Creem una variable per la pestanya "Inspector" de Godot per poder determinar fàcilment
# el Marker2D de la següent/anterior porta.
@export var destination_area: int
# Creem una variable per la pestanya "Inspector" de Godot per poder determinar fàcilment
# en quina àrea ens trobem per la porta.
@onready var door_opened_sfx: AudioStreamPlayer = $DoorOpenedSFX
@onready var door_closed_sfx: AudioStreamPlayer = $DoorClosedSFX
# Carreguem els nodes d'àudio dels efectes de so de les portes obrint-se i tancant-se.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entra en l'arbre d'escenes.
	await get_tree().process_frame
	# Esperem a que tot l'arbre d'escenes es carregui per tal de poder trovar el node del jugador.
	player = get_tree().root.find_child("Player", true, false)
	# Obtenim el node del jugador dins de l'arbre d'escenes.
	if GameManager.current_lv == 0:
	# Si estem al tutorial:
		scroll_bg = get_tree().root.find_child("ScrollingBG", true, false).find_child("TextureRect", true, false)
		# Carreguem el fons lliscant.
		
func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	is_player_close = true
	# Declarem que el jugador està a prop.

func _on_body_exited(_body: Node2D) -> void:
# Funció per quan un cos surt de l'àrea 2D.
	is_player_close = false
	# Declarem que el jugador ha sortit.
	
func _on_transition_started():
# Funció que s'executa quan la transició comença.
	door_opened_sfx.play()
	# Reproduïm l'efecte de so de la porta obrint-se.
	transitioning = true
	# Declarem que estem transicionant.
	GameManager.shouldMove = false
	# Fem que el jugador no es pugui moure.
	
	var fade_in = create_tween()
	fade_in.tween_property(color_rect, "modulate:a", 1, 0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Creem un tween pel "fade-in" de la transició.
	await fade_in.finished
	# Esperem a que finalitzi el tween.
	
	player.find_child("Camera2D", true, false).position_smoothing_enabled = false
	# Desactivem la propietat "Position Smoothing" del node Camera2D del jugador, així la càmera es mourà
	# immediatament al fer el canvi d'habitació.
	change_room()
	# Fem el canvi d'habitació.
	
	var fade_out = create_tween()
	fade_out.tween_property(color_rect, "modulate:a", 0, 0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Creem un tween pel "fade-out" de la transició.
	await fade_out.finished
	# Esperem a que finalitzi el tween.
	
	player.find_child("Camera2D", true, false).position_smoothing_enabled = true
	# Reactivem la propietat "Position Smoothing" del node Camera2D del jugador.
	GameManager.shouldMove = true
	# Fem que el jugador ja es pugui moure.
	transitioning = false
	# Declarem que ja no estem transicionant.

func _process(_delta: float) -> void:
# Funció que s'executa cada frame.
	var conditionsToEnter = (
		is_player_close
		and Input.is_action_just_pressed("move_up")
		and not transitioning
	)
	# Condicions per passar per una porta (el jugador està a prop d'una, pulsa el botó d'amunt i no està transicionant)
	if conditionsToEnter and get_name().begins_with("DoorNormal"):
	# Si el jugador compleix les condicions per passar per una porta qualsevol:
		_on_transition_started()
		# Comencem la transició.
	if conditionsToEnter and get_name().begins_with("DoorGumball") and GameManager.PlayerCharacter == 0:
	# Si podem passar per una porta, la porta en qüestió és una exclusiva de Gumball i estem jugant com a Gumball:
		_on_transition_started()
		# Comencem la transició.
	if conditionsToEnter and get_name().begins_with("DoorDarwin") and GameManager.PlayerCharacter == 1:
	# Si podem passar per una porta, la porta en qüestió és una exclusiva de Darwin i estem jugant com a Darwin:
		_on_transition_started()
		# Comencem la transició.

func change_room() -> void:
# Funció per poder efectuar el canvi d'habitació.
	door_closed_sfx.play()
	# Reproduïm l'efecte de so de la porta tancant-se.
	player.global_position = destination_marker.global_position
	# Canviem la posició global del jugador a la del Marker2D de la porta a la que volem passar.
	GameManager.current_area = destination_area
	# Actualitzem la varible dins del singleton que indica en quina àrea ens trobem.
	if GameManager.current_lv == 0:
	# Si estem al tutorial:
		update_scroll_bg()
		# Actualitzem el fons lliscant.

func update_scroll_bg() -> void:
# Funció per actualitzar el color del fons lliscant depenent de l'àrea del nivell en què el jugador es trobi.
	match GameManager.current_area:
		1:
			scroll_bg.modulate = Color("82ff8d")
		2:
			scroll_bg.modulate = Color("c481ff")
		4:
			scroll_bg.modulate = Color("ffc581")
		5:
			scroll_bg.modulate = Color("82f4ff")
		_:
			scroll_bg.modulate = Color("ffffff")
