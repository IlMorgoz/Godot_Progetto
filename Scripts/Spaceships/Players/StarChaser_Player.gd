extends CharacterBody2D

const BASE_SPEED = 100
const EXTRA_SPEED = 100
const FIRE_RATE = 0.3 # secondi
var bullet_scene = preload("res://scenes/Bullets/Player/Bullet_Yellow_StarChaser.tscn")

@onready var Shooty_part = $ShootyPart
@onready var Shooty_part2 = $ShootyPart2
@onready var Shooty_part3 = $ShootyPart3
@onready var healthbar = $HealtBar

var time_since_last_shot := 0.0
var health: int = 6

func _ready():
	add_to_group("player")
	
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	var input_vector = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

	var speed = BASE_SPEED
	if Global.speed_boost_enabled:
		speed += EXTRA_SPEED

	velocity = lerp(get_real_velocity(), input_vector * speed, 0.1)

	time_since_last_shot += delta

	if Input.is_action_just_pressed("shoot") and time_since_last_shot >= FIRE_RATE:
		fire()
		time_since_last_shot = 0.0

	move_and_slide()

func fire():
	# Sempre spara dal primo
	spawn_bullet(Shooty_part)

	if Global.triple_shot_enabled:
		spawn_bullet(Shooty_part2)
		spawn_bullet(Shooty_part3)

func spawn_bullet(part: Node2D):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = part.global_position
	bullet.direction = transform.x.normalized()
	get_tree().get_current_scene().add_child(bullet)

# Funzione per gestire il danno
func take_damage(amount: int) -> void:
	health -= amount
	healthbar.health = health
	if health <= 0:
		die()

# Quando la vita finisce
func die() -> void:
	# ERRORE PRECEDENTE:
	# get_tree().change_scene_to_file(...) -> Questo distruggeva la fisica istantaneamente!
	
	# SOLUZIONE:
	# Diciamo a Godot: "Appena hai finito di calcolare tutto questo frame, cambia scena".
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Menu/Main_Menu.tscn")
