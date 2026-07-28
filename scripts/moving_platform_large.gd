extends Path2D

@export var path_time = 1.0
@export var looping = false
@export var ease: Tween.EaseType
@export var transition: Tween.TransitionType
@export var path_follow_2d: PathFollow2D
# Exportem certes variables que ens ajuden a modificar certes propietats de les plataformes que es mouen més fàcilment.

func _ready():
	move_tween()
	
func move_tween():
# Funció per crear i començar els tweens que mouen les plataformes.
	var tween = get_tree().create_tween().set_loops()
	# Declarem una variable per poder crear el moviment de les plataformes utilitzant tweens fàcilment.
	# Primer obtenim l'arbre de l'escena, després li creem un tween i fem que s'executi infinitament.
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, path_time).set_ease(ease).set_trans(transition)
	# Creem el primer tween.
	# Utilitzant la funció tween_property(), agafem el node "PathFollow2D" que té la propietat "Progress Ratio",
	# la qual ens diu en quin punt del tween es trova l'objecte (0 = no ha començat, 1 = ha acabat), i l'assignem
	# 1 perquè s'executi el tween. Finalment l'assignem el tipus d'easing i transició.
	if !looping:
	# Si 
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, path_time).set_ease(ease).set_trans(transition)
	else:
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, 0.0).set_ease(ease).set_trans(transition)
