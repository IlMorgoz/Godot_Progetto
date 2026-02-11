extends Panel

@onready var nodo = get_parent()

# Pulsanti di selezione
@onready var btn1 = $HBoxContainer/Seleziona
@onready var btn2 = $HBoxContainer/Seleziona2
@onready var btn3 = $HBoxContainer/Seleziona3

# Nave 2 (Flash)
@onready var lock2 = $Sprite2D3       
@onready var price2 = $MoneteLabel

# Nave 3 (Aqua)
@onready var lock3 = $Sprite2D4
@onready var price3 = $MoneteLabel2

# Costi
var costo_ship_2 = 80
var costo_ship_3 = 140

func _ready():
	# Aggiorna la grafica appena apri il menu
	update_ui_state()

# Funzione centrale che decide cosa mostrare (Lucchetti o Tasto Equipaggia)
func update_ui_state():
	
	# --- NAVE 2 (Flash) ---
	if GameData.unlocked_ships[1] == true:
		# POSSEDUTA: Nascondi lucchetto, mostra tasto equipaggia
		lock2.visible = false
		price2.visible = false
		btn2.disabled = false
	else:
		# NON POSSEDUTA: Mostra lucchetto
		lock2.visible = true
		price2.visible = true
		# Il tasto è attivo solo se hai abbastanza soldi
		btn2.disabled = (GameData.monete_stella < costo_ship_2)

	# --- NAVE 3 (Aqua) ---
	if GameData.unlocked_ships[2] == true:
		lock3.visible = false
		price3.visible = false
		btn3.disabled = false
	else:
		lock3.visible = true
		price3.visible = true
		btn3.disabled = (GameData.monete_stella < costo_ship_3)

# --- TASTO 1 (StarChaser - Default) ---
func _on_seleziona_pressed() -> void:
	# La prima è sempre gratis
	GameData.set_player_ship(0)
	print("Nave selezionata: StarChaser")

# --- TASTO 2 (Flash - Costo 80) ---
func _on_seleziona_2_pressed() -> void:
	if GameData.unlocked_ships[1] == true:
		# CASO A: Già comprata -> Equipaggia
		GameData.set_player_ship(1)
		print("Nave selezionata: Flash")
	else:
		# CASO B: Da comprare -> Paga -> Sblocca -> Equipaggia
		if GameData.spend_monete(costo_ship_2):
			GameData.unlocked_ships[1] = true
			update_ui_state() # Aggiorna la UI (toglie lucchetto)
			GameData.set_player_ship(1)
			print("Nave acquistata e selezionata: Flash")

# --- TASTO 3 (Aqua - Costo 140) ---
func _on_seleziona_3_pressed() -> void:
	if GameData.unlocked_ships[2] == true:
		GameData.set_player_ship(2)
		print("Nave selezionata: Aqua")
	else:
		if GameData.spend_monete(costo_ship_3):
			GameData.unlocked_ships[2] = true
			update_ui_state()
			GameData.set_player_ship(2)
			print("Nave acquistata e selezionata: Aqua")

# --- TASTO INDIETRO ---
func _on_back_pressed() -> void:
	if nodo.has_method("turn_on"):
		nodo.turn_on(self)
	else:
		self.visible = false
