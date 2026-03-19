extends Node

signal monete_aggiornate(nuovo_valore)
signal profile_icon_changed
signal achievement_sbloccato(nome_achievement) # Segnale per gli achievements

const SAVE_PATH = "user://game_data.save"

var ship_scenes: Array[PackedScene] = [
	preload("res://scenes/Spaceships/Players/StarChaser_Player.tscn"), # Index 0
	preload("res://scenes/Spaceships/Players/Flash_Player.tscn"),      # Index 1
	preload("res://scenes/Spaceships/Players/Aqua.tscn")               # Index 2
]

var selected_ship_scene: PackedScene = ship_scenes[0]
var selected_ship_index: int = 0

# --- GESTIONE SKIN E NAVI ---
var current_icon_index: int = 0
var unlocked_icons: Array = [true, false, false, false, false] 

var unlocked_ships: Array = [true, false, false] 

# --- DATI DI GIOCO ---
var monete_stella: int = 0
var records = { "mode_1": 0, "mode_2": 0, "mode_3": 0.0 }

# --- SISTEMA UPGRADES ---
var upgrades = {
	"triple_shot": {"purchased": false, "enabled": false},
	"speed_boost": {"purchased": false, "enabled": false},
	"homing":      {"purchased": false, "enabled": false},
	"big_bullet":  {"purchased": false, "enabled": false},
	"shield":      {"purchased": false, "enabled": false},
	"super_shield":{"purchased": false, "enabled": false}
}

# ACHIEVEMENTS E STATISTICHE
var nemici_uccisi_mode_1: int = 0 # Conta le kill nella modalità kamikaze
var nemici_uccisi_mode_2: int = 0 # Conta le kill nella modalità ufo

var achievements = {
	"primo_sparo": false,
	"killer_kamikaze": false, # 10 nemici uccisi
	"killer_ufo": false # 10 nemici uccisi
}

func _ready():
	load_data()

# SALVATAGGIO
func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"monete_stella": monete_stella,
			"records": records,
			"current_icon_index": current_icon_index,
			"unlocked_icons": unlocked_icons,
			"selected_ship_index": selected_ship_index,
			"unlocked_ships": unlocked_ships,
			"upgrades": upgrades,
			
			# Salviamo le statistiche e gli achievements
			"nemici_uccisi_mode_1": nemici_uccisi_mode_1,
			"nemici_uccisi_mode_2": nemici_uccisi_mode_2,
			"achievements": achievements,
		}
		file.store_string(JSON.stringify(data))
		file.close()

# CARICAMENTO
func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		save_data()
		return 
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		
		if parse_result == OK:
			var data = json.get_data()
			
			monete_stella = data.get("monete_stella", 5)
			
			current_icon_index = data.get("current_icon_index", 0)
			var loaded_icons = data.get("unlocked_icons", [])
			if loaded_icons.size() > 0: unlocked_icons = loaded_icons
			
			selected_ship_index = data.get("selected_ship_index", 0)
			if selected_ship_index < ship_scenes.size():
				selected_ship_scene = ship_scenes[selected_ship_index]
			
			var loaded_ships = data.get("unlocked_ships", [])
			if loaded_ships.size() > 0: unlocked_ships = loaded_ships
			
			if data.has("records"):
				var loaded_records = data["records"]
				for key in records.keys():
					if loaded_records.has(key): records[key] = loaded_records[key]
			
			if data.has("upgrades"):
				var loaded_upgrades = data["upgrades"]
				for key in upgrades.keys():
					if loaded_upgrades.has(key):
						upgrades[key]["purchased"] = loaded_upgrades[key].get("purchased", false)
						upgrades[key]["enabled"] = loaded_upgrades[key].get("enabled", false)
						
			# --- Caricamento Statistiche e Achievements ---
			nemici_uccisi_mode_1 = data.get("nemici_uccisi_mode_1", 0)
			if data.has("achievements"):
				var loaded_achievements = data["achievements"]
				for key in achievements.keys():
					if loaded_achievements.has(key): 
						achievements[key] = loaded_achievements[key]

			nemici_uccisi_mode_2 = data.get("nemici_uccisi_mode_2", 0)
			if data.has("achievements"):
				var loaded_achievements = data["achievements"]
				for key in achievements.keys():
					if loaded_achievements.has(key): 
						achievements[key] = loaded_achievements[key]
				
		file.close()

# ACHIEVEMENTS
func sblocca_achievement(id_achievement: String):
	if achievements.has(id_achievement) and achievements[id_achievement] == false:
		achievements[id_achievement] = true
		save_data() 
		emit_signal("achievement_sbloccato", id_achievement)
		print("🏆 ACHIEVEMENT SBLOCCATO: ", id_achievement, "!")

# Usa questa funzione quando uccidi un nemico nella Modalità 1
func aggiungi_kill_kamikaze():
	nemici_uccisi_mode_1 += 1
	save_data() 
	
	if nemici_uccisi_mode_1 >= 10:
		sblocca_achievement("killer_kamikaze")

func aggiungi_kill_ufo():
	nemici_uccisi_mode_2 += 1
	save_data() 
	
	if nemici_uccisi_mode_2 >= 10:
		sblocca_achievement("killer_ufo")


# MONETE
func add_monete(amount: int) -> void:
	monete_stella += amount
	save_data()
	emit_signal("monete_aggiornate", monete_stella)

func spend_monete(amount: int) -> bool:
	if monete_stella >= amount:
		monete_stella -= amount
		save_data()
		emit_signal("monete_aggiornate", monete_stella)
		return true
	else:
		print("Non hai abbastanza monete!")
		return false

# RECORDS
func check_and_save_record(mode: String, value):
	if value > records.get(mode, 0):
		records[mode] = value
		save_data()

func format_time(seconds) -> String:
	var m = int(seconds) / 60
	var s = int(seconds) % 60
	return "%02d:%02d" % [m, s]

func get_selected_player_scene() -> PackedScene:
	return selected_ship_scene

func set_player_ship(index: int):
	if index < ship_scenes.size():
		selected_ship_index = index
		selected_ship_scene = ship_scenes[index]
		save_data()
