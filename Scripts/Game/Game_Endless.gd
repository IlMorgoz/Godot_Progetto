extends Node2D

@onready var turtle_spawner = $TurtleSpawner

var time_survived: float = 0.0
var is_game_active: bool = true

func _ready() -> void:
	randomize()
	_spawn_player()

func _process(delta: float) -> void:
	if is_game_active:
		time_survived += delta

func _spawn_player() -> void:
	var player_scene = Global.get_selected_player_scene()
	if not player_scene: return
	var player = player_scene.instantiate()
	player.position = get_viewport().get_visible_rect().size / 2
	add_child(player)
	player.add_to_group("player")
	
	# IMPORTANTE: Collega la morte
	if player.has_signal("died"):
		player.died.connect(_on_player_died)
	else:
		player.tree_exited.connect(_on_player_died)

func _on_player_died():
	# 1. Evita doppi richiami
	if not is_game_active: 
		return
	is_game_active = false
	
	print("Game Over Endless! Tempo: %.2f" % time_survived)
	
	# 2. Salva il punteggio PRIMA di tutto
	ScoreManager.check_and_save_record("mode_3", time_survived)
	
	# 3. Controllo se siamo ancora nell'albero della scena
	if not is_inside_tree() or get_tree() == null:
		return

	# Ora è sicuro creare il timer
	await get_tree().create_timer(2.0).timeout
	
	# 4. Ricontrolliamo prima di cambiare scena (potrebbe essere passato altro tempo)
	if get_tree():
		if has_node("/root/FadeTransition"):
			FadeTransition.change_scene("res://scenes/Menu/Main_Menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
