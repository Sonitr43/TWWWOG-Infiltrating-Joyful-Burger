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
	lifes.text = "Vides: " + str(GameManager.lifes)
	score.text = str(GameManager.score)
	hp.text = str(GameManager.health)
	# Actualitzem els textos de la vida, salut i puntuació.
