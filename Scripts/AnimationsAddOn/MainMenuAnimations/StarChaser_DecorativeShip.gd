extends Node2D

var direction: Vector2
var speed := 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 0
	randomize()
	# Calcola la direzione verso il centro dello schermo (posizione 0,0 è locale, quindi useremo global_position)
	# Lo spawner deve impostare la posizione fuori schermo prima di ready.
	var screen_center = Vector2(1152 / 2, 648 / 2)
	direction = (screen_center - global_position).normalized()
	
	# Ruota la navicella verso la direzione di movimento
	rotation = direction.angle()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Sposta la navicella nella direzione scelta
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
