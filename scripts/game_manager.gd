# Script global (un "singleton")
extends Node

# NIVELLS
var current_lv = 1
# Guardem en una variable el nivell en el què el jugador es trova.
var lv_completed = false
# Variable per saber si el jugador ha passat de nivell o no.

# VARIABLES DELS PERSONATGES
var PlayerCharacter: int = -1
# Variable per saber amb quin personatge estem jugant (0: Gumball, 1: Darwin).
var health: int = 3
# Variable per guardar la salut del jugador.
var isDead = false
# Variable per a poder determinar facilment en l'script de les físiques del jugador
# si ha mort o no.
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
