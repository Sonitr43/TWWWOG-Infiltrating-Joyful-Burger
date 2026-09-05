# Script per les monedes.
extends Area2D

@onready var hud_scene = get_tree().root.find_child("HUD", true, false)
# Busquem el node de l'escena del HUD dins de l'arbre d'escenes.
@onready var score: Label = hud_scene.find_child("Score", true, false)
# Creem una variable per accedir al text de la puntuació.
@onready var coin_sfx: AudioStreamPlayer = $CoinSFX
# Carreguem el node de l'àudio de l'efecte de so de les monedes.
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Carrguem el node de l'sprite de la moneda.
var isObtained: bool = false
# Creem una variable per determinar si hem obtingut la moneda o no.

func _on_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una Area2D entra en aquesta Area2D.
	if !isObtained and area.is_in_group("PlayerCoinArea"):
	# Si l'àrea està dins del grup que pertany a l'àrea de les monedes del jugador i no hem obtingut la moneda:
		isObtained = true
		# Declarem que ja hem obtingut la moneda.
		coin_sfx.play()
		# Reproduïm l'efecte de so de les monedes.
		animated_sprite_2d.visible = false
		# Fem invisible l'sprite de la moneda.
		GameManager.coins += 1
		# Indiquem al joc que el jugador ha obtingut 1 moneda.
		GameManager.add_points(50)
		# Li sumem 50 punts al jugador.

func _on_coin_sfx_finished() -> void:
# Funció que s'executa quan l'efecte de so s'acava de reproduir.
	queue_free()
	# Eliminem el node de l'escena.
