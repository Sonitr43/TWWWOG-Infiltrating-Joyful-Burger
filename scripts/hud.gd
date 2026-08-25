# Script pels elements del HUD.
extends Control

@onready var lifes: Label = $Lifes
# Creem una variable pel text de les vides del HUD.
@onready var score: Label = $Score
# Creem una variable pel text de la puntuació del HUD.
@onready var hp: Label = $HP
# Creem una variable pel text de la salut del HUD.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	lifes.text = lifes.text + str(GameManager.lifes)
	hp.text = hp.text + str(GameManager.health)
	update_score()
	# Actualitzem els textos de la vida, salut i puntuació.
	
func update_score() -> void:
# Funció per actualitzar la puntuació.
	score.text = str(GameManager.score)
