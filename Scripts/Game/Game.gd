extends Node2D

const GAME_DURATION := 180
const REWARD_TIMINGS := {
	60: 5,
	120: 15,
	180: 30
}

var current_time := 0
var rewarded_minutes := []

@onready var game_timer: Timer = $GameTimer
@onready var time_label: Label = $GameTimer/TimeLabel
@onready var monete_label: Label = $MoneteLabel
@onready var spawner: Node = $EnemySpawner

func _ready():
	# Setup iniziale
	_update_monete_label()
	if time_label:
		time_label.text = "Tempo: 03:00"

	# Collega il timeout del timer
	game_timer.timeout.connect(_on_timer_tick)

	# Ferma lo spawner inizialmente
	spawner.set_process(false)

	# ✅ Spawna la navicella selezionata
	await get_tree().process_frame  # Aspetta 1 frame per sicurezza
	_spawn_selected_player()

	# Avvia gioco
	game_timer.start()
	spawner.set_process(true)


func _spawn_selected_player():
	var player_scene = Global.get_selected_player_scene()
	if not player_scene:
		push_error("Global.selected_ship_scene is null!")
		return

	var player = player_scene.instantiate()
	player.position = get_viewport().get_visible_rect().size / 2
	add_child(player)

func _on_timer_tick():
	current_time += 1
	_update_timer_label()

	# Velocità spawn progressiva
	if spawner.has_method("update_spawn_speed"):
		spawner.update_spawn_speed(current_time)

	# Ricompense a fine minuto
	for time_check in REWARD_TIMINGS:
		if current_time == time_check and time_check not in rewarded_minutes:
			var reward = REWARD_TIMINGS[time_check]
			MoneteManager.add_monete(reward)
			_update_monete_label()
			print("Hai ricevuto %d monete!" % reward)
			rewarded_minutes.append(time_check)

	if current_time >= GAME_DURATION:
		game_timer.stop()
		spawner.set_process(false)
		_game_over()

func _update_timer_label():
	var remaining := GAME_DURATION - current_time
	var minutes := remaining / 60
	var seconds := remaining % 60
	if time_label:
		time_label.text = "Tempo: %02d:%02d" % [minutes, seconds]

func _update_monete_label():
	if monete_label:
		monete_label.text = ": %d" % MoneteManager.monete_stella

func _game_over():
	print("Gioco terminato! Monete: %d" % MoneteManager.monete_stella)
	get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
