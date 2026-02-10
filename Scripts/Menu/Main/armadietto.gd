extends Panel

@onready var panel1 : Panel =  $Miglioramenti
@onready var panel2 : Panel = $Skin
@onready var bottone1 : Button = $Upgrades
@onready var bottone2 : Button = $Costumi
@onready var bottone3 : Button = $Icone
@onready var back := $"../Back"
@onready var title := $Label
@onready var panel3 : Panel= $Icons
func _ready() -> void:
	panel1.visible=false
	panel2.visible=false
	bottone1.visible=true
	bottone2.visible=true
	bottone3.visible=true
	back.visible=true
	
func _on_costumi_pressed() -> void:
	panel2.visible=true
	turn_off()

func _on_upgrades_pressed() -> void:
	panel1.visible=true
	turn_off()
	
func _on_icone_pressed() -> void:
	panel3.visible=true
	turn_off()

func turn_off() -> void:
	bottone1.visible=false
	bottone2.visible=false
	bottone3.visible=false
	back.visible=false
	title.visible=false
	
func turn_on(pannello) -> void:
	bottone1.visible=true
	bottone2.visible=true
	bottone3.visible=true
	back.visible=true
	title.visible=true
	pannello.visible=false

func _on_mod_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_mod_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game/game_mode_waves.tscn")

func _on_mod_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game/Game_Endless.tscn")
