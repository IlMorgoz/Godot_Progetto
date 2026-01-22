extends Area2D

var direction: Vector2
const SPEED = 600
var damage: int = 6   # ogni proiettile infligge 6 danni al player
var explosion_scene = preload("res://scenes/AnimationAddOn/Explosion.tscn")

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Applica danno al giocatore
		if body.has_method("take_damage"):
			body.take_damage(damage)

		# Istanzia l'esplosione PRIMA di distruggere il proiettile
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		explosion.emitting = true
		get_tree().current_scene.add_child(explosion)

		# Poi elimina il proiettile
		queue_free()
