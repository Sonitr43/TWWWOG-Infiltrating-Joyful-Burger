# Script per manejar el diàleg de Larry.
extends Area2D

@onready var dialogue_bubble: Sprite2D = $DialogueBubble
# Creem una variable per l'sprite que indica que hi ha diàleg.

var player
# Creem una variable pel jugador, la qual li donem un valor en _ready().
var is_player_close: bool = false
# Variable per determinar si el jugador està a prop de l'àrea o no.
var is_dialogue_active: bool = false
# Variable per determinar si hi ha diàleg actiu o no.
var dialogue_path = "res://dialogues/tutorial/"
# Variable per emmagatzemar una part de la ruta on estan els diàlegs.
var dialogue_full
# Variable per emmagatzemar la ruta completa del diàleg que aquet node de Larry reproduirà.
@onready var sprite_2d: Sprite2D = $Sprite2D
# Carreguem el node de l'sprite de Larry.
@onready var marker_2d: Marker2D = $Marker2D
# Carreguem el node del Marker2D de Larry.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entra en l'arbre d'escenes.
	await get_tree().process_frame
	# Esperem a que tot l'arbre d'escenes es carregui per tal de poder trovar el node del jugador.
	player = get_tree().root.find_child("Player", true, false)
	# Obtenim el node del jugador dins de l'arbre d'escenes.
	var dialogue_name = get_name()
	# Obtenim el nom d'aquest node, el qual el seu diàleg corresponent comparteix.
	dialogue_full = load(dialogue_path + dialogue_name + ".dialogue")
	# Carreguem finalment el diàleg en qüestió d'aquest node.
	# Hem declarat la variable fora del _ready() perquè sinó _process() no podría accedir
	# al seu contingut, i tampoc li hem donat directament la ruta fora del _ready()
	# perquè no es pot obtenir el nom del node amb get_name() sense que ja hagi entrat
	# en l'arbre d'escenes.
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	# Connectem les senyals dels diàlegs per quan comencen i acaben.

func _on_body_entered(_body: Node2D) -> void:
# Funció per quan un cos entra en l'àrea 2D.
	is_player_close = true
	# Declarem que el jugador està a prop.
	dialogue_bubble.visible = true
	# Fem visible la bombolla de diàleg.

func _on_body_exited(_body: Node2D) -> void:
# Funció per quan un cos surt de l'àrea 2D.
	is_player_close = false
	# Declarem que el jugador ha sortit.
	dialogue_bubble.visible = false
	# Amaguem la bombolla de diàleg.
	
func _on_dialogue_started(_dialogue):
# Funció que s'executa quan un diàleg comença.
	GameManager.shouldMove = false
	# Fem que el jugador no es pugui moure.
	is_dialogue_active = true
	# Declarem que hi ha diàleg actiu.
	sprite_2d.frame = 1
	# Canviem el frame de Larry quan parla.
	if player.global_position > marker_2d.global_position:
	# Si el jugador està a la dreta de Larry:
		sprite_2d.flip_h = true
		# Li girem l'sprite horitzontalment.
	else:
	# Sinó:
		sprite_2d.flip_h = false
		# El deixem mirant a l'esquerra.
	
func _on_dialogue_ended(_dialogue):
# Funció que s'executa quan un diàleg acaba.
	GameManager.shouldMove = true
	# Fem que el jugador ja es pugui moure.
	is_dialogue_active = false
	# Declarem que ja no hi ha diàleg actiu.
	sprite_2d.frame = 0
	# Canviem el frame de Larry quan ja no parla.

func _process(_delta: float) -> void:
# Funció que s'executa cada frame.
	if is_player_close and player.is_on_floor() and Input.is_action_just_pressed("move_up") and not is_dialogue_active:
	# Si el jugador està a prop de Larry i pulsa el botó d'amunt:
		DialogueManager.show_dialogue_balloon(dialogue_full, "start")
		# Carreguem el diàleg.
