extends Area2D

var direction: Vector2
const SPEED = 500
var damage: int = 3   # ogni proiettile infligge 1 danno
var explosion_scene = preload("res://scenes/AnimationAddOn/Explosion.tscn")

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		# Applica danno al nemico (usa la funzione take_damage in enemy.gd)
		if body.has_method("take_damage"):
			body.take_damage(damage)

		# Distruggi il proiettile
		queue_free()

		# Istanzia l'esplosione
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		explosion.lifetime = randf_range(0.3, 0.7)

		# Attacca l'esplosione alla scena principale
		get_tree().current_scene.add_child(explosion)
