extends Control
@onready var label_mode_1: Label = $Panel/VBoxContainer/Lbl_Mode1
@onready var label_mode_2: Label = $Panel/VBoxContainer/Lbl_Mode2
@onready var label_mode_3: Label = $Panel/VBoxContainer/Lbl_Mode3

func _ready():
	update_scores()

func update_scores():
	# MODALITÀ 1 (TEMPO):
	label_mode_1.text = "Tempo Sopravvissuto: " + GameData.format_time(GameData.records["mode_1"])
	# MODALITÀ 2 (ONDATE):
	label_mode_2.text = "Ondate Completate: " + str(GameData.records["mode_2"])
	# MODALITÀ 3 (INFINITA):
	label_mode_3.text = "Record Infinito: " + GameData.format_time(GameData.records["mode_3"])

func _on_back_pressed() -> void:
	self.visible = false
	get_parent()._on_back_pressed()
