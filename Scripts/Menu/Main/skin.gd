extends Panel

@onready var seleziona1 = $HBoxContainer/Seleziona
@onready var seleziona2 = $HBoxContainer/Seleziona2
@onready var seleziona3 = $HBoxContainer/Seleziona3
@onready var nodo = get_parent()

func _ready():
	seleziona2.disabled=true
	seleziona3.disabled=true
	if(GameData.monete_stella>=80):
		seleziona2.disabled=false
	if(GameData.monete_stella>=140):
		seleziona3.disabled=false

func _on_seleziona_pressed() -> void:
	GameData.selected_ship_scene = preload("res://scenes/Spaceships/Players/StarChaser_Player.tscn")
	print("Nave selezionata: StarChaser")

func _on_seleziona_2_pressed() -> void:
	$HBoxContainer2/Sprite2D3.visible=false
	$HBoxContainer2/MoneteLabel.visible=false
	GameData.add_monete(-80)
	GameData.selected_ship_scene = preload("res://scenes/Spaceships/Players/Flash_Player.tscn")
	print("Nave selezionata: Flash")

func _on_seleziona_3_pressed() -> void:
	$HBoxContainer2/Sprite2D4.visible=false
	$HBoxContainer2/MoneteLabel2.visible=false
	GameData.add_monete(-140)
	GameData.selected_ship_scene = preload("res://scenes/Spaceships/Players/Aqua.tscn")
	print("Nave selezionata: Aqua")
	
func _on_back_pressed() -> void:
	# Controllo di sicurezza se il metodo esiste nel genitore
	if nodo.has_method("turn_on"):
		nodo.turn_on(self)
	else:
		self.visible = false
