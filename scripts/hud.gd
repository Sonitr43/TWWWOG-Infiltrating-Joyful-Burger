# Script pels elements del HUD.
extends Control

@onready var lifes: Label = $Lifes
# Creem una variable pel text de les vides del HUD.
@onready var score: Label = $Score
# Creem una variable pel text de la puntuació del HUD.
@onready var hp: Label = $HP
# Creem una variable pel text de la salut del HUD.

func _physics_process(_delta: float) -> void:
# Funció que es crida cada frame.
	match GameManager.language:
	# Comparem el valor de la variable del llenguatge en el singleton per determinar
	# el llenguatge del marcador de les vides.
		0:
			lifes.text = "Lifes: " + str(GameManager.lifes)
		1:
			lifes.text = "Vidas: " + str(GameManager.lifes)
		2:
			lifes.text = "Vides: " + str(GameManager.lifes)
	score.text = str(GameManager.score)
	hp.text = str(GameManager.health)
	# Actualitzem els textos de la vida, salut i puntuació.
