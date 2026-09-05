# Script per l'enemic Hot Dog, el qual és una extensió de "walking_enemy.gd".
extends "res://scripts/walking_enemy.gd"

func face_player() -> void:
# Funció per forçar l'enemic a mirar al jugador quan estigui per atacar.
	if player.global_position.x < global_position.x:
	# Si la posició gloal del jugador en l'eix X és menor a la de l'enemic:
	# (El jugador està a l'esquerra)
		flip_sprite = 1
		# Girem l'sprite.
		direction = -1
		# Canviem la direcció a l'esquerra.
		damage_area_extended.get_child(0).position.x = -15
		# Ajustem la posició del CollisionShape2D de la DamageAreaExtended.
	else:
	# Sinó (el jugador està a la dreta):
		flip_sprite = -1
		# Girem l'sprite al seu sentit original.
		direction = 1
		# Canviem la direcció a la dreta.
		damage_area_extended.get_child(0).position.x = 15
		# Ajustem la posició del CollisionShape2D de la DamageAreaExtended.

	update_sprite()
	# Actualitzem l'sprite de l'enemic.
	
func _on_detection_area_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una àrea entra en l'àrea de detecció de Hot Dog.
	if area.is_in_group("PlayerCoinArea") and not preparingAttack and notDead:
	# Si l'àrea que entra està en el grup de l'àrea de les monedes del jugador:
	# (Aquesta àrea ja serveix bé per això, no fa falta fer una de nova)
		face_player()
		# Cridem la funció que força a l'enemic a mirar al jugador.
		velocity.x = 0
		# Detenim a l'enemic.
		preparingAttack = true
		# Declarem que estem per atacar.
		animated_sprite_2d.play("pre-attack")
		# Reproduïm l'animació de Hot Dog on es prepara per atacar.
		await get_tree().create_timer(0.5).timeout
		# Creem un temporitzador i esperem a que s'acabi.
		
		if not notDead:
		# Si l'enemic ha mort:
			return
			# Retornem.
		animated_sprite_2d.play("attack")
		# Reproduïm l'animació d'atac de Hot Dog.
		damage_area_extended.monitoring = true
		# Comencem a monitorejar si el jugador ha entrat en l'àrea de dany extendida
		# de l'enemic.
		velocity.y -= 150
		# Fem que l'enemic salti.
		random = randi_range(speed, 125)
		# Generem un valor aleatori.
		velocity.x = direction * random
		# Fem que l'enemic es mogui multiplicant la seva direcció pel valor aleatori.
		await get_tree().create_timer(0.5).timeout
		# Creem un altre temporitzador i esperem a que s'acabi.
		
		if not notDead:
		# Si l'enemic ha mort:
			damage_area_extended.monitoring = false
			# Deixem de monitorejar l'àrea de dany extendida de l'enemic.
			return
			# Retornem.
		preparingAttack = false
		# Declarem que ja no està atacant l'enemic.
		animated_sprite_2d.play("walk")
		# Reproduïm l'animació de caminar de l'enemic.
		damage_area_extended.monitoring = false
		# Deixem de monitorejar l'àrea de dany extendida de l'enemic.

func _on_damage_area_extended_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una àrea entra en l'àrea de l'enemic que fa dany al jugador.
	if area.is_in_group("PlayerDamageArea"):
	# Si l'àrea està dins del grup de l'àrea de rebre dany del jugador:
		player.get_damage()
		# Cridem la funció dins del node del jugador per rebre dany.
