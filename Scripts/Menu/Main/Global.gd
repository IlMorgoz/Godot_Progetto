extends Node

var selected_ship_scene: PackedScene = preload("res://scenes/Spaceships/Players/StarChaser_Player.tscn")
var triple_shot_enabled := false
var speed_boost_enabled := false
# Variabili per tracciare lo stato di acquisto
var triple_shot_purchased := false
var speed_boost_purchased := false

const SAVE_PATH := "user://upgrade_settings.save"

func _ready():
	load_upgrades()

func save_upgrades():
	var data = {
		"triple_shot_enabled": triple_shot_enabled,
		"speed_boost_enabled": speed_boost_enabled,
		# Salva anche lo stato di acquisto
		"triple_shot_purchased": triple_shot_purchased,
		"speed_boost_purchased": speed_boost_purchased
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()

func load_upgrades():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			file.close()

			triple_shot_enabled = data.get("triple_shot_enabled", false)
			speed_boost_enabled = data.get("speed_boost_enabled", false)
			# Carica lo stato di acquisto, con un valore predefinito
			triple_shot_purchased = data.get("triple_shot_purchased", false)
			speed_boost_purchased = data.get("speed_boost_purchased", false)

func get_selected_player_scene() -> PackedScene:
	return selected_ship_scene
