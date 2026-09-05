# Script pels checkpoints.
extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D
# Creem una variable pel node "Marker2D" dins de l'escena del checkpoint. Aquest node és el que
# emmagatzema la posició exacta del checkpoint per saber on col·locar el jugador quan reaparegui.
@onready var hud: CanvasLayer = get_tree().root.find_child("HUD", true, false)
# Importem el node del HUD de l'arbre d'escenes.
@onready var sfx: AudioStreamPlayer = $SFX
# Carreguem en una variable l'efecte de so del checkpoint.

func _ready() -> void:
# Funció per quan el node i els seus fills entren en l'arbre d'escenes.
	update_sprite()
	# Cridem aquesta funció en iniciar-se l'escena perquè les visuals dels checkpoints s'actualitzin
	# correctament.

func _on_area_2d_body_entered(_body: Node2D) -> void:
# Funció per quan un cos ha entrat en una àrea 2D.
	GameManager.checkpoint_pos = marker_2d.global_position
	# Igualem la posició en la qual volem que el jugador aparegui amb la posició global del Marker2D
	# del checkpoint (és a dir, la posició del checkpoint).
	if GameManager.previous_checkpoint_node:
	# Si hi ha un checkpoint previ activat:
		GameManager.previous_checkpoint_node.update_sprite()
		# Actualitzem el seu sprite.
	else:
	# Sinó:
		sfx.play()
		# Reproduïm l'efecte de so en activar el checkpoint nou.
	GameManager.previous_checkpoint_node = self
	# Determinem la variable del node del checkpoint previ amb el de l'actual.
	update_sprite()
	# Actualitzem l'sprite en aquest node.
	if GameManager.health < 3:
	# Si el jugador no té la salut al màxim:
		GameManager.health += 1
		# Li donem 1 punt de salut.
	
func update_sprite():
# Funció per actualitzar l'sprite d'un checkpoint depenent de si està actiu o no.
	if marker_2d.global_position == GameManager.checkpoint_pos:
	# Si coincideixen la posició global del Marker2D (la posició exacta del checkpoint) i la posició
	# en la qual volem que el jugador aparegui:
		if GameManager.PlayerCharacter == 0:
		# Si estem jugant amb Gumball:
			frame = 1
			# Utilitzem el frame de l'sprite del checkpoint que correspon amb Gumball.
		if GameManager.PlayerCharacter == 1:
		# Si estem jugant amb Darwin:
			frame = 2
			# Utilitzem el frame de l'sprite del checkpoint que correspon amb Darwin.
	else:
	 # Sinó coincideixen (o sigui, el checkpoint no està activat):
		frame = 0
		# Utilitzem el frame de l'sprite del checkpoint inactiu.
