extends Node2D

const ENEMY = preload("res://scenes/Spaceships/Enemies/Kamikaze.tscn")

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("spawn")
	# Non serve connettere il segnale, ci pensa l'AnimationPlayer a chiamare le funzioni

# Questa funzione viene chiamata dall'AnimationPlayer al momento giusto
func spawn_enemy():
	var enemy = ENEMY.instantiate()
	enemy.global_position = global_position
	
	# Nota: Non serve assegnare 'enemy.player' qui manualmente, 
	# perché lo script del Kamikaze lo cerca da solo nel suo _ready usando i gruppi.
	
	get_parent().add_child(enemy)

# Questa funzione viene chiamata dall'AnimationPlayer alla fine per pulire
func kill():
	queue_free()
