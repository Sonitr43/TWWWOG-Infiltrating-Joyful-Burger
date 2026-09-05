# Script per al menú de les opcions.
extends Control

@onready var flashing_lights_check_box: CheckBox = $VBoxContainer/FlashingLightsCheckBox
# Creem una variable per a la casella de selecció per activar/desactivar les llums intermitents.
@onready var resolution_button: OptionButton = $VBoxContainer/ResolutionButton
# Creem una variable per al menú desplegable de les resolucions.
@onready var fullscreen_check_box: CheckBox = $VBoxContainer/FullscreenCheckBox
# Creem una variable per a la casella de selecció per activar/desactivar la finestra completa.
@onready var volume_slider_general: HSlider = $VBoxContainer/VolumeSliderGeneral
@onready var volume_slider_music: HSlider = $VBoxContainer/VolumeSliderMusic
@onready var volume_slider_sfx: HSlider = $VBoxContainer/VolumeSliderSFX
# Creem variables dels nodes "VolumeSlider" per a tots els busos d'àudio corresponents.
@onready var sfx: AudioStreamPlayer = $SFX
# Creem una variable per al node "AudioStreamPlayer" el qual conté un efecte de so.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	flashing_lights_check_box.button_pressed = GameManager.flashing_lights
	resolution_button.select(GameManager.window_size)
	fullscreen_check_box.button_pressed = GameManager.fullscreen
	volume_slider_general.value = GameManager.volume_master
	volume_slider_music.value = GameManager.volume_music
	volume_slider_sfx.value = GameManager.volume_sfx
	# Igualem els valors de les variables de les opcions amb els de les opcions dins del singleton.
	
func _exit_tree() -> void:
# Funció que s'executa quan sortim de l'arbre d'escenes d'aquesta escena.
	GameManager.volume_master = volume_slider_general.value
	GameManager.volume_music = volume_slider_music.value
	GameManager.volume_sfx = volume_slider_sfx.value
	# Guardem el valor del volum dels busos d'àudio dins de les seves variables respectives al singleton.

func _on_resolution_button_item_selected(index: int) -> void:
# Funció que s'executa quan canviem d'opció en el menú desplegable per canviar la resolució.
	match index:
	# Comparem el valor de l'ID de l'ítem seleccionat, llavors actualitzem la resolució de la finestra
	# i actualitzem el valor de la variable "window_size" del singleton.
		0:
		# ID 0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			GameManager.window_size = 0
		1:
		# ID 1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			GameManager.window_size = 1
		2:
		# ID 2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			GameManager.window_size = 2

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
# Funció que s'executa quan canviem el valor de la casella de la finestra completa.
	if toggled_on:
	# Si activem la casella:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		# Canviem el mode de la finestra i seleccionem el mode de finestra completa.
		GameManager.fullscreen = true
		# Declarem que tenim la finestra en pantalla completa.
	else:
	# Si la desactivem:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Canviem el mode de la finestra i seleccionem el mode de finestra.
		GameManager.fullscreen = false
		# Declarem que no tenim la finestra en pantalla completa.

func _on_flashing_lights_check_box_toggled(toggled_on: bool) -> void:
# Funció que s'executa quan canviem el valor de la casella de les llums intermitents.
	if toggled_on:
	# Si activem la casella:
		GameManager.flashing_lights = true
		# Activem les llums intermitents.
	else:
	# Si la desactivem:
		GameManager.flashing_lights = false
		# Desactivem les llums intermitents.

func _on_volume_slider_general_value_changed(value: float) -> void:
# Funció que s'executa quan canviem el valor del control lliscant del volum general.
	AudioServer.set_bus_volume_db(0, value)
	# Actualitzem el valor del bus d'àudio del volum general, que té índex 0.

func _on_volume_slider_music_value_changed(value: float) -> void:
# Funció que s'executa quan canviem el valor del control lliscant del volum de la música.
	AudioServer.set_bus_volume_db(1, value)
	# Actualitzem el valor del bus d'àudio del volum de la música, que té índex 1.

func _on_volume_slider_sfx_value_changed(value: float) -> void:
# Funció que s'executa quan canviem el valor del control lliscant del volum dels efectes de so.
	AudioServer.set_bus_volume_db(2, value)
	# Actualitzem el valor del bus d'àudio del volum dels efectes de so, que té índex 2.

func _on_volume_slider_sfx_drag_started() -> void:
# Funció que s'executa cada cop que es comença a moure la barra del volum dels efectes de so.
	sfx.play()
	# Reproduïm un efecte de so, així es pot detectar el canvi de volum.
