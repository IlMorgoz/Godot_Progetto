extends Node2D
const ENEMY = preload("res://scenes/Spaceships/Enemies/Kamikaze.tscn")

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("spawn")
	anim.animation_finished.connect(_on_spawn_finished)

func _on_spawn_finished(anim_name: String):
	if anim_name == "spawn":
		var enemy = ENEMY.instantiate()
		enemy.position = global_position
		
		# Prendi il nodo Player dalla scena corrente
		var player_node = get_tree().get_current_scene().get_node("Player")
		
		# Assegna il riferimento al nemico
		enemy.player = player_node
		
		get_parent().add_child(enemy)
		queue_free()
