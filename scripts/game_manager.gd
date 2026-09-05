# Script global (un "singleton")
extends Node

# CONFIGURACIONS
var flashing_lights: bool = false
# Variable que determina si el joc pot reproduir certs events que poden ser perjudicials per a persones amb epilèpsia.
var window_size: int = 0
# Resolució de la finestra. Utilitzem un "int" perquè l'opció en les configuracions emmagatzema les diverses
# resolucions amb IDs (per exemple, 0 = 1280x720). Per tant, emmagatzem l'ID de la resolució per fer-ho més fàcil.
var fullscreen: bool = false
# Bool que determina si tenim la finestra completa o no.
var volume_master: float = -10
var volume_music: float = 0
var volume_sfx: float = 0
# Variables per emmagatzemar el valor dels controls lliscants del volum dels busos d'àudio.

# NIVELLS
var current_lv: int = 0
# Guardem en una variable el nivell en el què el jugador es trova.
var current_area: int = 0
# Variable per saber en quina àrea/secció del nivell ens trobem.
var level_beaten: bool = false
# Variable per saber si el jugador s'ha passat un nivell o no.
var gameBeaten: bool = false
# Variable per saber si el jugador s'ha passat el joc.

# VARIABLES DELS PERSONATGES
var PlayerCharacter: int = 0
# Variable per saber amb quin personatge estem jugant (0: Gumball, 1: Darwin).
var health: int = 3
# Variable per guardar la salut del jugador.
var shouldMove: bool = true
# Variable per determinar si el jugador es pot moure o no.
var lifes: int = 3
# Variable per guardar les vides restants del jugador.

# CHECKPOINTS
var checkpoint_pos: Vector2 = Vector2(-999, -999)
# La posició en la qual volem que el jugador aparegui. La deixem amb aquests valors perquè el jugador
# mai estarà en aquesta posició, per tant, podem saber si ha tocat un checkpoint comparant aquesta
# posició.
var previous_checkpoint_node: Sprite2D = null
# Variable que guardarà el node de l'últim checkpoint que el jugador ha tocat. Això és per les visuals
# d'un checkpoint previ quan toquem un de nou.

# ELEMENTS NIVELLS
var coins: int = 0
# Variable per guardar les monedes que el jugador ha recol·lectat en un nivell.
var score: int = 0
# Variable per guardar la puntuació del jugador.
var points_milestone: int = 5000
# Variable per determinar quants punts ha d'obtenir el jugador per tal d'obtenir una vida extra.

var life_sfx
# Creem una variable buida que emmagatzemarà l'efecte de so que es reprodueix quan el jugador obté una vida
# extra.
func give_1up() -> void:
# Funció que es crida quan el jugador obté una vida extra.
	if life_sfx == null:
	# Si la variable de l'efecte de so de les vides està buida:
		life_sfx = AudioStreamPlayer.new()
		# Instanciem la classe del node "AudioStreamPlayer", el qual reprodueix so.
		life_sfx.stream = load("res://assets/sounds/1-up.ogg")
		# A la propietat "stream" (la qual és la que emmagatzema la ruta del so que volem reproduir amb aquest
		# node) l'assignem la ruta del so de les vides i el carreguem amb "load()".
		life_sfx.bus = "SFX"
		# Declarem que el bus de l'àudio de les vides és el dels efectes de so.
		add_child(life_sfx)
		# Afegim aquest node fill a l'escena.
		
	life_sfx.play()
	# Reproduïm l'efecte de so.
	lifes += 1
	# Li sumem una vida al jugador.

func add_points(points: int) -> void:
# Funció per sumar-li punts al marcador.
	var _previous_score = score
	# En una variable, emmagatzemem la puntuació prèvia (la que el jugador tenia abans de que li sumem punts).
	score += points
	# Li sumem els punts al marcador.
	
	while score >= points_milestone:
	# Mentres que la puntuació actual sigui major o igual a la puntuació que el jugador ha d'alcançar per
	# obtenir una vida extra:
		give_1up()
		# Cridem la funció que li dona una vida extra al jugador.
		points_milestone += 5000
		# Li sumem 5000 punts més a la puntuació necessària per obtenir una vida extra, així el jugador
		# sempre ha d'obtenir 5000 punts per obtenir-ne d'una.
