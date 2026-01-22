extends Node2D

const WIDTH = 1152
const HEIGHT = 648
const SPAWNING_ENEMY = preload("res://scenes/Game/spawning_enemy.tscn")

var spawnArea = Rect2()
var delta := 2.0
var offset := 0.5
var current_game_time := 0

func _ready():
	randomize()
	spawnArea = Rect2(0, 0, WIDTH, HEIGHT)
	set_next_spawn()

func spawn_enemy():
	var spawn_pos = Vector2(randi() % WIDTH, randi() % HEIGHT)
	var spawn_anim = SPAWNING_ENEMY.instantiate()
	spawn_anim.position = spawn_pos
	get_parent().add_child(spawn_anim)

func set_next_spawn():
	var nextTime = delta + (randf() - 0.5) * 2 * offset
	nextTime = clamp(nextTime, 0.1, 5.0)  # per sicurezza
	$Timer.wait_time = nextTime
	$Timer.start()
	
func _on_timer_timeout():
	spawn_enemy()
	set_next_spawn()

# Aggiorna velocità di spawn in base al tempo di gioco
func update_spawn_speed(current_time: int) -> void:
	current_game_time = current_time

	# Calcola velocità tra 2s (inizio) e 0.33s (ultimi 10 secondi)
	var progress: float = clamp(current_time / 170.0, 0.0, 1.0)
	delta = lerp(2.0, 0.33, progress)
