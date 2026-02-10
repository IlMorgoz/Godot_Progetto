extends Control

# Qui "colleghiamo" le etichette della scena al codice.
# Se hai cambiato nome ai nodi nell'editor, devi cambiarli anche qui!
@onready var label_mode_1: Label = $Panel/VBoxContainer/Lbl_Mode1
@onready var label_mode_2: Label = $Panel/VBoxContainer/Lbl_Mode2
@onready var label_mode_3: Label = $Panel/VBoxContainer/Lbl_Mode3

func _ready():
	# Appena apri questo menu, chiama la funzione per aggiornare i testi
	update_scores()

func update_scores():
	# --- SPIEGAZIONE AGGIORNATA ---
	
	# MODALITÀ 1 (TEMPO):
	# 1. GameData.records["mode_1"] -> Prende il valore salvato
	# 2. GameData.format_time(...) -> Lo trasforma in formato "MM:SS"
	label_mode_1.text = "Tempo Sopravvissuto: " + GameData.format_time(GameData.records["mode_1"])

	# MODALITÀ 2 (ONDATE):
	# 1. GameData.records["mode_2"] -> Prende il numero dell'ondata (int)
	# 2. str(...) -> Trasforma il numero in testo per poterlo visualizzare
	label_mode_2.text = "Ondate Completate: " + str(GameData.records["mode_2"])

	# MODALITÀ 3 (INFINITA):
	# Stessa logica della modalità 1, ma pesca il record "mode_3"
	label_mode_3.text = "Record Infinito: " + GameData.format_time(GameData.records["mode_3"])

func _on_back_pressed() -> void:
	# Aggiungo questa funzione se hai un tasto "Indietro" collegato, 
	# altrimenti puoi cancellarla.
	self.visible = false
	# O se usi una transizione di scena:
	# get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
