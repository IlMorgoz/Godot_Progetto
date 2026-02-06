extends Node2D

@onready var wave_label: Label = get_node_or_null("CanvasLayer/WaveLabel")
@onready var monete_label: Label = get_node_or_null("MoneteLabel")

const SPAWN_WIDTH := 1152
const SPAWN_HEIGHT := 648
const ENEMY_SCENE := preload("res://scenes/Spaceships/Enemies/Ufo.tscn")

var current_wave: int = 0
var enemies_alive: int = 0
var enemies_to_spawn: int = 0
var is_spawning: bool = false
var rewarded_waves: Array = []
var max_waves: int = 3

var waves_data = [
	{"enemies": 3, "spawn_interval": 2.0},
	{"enemies": 6, "spawn_interval": 1.8},
	{"enemies": 10, "spawn_interval": 1.0},
]

var DEBUG := true

func _ready() -> void:
	randomize()
	_update_monete_label()
	_spawn_player()
	await start_next_wave()

func _spawn_player() -> void:
	var player_scene = Global.get_selected_player_scene()
	if not player_scene: return
	var player = player_scene.instantiate()
	player.position = get_viewport().get_visible_rect().size / 2
	add_child(player)
	
	# Assumiamo che il player abbia un segnale "died" o "tree_exited"
	if player.has_signal("died"):
		player.died.connect(_on_player_died)
	else:
		# Fallback se non hai un segnale custom: controlliamo quando esce dall'albero
		player.tree_exited.connect(_on_player_died)

func start_next_wave():
	if current_wave >= max_waves:
		if wave_label:
			wave_label.text = "Tutte le ondate completate!"
			wave_label.visible = true
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
		return

	current_wave += 1
	var wave_data = waves_data[current_wave - 1]
	enemies_to_spawn = wave_data["enemies"]
	var spawn_interval = wave_data["spawn_interval"]

	if wave_label:
		wave_label.text = "Ondata %d" % current_wave
		wave_label.visible = true
	await get_tree().create_timer(2.0).timeout
	if wave_label:
		wave_label.visible = false

	if DEBUG:
		print("--- START ONDATA %d — spawn: %d  interval: %s" % [current_wave, enemies_to_spawn, str(spawn_interval)])

	await spawn_wave(enemies_to_spawn, spawn_interval)

	while is_spawning or get_tree().get_nodes_in_group("enemies").size() > 0:
		if DEBUG:
			var group_count := get_tree().get_nodes_in_group("enemies").size()
			print("Attendo fine ondata %d — is_spawning: %s  group_enemies: %d  enemies_alive: %d  to_spawn: %d"
				% [current_wave, str(is_spawning), group_count, enemies_alive, enemies_to_spawn])
		await get_tree().process_frame

	await get_tree().create_timer(0.08).timeout

	_on_wave_finished()
	return

func spawn_wave(count: int, interval: float):
	is_spawning = true
	for i in range(count):
		spawn_enemy()
		enemies_to_spawn = max(0, enemies_to_spawn - 1)
		if DEBUG:
			print("Spawned enemy #%d for wave %d — remaining_to_spawn: %d" % [i+1, current_wave, enemies_to_spawn])
		await get_tree().create_timer(interval).timeout
	is_spawning = false

func spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = Vector2(randi() % SPAWN_WIDTH, randi() % SPAWN_HEIGHT)
	add_child(enemy)

	if not enemy.is_in_group("enemies"):
		enemy.add_to_group("enemies")

	enemies_alive += 1

	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died)
	else:
		push_warning("Enemy spawnato senza segnale 'died' — assicurati che lo script del nemico emetta died")

	if DEBUG:
		print("enemies_alive++ -> %d    group_count: %d" % [enemies_alive, get_tree().get_nodes_in_group("enemies").size()])

func _on_enemy_died() -> void:
	enemies_alive = max(0, enemies_alive - 1)
	if DEBUG:
		print("on_enemy_died -> enemies_alive: %d  group_count: %d  enemies_to_spawn: %d"
			% [enemies_alive, get_tree().get_nodes_in_group("enemies").size(), enemies_to_spawn])

func _on_wave_finished() -> void:
	if DEBUG:
		print(">>> ONDATA %d FINITA <<<" % current_wave)

	_give_wave_reward(current_wave)

	if current_wave >= max_waves:
		if wave_label:
			wave_label.text = "Gioco completato!"
			wave_label.visible = true
			
		# --- SALVATAGGIO VITTORIA ---
		ScoreManager.check_and_save_record("mode_2", current_wave)
		# ----------------------------
		
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
	else:
		if wave_label:
			wave_label.text = "Ondata %d completata!" % current_wave
			wave_label.visible = true
		var t2 = get_tree().create_timer(2.0)
		t2.timeout.connect(func():
			if wave_label:
				wave_label.visible = false
			start_next_wave()
		)

func _on_player_died():
	print("Player morto all'ondata: ", current_wave)
	# Salviamo l'ondata corrente (o current_wave - 1 se vuoi contare solo le completate)
	ScoreManager.check_and_save_record("mode_2", current_wave)
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")

func _give_wave_reward(wave: int) -> void:
	if wave in rewarded_waves:
		return
	match wave:
		1: MoneteManager.add_monete(5)
		2: MoneteManager.add_monete(10)
		3: MoneteManager.add_monete(15)
	_update_monete_label()
	rewarded_waves.append(wave)

func _update_monete_label() -> void:
	if monete_label:
		monete_label.text = ": %d" % MoneteManager.monete_stella
