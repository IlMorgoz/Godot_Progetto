extends Node2D

const SHIP_SCENES = [
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/StarChaser_DecorativeShip.tscn"),
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/Flash_DecorativeShip.tscn"),
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/Turtle_DecorativeShip.tscn"),
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/PurpleDevil_DecorativeShip.tscn"),
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/Ninja_DecorativeShip.tscn"),
	preload("res://scenes/AnimationAddOn/MainMenuAnimations/Aqua_DecorativeShip.tscn")
]

const SCREEN_WIDTH = 1152
const SCREEN_HEIGHT = 648

func _ready() -> void:
	randomize()
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout():
	# Scegli una scena a caso dall'array
	var chosen_scene = SHIP_SCENES[randi() % SHIP_SCENES.size()]
	var ship = chosen_scene.instantiate()
	
	# Posiziona fuori dallo schermo
	ship.global_position = spawn_outside_screen()
	add_child(ship)

func spawn_outside_screen() -> Vector2:
	var pos = Vector2()
	var side = randi() % 4

	match side:
		0:
			# Sinistra
			pos.x = -50
			pos.y = randf() * SCREEN_HEIGHT
		1:
			# Destra
			pos.x = SCREEN_WIDTH + 50
			pos.y = randf() * SCREEN_HEIGHT
		2:
			# Sopra
			pos.x = randf() * SCREEN_WIDTH
			pos.y = -50
		3:
			# Sotto
			pos.x = randf() * SCREEN_WIDTH
			pos.y = SCREEN_HEIGHT + 50

	return pos
