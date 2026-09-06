# Script per poder passar de nivell.
extends Area2D

var player
# Creem una variable pel jugador, la qual li donem un valor en _ready().
var is_player_close: bool = false
# Variable per determinar si el jugador està a prop de l'àrea o no.
var hasEntered: bool = false
# Creem un bool per determinar si el jugador ha entrat a la porta o no.
@onready var black_rect: ColorRect = get_tree().root.find_child("BlackTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc negre que fa de transició.
@onready var white_rect_text: Label = get_tree().root.find_child("WhiteTransition", true, false).find_child("Label", true, false)
# Creem una variable i l'assignem el text del bloc blanc que fa de transició.
@onready var white_rect: ColorRect = get_tree().root.find_child("WhiteTransition", true, false).find_child("ColorRect", true, false)
# Creem una variable i l'assignem el bloc blanc que fa de transició.
@onready var sfx: AudioStreamPlayer
# Creem una variable per a l'efecte de so que es reprodueix quan el jugador interactua amb la porta del nivell final.
@onready var music: AudioStreamPlayer
# Creem una variable per a la música de victòria que es reprodueix en completar-se un nivell.
@export var music_to_stop: AudioStreamPlayer
# Creem una variable exportada per poder seleccionar la cançó del nivell i treure-la en la transició del nivell completat.

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
	if is_player_close and Input.is_action_just_pressed("move_up") and !hasEntered:
	# Si el jugador està a prop i pulsa el botó d'amunt:
		hasEntered = true
		# Declarem que el jugador ha entrat a la porta, així no pot tornar a entrar accidentalment.
		GameManager.current_lv += 1
		# Li sumem 1 a la variable que emmagatzema en quin nivell ens trobem, així podem efectuar
		# el canvi de nivell.
		GameManager.checkpoint_pos = Vector2(-999, -999)
		GameManager.previous_checkpoint_node = null
		# Reiniciem les variables dels checkpoints.
		GameManager.shouldMove = false
		# Fem que el jugador no es pugui moure.
		if get_name().begins_with("Tutorial"):
		# Si el node de la porta comença amb "Tutorial" (estem en un ExitArea del tutorial):
			var tween = create_tween()
			tween.tween_property(black_rect, "modulate:a", 1, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# Creem un tween que fa visible el bloc negre de transició.
			await tween.finished
			# Esperem a que el tween finalitzi.
			get_tree().change_scene_to_file("res://scenes/level elements/gui/lv_loader.tscn")
			# Passem a la pantalla de càrrega.
		elif get_name().begins_with("JB"):
		# Si estem en la porta de l'últim nivell:
			sfx = $"../../SFX"
			# A la variable de l'efecte de so l'assignem el seu node corresponent un cop que hem detectat que estem al nivell final.
			sfx.play()
			# Reproduïm l'efecte de so.
			var tween = create_tween()
			tween.tween_property(white_rect, "modulate:a", 1, 5)
			# Creem un tween que fa visible el bloc blanc de transició.
			await tween.finished
			await get_tree().create_timer(1).timeout
			# Esperem a que el tween finalitzi + posem un delay d'1 segon.
			get_tree().change_scene_to_file("res://scenes/gui/final_screen.scn")
			# Passem a la pantalla dels crèdits.
		else:
		# Sinó:
			GameManager.level_beaten = true
			# Declarem que el jugador s'ha passat el nivell.
			music_to_stop.stop()
			# Detenim la cançó del nivell.
			music = $Music
			# L'assignem a la variable de la música el seu node corresponent.
			music.play()
			# Reproduïm la cançó.
			GameManager.current_area = 0
			# Reiniciem el valor de l'àrea actual en què es trova el jugador.
			if GameManager.flashing_lights:
			# Si les llums intermitents estan activades:
				white_rect.modulate.a = 1
				# Declarem l'alpha del fons blanc com a 1 (100% visible).
			var bgFadeIn = create_tween()
			bgFadeIn.tween_property(white_rect, "modulate:a", 0.5, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			var textFadeIn = create_tween()
			textFadeIn.tween_property(white_rect_text, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# Fem un tween per al fons blanc i el seu text.

func _on_music_finished() -> void:
# Funció que s'executa quan la música de victòria s'acava.
	var tween = create_tween()
	tween.tween_property(black_rect, "modulate:a", 1, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Fem un tween per al fons blanc i ho amaguem tot.
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	# Esperem a que s'acabi el tween + un delay de mig segon.
	get_tree().change_scene_to_file("res://scenes/level elements/gui/lv_loader.tscn")
	# Passem a la pantalla de càrrega directament.
