extends Path2D

@export var path_time = 1.0
# El temps que triguen els tweens.
@export var looping = false
# Bool per determinar si volem que una plataforma retorni o no immediatament (ignorant "path_time") a la seva posició original després de fer el primer tween.
@export var easing: Tween.EaseType
# El tipus d'easing del tween.
@export var transition: Tween.TransitionType
# El tipus de transició del tween.
@export var path_follow_2d: PathFollow2D
# Exportem el node "PathFollow2D" per poder accedir a certa informació i variables que necessitem per executar els tweens.

func _ready():
	move_tween()
	# En començar el nivell, executem la funció que maneja els tweens.
	
func move_tween():
# Funció per crear i començar els tweens que mouen les plataformes.
	# Els tweens s'executen un darrere l'altre.
	var tween = get_tree().create_tween().set_loops()
	# Declarem una variable per poder crear el moviment de les plataformes utilitzant tweens fàcilment.
	# Primer obtenim l'arbre de l'escena, després li creem un tween i fem que s'executi infinitament.
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, path_time).set_ease(easing).set_trans(transition)
	# Creem el primer tween.
	# Utilitzant la funció tween_property(), agafem el node "PathFollow2D" que té la propietat "Progress Ratio",
	# la qual ens diu en quin punt del tween es trova l'objecte (0 = no ha començat, 1 = ha acabat), i l'assignem
	# 1 perquè porti la plataforma a la posició final del tween. Finalment l'assignem el tipus d'easing i transició.
	if !looping:
	# Si no volem que una plataforma regresi a la seva posició original immediatament després de finalitzar el primer tween:
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, path_time).set_ease(easing).set_trans(transition)
		# El mateix que el primer tween, però portem la plataforma a la posició inicial del tween.
	else:
	# Sinó:
		tween.tween_property(path_follow_2d, "progress_ratio", 0.0, 0.0).set_ease(easing).set_trans(transition)
		# El mateix que el tween d'amunt, però és immediat (0 segons).
