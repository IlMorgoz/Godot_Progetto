extends Panel
@onready var btn1=$HBoxContainer/Btn1
@onready var btn2=$HBoxContainer/Btn2
@onready var btn3=$HBoxContainer/Btn3
@onready var nodo=get_parent()

func _ready():
	btn1.disabled=true
	btn2.disabled=true
	btn3.disabled=true
	if(MoneteManager.monete_stella>=5):
		btn1.disabled=false
	if(MoneteManager.monete_stella>=20):
		btn2.disabled=false
	if(MoneteManager.monete_stella>=100):
		btn3.disabled=false
		
func _on_btn_1_pressed() -> void:
	$Sprite2D2.visible=false
	$MoneteLabel3.visible=false
	MoneteManager.add_monete(-5)

func _on_btn_2_pressed() -> void:
	$Sprite2D3.visible=false
	$MoneteLabel.visible=false
	MoneteManager.add_monete(-20)

func _on_btn_3_pressed() -> void:
	$Sprite2D4.visible=false
	$MoneteLabel2.visible=false
	MoneteManager.add_monete(-100)

func _on_back_pressed() -> void:
	nodo.turn_on(self)
