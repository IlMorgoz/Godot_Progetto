extends Node2D

@onready var turtle_spawner = $TurtleSpawner

func _ready() -> void:
	randomize()
	_spawn_player()

func _spawn_player() -> void:
	var player_scene = Global.get_selected_player_scene()
	if not player_scene:
		push_error("Global.selected_ship_scene is null!")
		return
	var player = player_scene.instantiate()
	player.name = "Player"
	player.position = get_viewport().get_visible_rect().size / 2
	add_child(player)
	
	# Aggiungi al gruppo "player" per i nemici
	if not player.is_in_group("player"):
		player.add_to_group("player")
