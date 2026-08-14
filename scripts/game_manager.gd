# Script global (un "singleton")
extends Node

var current_lv = 1
# Guardem en una variable el nivell en el què el jugador es trova.

var PlayerCharacter: int = -1
# Variable per saber amb quin personatge estem jugant (0: Gumball, 1: Darwin).

var health: int = 3
# Variable per guardar la salut del jugador.
var isDead = false
# Variable per a poder determinar facilment en l'script de les físiques del jugador
# si ha mort o no.
var lifes: int = 3
# Variable per guardar les vides restants del jugador.
