extends Node
#C:\Users\masel\AppData\Roaming\Godot\app_userdata\Shooter
const SAVE_PATH = "user://records.save"

# Struttura: 
# mode_1: Tempo sopravvissuto (int)
# mode_2: Numero ondata (int)
# mode_3: Tempo sopravvissuto (float)
var records = {
	"mode_1": 0,
	"mode_2": 0,
	"mode_3": 0.0
}

func _ready():
	load_records()

# Chiama questa funzione alla fine di ogni partita
func check_and_save_record(mode: String, value):
	# Se il nuovo valore è maggiore del vecchio, salviamo
	if value > records.get(mode, 0):
		records[mode] = value
		save_to_disk()
		print("Nuovo Record per %s: %s" % [mode, str(value)])

func save_to_disk():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(records))
		file.close()

func load_records():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json = JSON.new()
			var result = json.parse(file.get_as_text())
			if result == OK:
				var data = json.get_data()
				# Aggiorna solo le chiavi esistenti per sicurezza
				for key in records.keys():
					if data.has(key):
						records[key] = data[key]
			file.close()

# Utility per formattare il tempo (da usare nella UI)
func format_time(seconds) -> String:
	var m = int(seconds) / 60
	var s = int(seconds) % 60
	return "%02d:%02d" % [m, s]
