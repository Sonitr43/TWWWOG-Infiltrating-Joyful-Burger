extends CanvasLayer

@onready var black_rect = get_tree().root.find_child("BlackTransition", true, false)
@onready var item_list: ItemList = $Control/VBoxContainer/ItemList
@onready var exit_tutorial: CanvasLayer = $"."
@onready var music: AudioStreamPlayer = $"../Music"

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	match index:
		0:
			GameManager.current_lv += 1
			black_rect.layer = 4
			var tween = create_tween()
			tween.tween_property(black_rect.find_child("ColorRect", true, false), "modulate:a", 1, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			create_tween().tween_property(music, "volume_db", -80, 3)
			await tween.finished
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/level elements/gui/lv_loader.tscn")
		1:
			GameManager.shouldMove = true
			exit_tutorial.visible = false
			item_list.set_item_disabled(0, true)
			item_list.set_item_disabled(1, true)
