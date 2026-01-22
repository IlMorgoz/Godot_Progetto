extends CharacterBody2D

const SPEED = 500
var bullet_scene = preload("res://scenes/Bullets/Bullet_Yellow_Flesh.tscn")

@onready var Shooty_part = $ShootyPart

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
		var bullet = bullet_scene.instantiate()
		bullet.global_position = Shooty_part.global_position
		bullet.direction = transform.x.normalized()
		get_tree().get_current_scene().add_child(bullet)

	move_and_slide()
