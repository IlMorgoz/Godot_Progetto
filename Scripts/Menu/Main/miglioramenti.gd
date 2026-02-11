extends Panel

@onready var upgrade1 = $Upgrade1 # CheckBox per attivare Triple Shot
@onready var upgrade2 = $Upgrade2 # CheckBox per attivare Speed Boost
@onready var nodo = get_parent()

func _ready():
	# 2. Gestione stato attivazione (CheckBox)
	# Impostiamo la spunta se l'upgrade è attivo
	upgrade1.button_pressed = GameData.triple_shot_enabled
	upgrade2.button_pressed = GameData.speed_boost_enabled
	
	# (Opzionale) Disabilitiamo la possibilità di cliccare la spunta se non è comprato
	upgrade1.disabled = not GameData.triple_shot_purchased
	upgrade2.disabled = not GameData.speed_boost_purchased

func _on_button_pressed() -> void:
	# Acquisto Triple Shot (Costo 500)
	if GameData.spend_monete(500):
		print("Acquisto Triple Shot Riuscito")
		
		# Aggiorna dati
		GameData.triple_shot_purchased = true
		GameData.triple_shot_enabled = true # Lo attiviamo subito per comodità
		GameData.save_data()
		
		# Aggiorna UI
		upgrade1.disabled = false
		upgrade1.button_pressed = true
	else:
		print("Monete Insufficienti (Serve 500)")

func _on_button_2_pressed() -> void:
	# Acquisto Speed Boost (Costo 750)
	if GameData.spend_monete(750):
		print("Acquisto Speed Boost Riuscito")
		
		# Aggiorna dati
		GameData.speed_boost_purchased = true
		GameData.speed_boost_enabled = true
		GameData.save_data()
		
		# Aggiorna UI
		upgrade2.disabled = false
		upgrade2.button_pressed = true
	else:
		print("Monete Insufficienti (Serve 750)")

func _on_upgrade_1_toggled(toggled_on: bool) -> void:
	# Questa funzione scatta quando clicchi la checkbox (dopo averla comprata)
	GameData.triple_shot_enabled = toggled_on
	GameData.save_data()

func _on_upgrade_2_toggled(toggled_on: bool) -> void:
	GameData.speed_boost_enabled = toggled_on
	GameData.save_data()
	print("NUOVO STATO VELOCITÀ BOOST:", toggled_on)
	
func _on_ritorno_pressed() -> void:
	# Chiama la funzione del genitore per chiudere il pannello
	if nodo.has_method("turn_on"):
		nodo.turn_on(self)
	else:
		self.visible = false # Fallback se il metodo non esiste
