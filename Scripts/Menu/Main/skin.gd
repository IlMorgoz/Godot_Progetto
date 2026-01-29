extends Panel

@onready var seleziona1 = $Seleziona
@onready var seleziona2 = $Seleziona2
@onready var seleziona3 = $Seleziona3
@onready var nodo = get_parent()

func _on_seleziona_pressed() -> void:
	Global.selected_ship_scene = preload("res://scenes/Spaceships/Players/StarChaser_Player.tscn")

func _on_seleziona_2_pressed() -> void:
	Global.selected_ship_scene = preload("res://scenes/Spaceships/Players/Flash_Player.tscn")

func _on_seleziona_3_pressed() -> void:
	Global.selected_ship_scene = preload("res://scenes/Spaceships/Players/Aqua.tscn")
	
func _on_back_pressed() -> void:
	nodo.turn_on(self)
