extends Panel

# Riferimenti ai Nodi
@onready var btn1 = $HBoxContainer/Btn1
@onready var btn2 = $HBoxContainer/Btn2
@onready var btn3 = $HBoxContainer/Btn3
@onready var nodo_padre = get_parent()

# Riferimenti grafici (Lucchetti e Prezzi)
# Assicurati che questi percorsi siano corretti nella tua scena
@onready var lock1 = $Sprite2D2
@onready var price1 = $MoneteLabel3
@onready var lock2 = $Sprite2D3
@onready var price2 = $MoneteLabel
@onready var lock3 = $Sprite2D4
@onready var price3 = $MoneteLabel2

# Costi
var costo_skin_1 = 5
var costo_skin_2 = 20
var costo_skin_3 = 100

func _ready():
	# Aggiorna la grafica appena apri il menu
	update_ui_state()

func update_ui_state():
	# --- SKIN 1 ---
	if GameData.unlocked_icons[1] == true:
		# Se POSSIEDO la skin: Togli lucchetto, abilita tasto
		lock1.visible = false
		price1.visible = false
		btn1.disabled = false
	else:
		# Se NON la possiedo: Mostra lucchetto, abilita solo se ho i soldi
		lock1.visible = true
		price1.visible = true
		btn1.disabled = (GameData.monete_stella < costo_skin_1)

	# --- SKIN 2 ---
	if GameData.unlocked_icons[2] == true:
		lock2.visible = false
		price2.visible = false
		btn2.disabled = false
	else:
		lock2.visible = true
		price2.visible = true
		btn2.disabled = (GameData.monete_stella < costo_skin_2)

	# --- SKIN 3 ---
	if GameData.unlocked_icons[3] == true:
		lock3.visible = false
		price3.visible = false
		btn3.disabled = false
	else:
		lock3.visible = true
		price3.visible = true
		btn3.disabled = (GameData.monete_stella < costo_skin_3)

# --- FUNZIONE GENERICA PER EQUIPAGGIARE ---
func equip_skin(index: int):
	GameData.current_icon_index = index
	GameData.save_data() # Salviamo la scelta
	GameData.profile_icon_changed.emit()
	print("Skin ", index, " equipaggiata!")

# --- BOTTONE 1 ---
func _on_btn_1_pressed() -> void:
	if GameData.unlocked_icons[1] == true:
		# CASO A: Già comprata -> Equipaggia e basta
		equip_skin(1)
	else:
		# CASO B: Da comprare -> Paga -> Sblocca -> Equipaggia
		if GameData.spend_monete(costo_skin_1):
			GameData.unlocked_icons[1] = true
			GameData.save_data()
			update_ui_state() # Aggiorna la grafica (toglie lucchetto)
			equip_skin(1)

# --- BOTTONE 2 ---
func _on_btn_2_pressed() -> void:
	if GameData.unlocked_icons[2] == true:
		equip_skin(2)
	else:
		if GameData.spend_monete(costo_skin_2):
			GameData.unlocked_icons[2] = true
			GameData.save_data()
			update_ui_state()
			equip_skin(2)

# --- BOTTONE 3 ---
func _on_btn_3_pressed() -> void:
	if GameData.unlocked_icons[3] == true:
		equip_skin(3)
	else:
		if GameData.spend_monete(costo_skin_3):
			GameData.unlocked_icons[3] = true
			GameData.save_data()
			update_ui_state()
			equip_skin(3)

# Tasto Indietro
func _on_back_pressed() -> void:
	if nodo_padre.has_method("turn_on"):
		nodo_padre.turn_on(self)
	else:
		self.visible = false
