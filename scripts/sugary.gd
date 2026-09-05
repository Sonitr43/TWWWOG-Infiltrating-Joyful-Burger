# Script per l'enemic Sugary.
extends CharacterBody2D

@export var acceleration: int = 8

@onready var marker_2d_left: Marker2D = $Marker2DLeft
@onready var marker_2d_right: Marker2D = $Marker2DRight

func _physics_process(delta: float) -> void:
	update_movement(delta)
	move_and_slide()
	
func update_movement(delta: float) -> void:
	velocity.x = move_toward(marker_2d_left.global_position.x, marker_2d_right.global_position.x, delta * acceleration)
	
