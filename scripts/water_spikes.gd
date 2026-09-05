# Script per les punxes utilitzades sota l'aigua.
extends Area2D

var player
# Creem una variable pel jugador.

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'escena.
	await get_tree().process_frame
	# Esperem a que l'arbre s'executi totalment.
	player = get_tree().root.find_child("Player", true, false)
	# Carreguem el node del jugador.

func _on_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una àrea entra en aquesta àrea.
	if area.is_in_group("PlayerDamageArea"):
	# Si l'àrea està en el grup que maneja l'area de dany del jugador.
		player.get_damage()
		# El jugador rep dany.
