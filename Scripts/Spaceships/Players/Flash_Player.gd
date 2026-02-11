extends CharacterBody2D

const SPEED = 500
var bullet_scene = preload("res://scenes/Bullets/Player/Bullet_Green_Flesh.tscn")
@onready var Shooty_part = $ShootyPart

var counter = 0

func _ready():
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	var input_vector = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

	velocity = lerp(get_real_velocity(), input_vector * SPEED, 0.1)
	
	if Input.is_action_just_pressed("shoot"):
		shoot() # Ho spostato la logica in una funzione dedicata per pulizia

	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = Shooty_part.global_position
	bullet.direction = transform.x.normalized()
	
	counter += 1
	
	# --- PRIMA DECIDIAMO IL TIPO DI COLPO ---
	if counter >= 5:
		bullet.is_homing_active = true

		
		# --- MODIFICA QUESTI VALORI PER VEDERE LA CURVA ---
		bullet.turn_speed = 10.0  # Aumenta sterzata (era 4.0?)
		bullet.speed = 400        # Riduci velocità (era 600/900?)
		
		print("--- SPARO HOMING (Setup completato) ---")
		counter = 0
	else:
		bullet.is_homing_active = false
		bullet.speed = 600        # I colpi normali possono essere veloci
	
	# --- POI AGGIUNGIAMO ALLA SCENA ---
	# Ora quando _ready() parte, le variabili sono già giuste!
	get_tree().get_current_scene().add_child(bullet)
