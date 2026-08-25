# Script per donar animacions als botons de la pantalla de selecció de personatge.

extends TextureButton

var tween_time = 0.2
# El temps que triguen els tweens.

@onready var scroll_bg: TextureRect = $"../../../ScrollingBG/Control/TextureRect"
# Obtenim el node del fons lliscant.

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
# Funció que s'executa quan el ratolí passa per amunt del botó.
	var tween = create_tween()
	# Creem una variable per simplificar la crida dels tweens.
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), tween_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	# Quan el ratolí estigui amunt del botó, augmentem la seva mida amb un tween.
	
	if get_name() == "ButtonGumball":
	# Si el nom del node del botó el qual estem seleccionant és el de Gumball:
		tween.tween_property(scroll_bg, "modulate", Color("82f4ff"), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if get_name() == "ButtonDarwin":
	# Si el nom del node del botó el qual estem seleccionant és el de Gumball:
		tween.tween_property(scroll_bg, "modulate", Color("ffc581"), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD) 

func _on_mouse_exited() -> void:
# Funció que s'executa quan el ratolí surt del botó.
	create_tween().tween_property(self, "scale", Vector2(1, 1), tween_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	# Quan el ratolí ja no estigui amunt del botó, retornem la seva mida original amb un tween.
	
func set_pivot() -> void:
# Funció per actualitzar el pivot del botó.
	pivot_offset = size/2
	# Actualitzem l'offset del pivot perquè els botons no es descol·loquin quan actualitzem la seva mida.
