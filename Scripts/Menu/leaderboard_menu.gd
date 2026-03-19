extends Control

# RECORD
@onready var label_mode_1: Label = $PanelContainer/Panel/VBoxContainer/Lbl_Mode1
@onready var label_mode_2: Label = $PanelContainer/Panel/VBoxContainer/Lbl_Mode2
@onready var label_mode_3: Label = $PanelContainer/Panel/VBoxContainer/Lbl_Mode3

# ACHIEVEMENT 
@onready var lbl_a1 = $PanelContainer/Panel2/Achievement/A1
@onready var lbl_a2 = $PanelContainer/Panel2/Achievement/A2
@onready var lbl_a3 = $PanelContainer/Panel2/Achievement/A3

func _ready():
	# Aggiorna i dati subito all'avvio
	update_scores()
	# Collega il segnale per aggiornare in automatico ogni volta che apri il menu!
	visibility_changed.connect(_on_visibility_changed)

# Questa funzione scatta da sola quando il menu appare o scompare
func _on_visibility_changed():
	if visible:
		update_scores()

func update_scores():
	# --- 1. AGGIORNA I RECORD ---
	# MODALITÀ 1 (TEMPO):
	label_mode_1.text = "Tempo Sopravvissuto: " + GameData.format_time(GameData.records["mode_1"])
	# MODALITÀ 2 (ONDATE):
	label_mode_2.text = "Ondate Completate: " + str(GameData.records["mode_2"])
	# MODALITÀ 3 (INFINITA):
	label_mode_3.text = "Record Infinito: " + GameData.format_time(GameData.records["mode_3"])

	# --- 2. AGGIORNA GLI ACHIEVEMENTS ---
	
	# Achievement 1: Primo Sparo
	if GameData.achievements["primo_sparo"] == true:
		lbl_a1.text = "Primo Sangue (Sbloccato)"
		lbl_a1.modulate = Color(0, 1, 0) # Verde
	else:
		lbl_a1.text = "Spara il tuo primo proiettile"
		lbl_a1.modulate = Color(0.6, 0.6, 0.6) # Grigio
		
	# Achievement 2: 10 Kamikaze
	if GameData.achievements["killer_kamikaze"] == true:
		lbl_a2.text = "Sterminatore di Kamikaze!"
		lbl_a2.modulate = Color(0, 1, 0) # Verde
	else:
		# Mostriamo le kill attuali
		var kill_attuali = GameData.nemici_uccisi_mode_1
		lbl_a2.text = "Elimina 10 Kamikaze (" + str(kill_attuali) + "/10)"
		lbl_a2.modulate = Color(0.6, 0.6, 0.6) # Grigio
		
	# Achievement 3: 10 Ufo
	if GameData.achievements["killer_ufo"] == true:
		lbl_a3.text = "Sterminatore di Ufo!"
		lbl_a3.modulate = Color(0, 1, 0) # Verde
	else:
		# Mostriamo le kill attuali
		var kill_attuali = GameData.nemici_uccisi_mode_2
		lbl_a3.text = "Elimina 10 Ufo (" + str(kill_attuali) + "/10)"
		lbl_a3.modulate = Color(0.6, 0.6, 0.6) # Grigio

# --- TASTO INDIETRO ---
func _on_back_pressed() -> void:
	self.visible = false
	get_parent()._on_back_pressed()
