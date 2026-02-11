extends Area2D

var direction: Vector2 = Vector2.RIGHT # Default a destra se non specificato
var speed: float = 0.0
var damage: int = 0
var target: Node2D = null
var is_homing_active: bool = false # Lo attiveremo dal Player
var turn_speed: float = 5.0 # Agilità della sterzata

# Precarichiamo l'effetto esplosione
var explosion_scene = preload("res://scenes/AnimationAddOn/Explosion.tscn")
var is_it_player: bool = false 

func _ready() -> void:
	# Orienta la grafica iniziale
	rotation = direction.angle()
	var bullet_name = scene_file_path.get_file().get_basename()
	
	if bullet_name == "Ninja":
		set_parameters(550, 1)
		is_it_player = false
		
	elif bullet_name == "Bullet_Purple_Devil":
		set_parameters(800, 3)
		is_it_player = false
		
	elif bullet_name == "Bullet_Yellow_Ufo":
		set_parameters(700, 2)
		is_it_player = false
		
	elif bullet_name == "Bullet_Yellow_Turtle":
		set_parameters(450, 4)
		is_it_player = false
		
	elif bullet_name == "Bullet_Green_Flesh":
		set_parameters(700, 1) # Velocità leggermente ridotta per dare tempo di curvare
		is_it_player = true
		
	elif bullet_name == "Bullet_Yellow_StarChaser":
		set_parameters(900, 2)
		is_it_player = true
		
	elif bullet_name == "Bullet_Yellow_Aqua":
		set_parameters(900, 2)
		is_it_player = true
	
	# Orienta graficamente il proiettile
	rotation = direction.angle()

func set_parameters(spd: int, dmg: int):
	speed = spd
	damage = dmg

func _physics_process(delta: float) -> void:
	if is_homing_active:
		if target == null or not is_instance_valid(target):
			target = find_nearest_enemy()
		if target != null:
			# Calcolo direzione
			var desired = (target.global_position - global_position).normalized()
			# Sterzata (più alto è turn_speed, più scatta verso il nemico)
			direction = direction.lerp(desired, turn_speed * delta).normalized()
	# Applica rotazione grafica
	rotation = direction.angle()
	# Applica movimento fisico
	global_position += direction * speed * delta	
# Cerca il nemico più vicino
func find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		# print("Nessun nemico trovato nel gruppo 'enemies'")
		return null
	var closest = null
	var min_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
	return closest
# --- Collisioni e Uscita Schermo ---
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
func _on_body_entered(body: Node2D) -> void:
	# Ignora il player se è un proiettile DEL player
	if is_it_player and body.is_in_group("player"):
		return  # ESCE dalla funzione senza esplodere
	# Il resto della logica...
	if is_it_player:
		if body.is_in_group("enemies"):
			apply_damage_and_destroy(body)
	else:
		if body.is_in_group("player"):
			apply_damage_and_destroy(body)
		
func apply_damage_and_destroy(hit_target):
	if hit_target.has_method("take_damage"):
		hit_target.take_damage(damage)
	
	create_explosion()
	call_deferred("queue_free")

func create_explosion():
	if get_tree() == null: return

	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.emitting = true
	explosion.lifetime = randf_range(0.3, 0.7)
	
	if get_tree().current_scene:
		get_tree().current_scene.call_deferred("add_child", explosion)
