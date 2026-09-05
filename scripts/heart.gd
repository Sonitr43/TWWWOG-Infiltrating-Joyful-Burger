# Script pels cors que augmenten la vida del jugador.
extends Area2D

@onready var hud: CanvasLayer = get_tree().root.find_child("HUD", true, false)
# Carreguem el node del HUD en una variable.
@onready var heal_sfx: AudioStreamPlayer = $HealSFX
# Carreguem el node de l'àudio de l'efecte de so de la curació.
@onready var sprite_2d: Sprite2D = $Sprite2D
# Carreguem el node de l'sprite del cor.
var isObtained: bool = false
# Creem una variable per determinar si hem obtingut el cor o no.

func _on_body_entered(_body: Node2D) -> void:
# Funció que s'executa quan un cos entra en l'àrea del cor.
	if !isObtained:
	# Si no hem obtingut el cor encara:
		isObtained = true
		# Declarem que ja l'hem obtingut.
		heal_sfx.play()
		# Reproduïm l'efecte de so de curació.
		sprite_2d.visible = false
		# Amaguem l'sprite del cor.
		if GameManager.health < 3:
		# Si el jugador no té la salut al màxim:
			GameManager.health += 1
			# Li sumem 1 punt de salut.
		else:
		# Sinó:
			GameManager.add_points(200)
			# Li donem 200 punts al jugador.

func _on_heal_sfx_finished() -> void:
# Funció que s'executa quan l'efecte de so de curació s'acava.
	queue_free()
	# Esborrem aquest node.
