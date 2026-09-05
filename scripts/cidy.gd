# Script per l'enemic Cidy, el qual és una extensió de l'script de les plataformes que es mouen.
extends "res://scripts/moving_platform_large.gd"

@export var position_y_initial: float
# Variable exportada per la posició inicial en l'eix Y del tween.
@export var position_y_final: float
# Variable exportada per la posició final en l'eix Y del tween.
@export var y_tween_time: float
# Variable exportada pel temps que triga el tween de l'eix Y.
@onready var enemy_offset: Node2D = $PathFollow2D/EnemyOffset
# Carreguem en una variable el node "EnemyOffset", el qual és un Node2D per poder fer fàcilment el tween en l'eix Y.
var player
# Creem una variable buida del jugador, la qual li assignarem el node del jugador en _ready().

func _ready() -> void:
# Funció que s'executa quan el node i els seus fills entren en l'arbre d'escenes.
	await get_tree().process_frame
	# Esperem a que tot l'arbre es carregui.
	player = get_tree().root.find_child("Player", true, false)
	# Carreguem el node del jugador ara que ja està carregat l'arbre d'escenes.
	animated_sprite_2d = $PathFollow2D/EnemyOffset/AnimatableBody2D/AnimatedSprite2D
	# Utilitzem aquesta variable de l'sprite animat dins de l'script original de les plataformes
	move_tween()
	# En començar el nivell, executem la funció que maneja els tweens.
	
	var vertical_tween = enemy_offset.create_tween().set_loops()
	# Creem aquesta variable per simplificar la creació dels tweens d'EnemyOffset.
	vertical_tween.tween_property(enemy_offset, "position:y", position_y_initial, y_tween_time).set_ease(easing).set_trans(transition)
	vertical_tween.tween_property(enemy_offset, "position:y", position_y_final, y_tween_time).set_ease(easing).set_trans(transition)
	# Creem dos tweens, un per la posició inicial i la posició final en l'eix Y que volem que l'enemic faci.

func _on_damage_area_area_entered(area: Area2D) -> void:
# Funció que s'executa quan una àrea entra en l'àrea de dany de l'enemic.
	if area.is_in_group("PlayerDamageArea"):
	# Si l'àrea està dins del grup de l'àrea de dany del jugador:
		player.get_damage()
		# Cridem la funció del jugador per rebre dany.
