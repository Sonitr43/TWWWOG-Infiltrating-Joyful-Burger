# Script per donar animacions als botons de la GUI.

extends TextureButton
var tween_time = 0.2

func _ready() -> void:
	set_pivot()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# Conectem les senyals "mouse_entered" i "mouse_exited" del node
	# "TextureButtron" amb els "callables" de funcions de noms similars.
	# En GDScript, una funció sense els () s'interpreta com una referencia a
	# aquesta, en comptes d'una trucada. Per tant, escriure una funció sense
	# els () crea un "callable" per obtenir el seu valor.
	
	# Convé fer això per als botons perquè llavors no hem de tornar a fer les
	# connexions per a cada botó al qual li donem aquest script.
	
func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), tween_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	# Quan el ratolí estigui amunt del botó, augmentem la seva mida amb un tween.
	
func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2(1, 1), tween_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# Quan el ratolí ja no estigui amunt del botó, retornem la seva mida original amb un tween.
	
func set_pivot() -> void:
	pivot_offset = size/2
	# Actualitzem l'offset del pivot perquè els botons no es descol·loquin quan actualitzem la seva mida.
