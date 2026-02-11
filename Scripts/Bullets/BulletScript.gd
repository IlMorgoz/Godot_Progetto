extends Area2D

var direction: Vector2
var speed: float      # Velocità in pixel/secondo
var damage: int       # Danno inflitto all'impatto

# Precarichiamo l'effetto esplosione per averlo pronto in memoria
var explosion_scene = preload("res://scenes/AnimationAddOn/Explosion.tscn")

# Definisce se il proiettile è "Amico" (True) o "Nemico" (False)
var is_it_player: bool = false 

func _ready() -> void:
	# Leggiamo il nome del file una volta sola.
	var bullet_name = scene_file_path.get_file().get_basename()
	
	# Configurazione parametri in base al nome del file.
	# set_parameters(velocità, danno)
	if bullet_name == "Ninja":
		set_parameters(550, 1)
		is_it_player = false # Nemico
		
	elif bullet_name == "Bullet_Purple_Devil":
		set_parameters(800, 3)
		is_it_player = false # Nemico
		
	elif bullet_name == "Bullet_Yellow_Ufo":
		set_parameters(700, 2)
		is_it_player = false # Nemico
		
	elif bullet_name == "Bullet_Yellow_Turtle":
		set_parameters(450, 4)
		is_it_player = false # Nemico
		
	elif bullet_name == "Bullet_Yellow_Flesh":
		set_parameters(900, 2)
		is_it_player = true  # Giocatore
		
	elif bullet_name == "Bullet_Yellow_StarChaser":
		set_parameters(900, 2)
		is_it_player = true  # Giocatore
		
	elif bullet_name == "Bullet_Yellow_Aqua":
		set_parameters(900, 2)
		is_it_player = true  # Giocatore
		
	# Orienta graficamente il proiettile verso la direzione di movimento
	rotation = direction.angle()

# Funzione set per assegnare i valori in modo pulito
func set_parameters(spd: int, dmg: int):
	speed = spd
	damage = dmg
	
func _physics_process(delta: float) -> void:
	# Movimento costante in linea retta
	global_position += direction * speed * delta

# Rimuove il proiettile se esce dallo schermo
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# --- LOGICA DI COLLISIONE ---
func _on_body_entered(body: Node2D) -> void:
	
	# CASO 1: Proiettile del GIOCATORE
	if is_it_player:
		# Deve colpire solo i NEMICI
		if body.is_in_group("enemies"):
			apply_damage_and_destroy(body)

	# CASO 2: Proiettile NEMICO
	else:
		# Deve colpire solo il PLAYER
		if body.is_in_group("player"):
			apply_damage_and_destroy(body)

func apply_damage_and_destroy(target):
	# 1. Applica danno (se l'oggetto ha la funzione take_damage)
	if target.has_method("take_damage"):
		target.take_damage(damage)
	
	# 2. Effetto visivo
	create_explosion()
	
	# 3. RIMOZIONE SICURA (SAFE REMOVAL)
	# Usiamo call_deferred("queue_free") invece di queue_free().
	# Questo dice a Godot di finire i calcoli fisici della collisione corrente
	# PRIMA di eliminare il proiettile, evitando crash e errori di memoria.
	call_deferred("queue_free")

# Gestione sicura dell'esplosione
func create_explosion():
	# Controllo di sicurezza: se il gioco sta chiudendo o cambiando scena, non fare nulla.
	if get_tree() == null:
		return

	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.emitting = true
	# Durata casuale per variare leggermente l'effetto visivo
	explosion.lifetime = randf_range(0.3, 0.7)
	
	# Aggiungiamo l'esplosione alla scena corrente in modo sicuro
	if get_tree().current_scene:
		get_tree().current_scene.call_deferred("add_child", explosion)
