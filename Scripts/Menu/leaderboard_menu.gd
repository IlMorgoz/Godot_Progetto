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
	# --- SPIEGAZIONE DELLE RIGHE CHE HAI CHIESTO ---
	
	# MODALITÀ 1 (TEMPO):
	# 1. ScoreManager.records["mode_1"] -> Prende il numero (es. 125 secondi)
	# 2. ScoreManager.format_time(...) -> Lo trasforma in "02:05"
	# 3. label_mode_1.text = ... -> Inserisce il testo finale nell'etichetta
	label_mode_1.text = "Tempo Sopravvissuto: " + ScoreManager.format_time(ScoreManager.records["mode_1"])

	# MODALITÀ 2 (ONDATE):
	# 1. ScoreManager.records["mode_2"] -> Prende il numero (es. 5)
	# 2. str(...) -> Trasforma il numero 5 nel testo "5" (Le label accettano solo testo!)
	label_mode_2.text = "Ondate Completate: " + str(ScoreManager.records["mode_2"])

	# MODALITÀ 3 (INFINITA):
	# Stessa logica della modalità 1, ma pesca il record "mode_3"
	label_mode_3.text = "Record Infinito: " + ScoreManager.format_time(ScoreManager.records["mode_3"])

func _on_btn_back_pressed():
	# Codice per tornare al menu principale
	if has_node("/root/FadeTransition"):
		FadeTransition.change_scene("res://scenes/Menu/Main_Menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
