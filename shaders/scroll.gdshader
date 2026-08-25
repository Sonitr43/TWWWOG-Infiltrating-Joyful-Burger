// Shader per al fons lliscant.
shader_type canvas_item;

uniform float speed = 0.2;
// Creem una variable del tipus float per a la velocitat del lliscament.

void vertex() {
// Funció que s'executa per a cada vèrtex d'una malla durant l'etapa de transformació de vèrtexs.
// S'utilitza per modificar la posició, coordenades UV, entre altres dates del vèrtex abans que Godot
// els projecti en pantalla.
// És del tipus "void", per tant, no retorna res.
	UV.x -= TIME * speed;
	UV.y -= TIME * speed;
	// Modifiquem les coordenades de la textura en les eixos X i Y utilitzant TIME (el temps
	// transcorregut des que s'ha executat el shader) multiplicat per la variable declarada
	// prèviament.
}