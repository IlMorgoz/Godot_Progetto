extends Node

# Segnale emesso quando le monete cambiano (per aggiornare la UI)
signal monete_aggiornate(nuovo_valore)

const SAVE_PATH = "user://game_data.save"
var selected_ship_scene: PackedScene = preload("res://scenes/Spaceships/Players/StarChaser_Player.tscn")

# --- DATI DI GIOCO ---

# 1. Valuta
var monete_stella: int = 0

# 2. Records
# mode_1: Tempo (int), mode_2: Ondata (int), mode_3: Tempo (float)
var records = {
	"mode_1": 0,
	"mode_2": 0,
	"mode_3": 0.0
}

# 3. Upgrades
var triple_shot_enabled := false
var speed_boost_enabled := false
var triple_shot_purchased := false
var speed_boost_purchased := false

func _ready():
	load_data()

# --- GESTIONE SALVATAGGIO / CARICAMENTO ---

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"monete_stella": monete_stella,
			"records": records,
			"upgrades": {
				"triple_shot_enabled": triple_shot_enabled,
				"speed_boost_enabled": speed_boost_enabled,
				"triple_shot_purchased": triple_shot_purchased,
				"speed_boost_purchased": speed_boost_purchased
			}
		}
		file.store_string(JSON.stringify(data))
		file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return # Usa i valori di default se non esiste salvataggio
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		
		if parse_result == OK:
			var data = json.get_data()
			
			# Carica Monete (con valore di default 5 se manca)
			monete_stella = data.get("monete_stella", 5)
			
			# Carica Records
			if data.has("records"):
				var loaded_records = data["records"]
				for key in records.keys():
					if loaded_records.has(key):
						records[key] = loaded_records[key]
			
			# Carica Upgrades
			if data.has("upgrades"):
				var u = data["upgrades"]
				triple_shot_enabled = u.get("triple_shot_enabled", false)
				speed_boost_enabled = u.get("speed_boost_enabled", false)
				triple_shot_purchased = u.get("triple_shot_purchased", false)
				speed_boost_purchased = u.get("speed_boost_purchased", false)
				
		file.close()

# --- LOGICA MONETE ---

func add_monete(amount: int) -> void:
	monete_stella += amount
	save_data() # Salviamo subito per sicurezza
	emit_signal("monete_aggiornate", monete_stella)

# Funzione per spendere soldi (ritorna true se l'acquisto va a buon fine)
func spend_monete(amount: int) -> bool:
	if monete_stella >= amount:
		monete_stella -= amount
		save_data()
		emit_signal("monete_aggiornate", monete_stella)
		return true
	else:
		print("Non hai abbastanza monete!")
		return false

# --- LOGICA RECORDS ---

func check_and_save_record(mode: String, value):
	if value > records.get(mode, 0):
		records[mode] = value
		save_data()
		print("Nuovo Record %s: %s" % [mode, str(value)])

func format_time(seconds) -> String:
	var m = int(seconds) / 60
	var s = int(seconds) % 60
	return "%02d:%02d" % [m, s]

# --- HELPERS ---

func get_selected_player_scene() -> PackedScene:
	return selected_ship_scene
