extends Node2D

var direction: Vector2
var speed := 450

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 0
	randomize()
	var screen_center = Vector2(1152 / 2, 648 / 2)
	direction = (screen_center - global_position).normalized()
	rotation = direction.angle()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
