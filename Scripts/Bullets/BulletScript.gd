extends Area2D

var direction: Vector2
var speed 
var damage: int    
var explosion_scene = preload("res://scenes/AnimationAddOn/Explosion.tscn")

# Nuova variabile per capire di chi è il proiettile
var is_it_player: bool = false 

func _ready() -> void:
	var bullet_name = scene_file_path.get_file().get_basename()
	
	if (bullet_name == "Ninja"):
		set_parameters(550, 1)
		is_it_player = false # È un proiettile del giocatore!
	elif (bullet_name == "Bullet_Purple_Devil"):
		set_parameters(800, 3)
		is_it_player = false # È un proiettile nemico
	elif (bullet_name == "Bullet_Yellow_Ufo"):
		set_parameters(700, 2)
		is_it_player = false
	elif (bullet_name == "Bullet_Yellow_Turtle"):
		set_parameters(450, 4)
		is_it_player = false
	elif (bullet_name == "Bullet_Yellow_Flesh"):
		set_parameters(750, 2)
		is_it_player = true
	elif (bullet_name == "Bullet_Yellow_StarChaser"):
		set_parameters(750, 2)
		is_it_player = true
	elif (bullet_name == "Bullet_Yellow_Aqua"):
		set_parameters(750, 2)
		is_it_player = true
		
	rotation = direction.angle()

func set_parameters(spd: int, dmg: int):
	speed = spd
	damage = dmg
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# CASO 1: Il proiettile è del GIOCATORE
	if is_it_player:
		# Se colpisce un NEMICO
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
			create_explosion()
			queue_free()
		# Se colpisce il PLAYER -> Non fare nulla (ignora)
		# Se colpisce altro -> Non fare nulla

	# CASO 2: Il proiettile è di un NEMICO
	else:
		# Se colpisce il PLAYER
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
			create_explosion()
			queue_free()
		# Se colpisce un NEMICO -> Non fare nulla (ignora)

# Ho separato l'esplosione per rendere il codice più pulito
func create_explosion():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.emitting = true
	explosion.lifetime = randf_range(0.3, 0.7)
	get_tree().current_scene.add_child(explosion)
