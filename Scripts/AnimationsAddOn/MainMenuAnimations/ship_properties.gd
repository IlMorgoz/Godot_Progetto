extends Node2D

var direction: Vector2
var speed 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 0
	if (scene_file_path.get_file().get_basename()=="Aqua_DecorativeShip"):
		speed=450
	elif (scene_file_path.get_file().get_basename()=="Flash_DecorativeShip"):
		speed=400
	elif (scene_file_path.get_file().get_basename()=="Ninja_DecorativeShip"):
		speed=600
	elif (scene_file_path.get_file().get_basename()=="PurpleDevil_DecorativeShip"):
		speed=700
	elif (scene_file_path.get_file().get_basename()=="StarChaser_DecorativeShip"):
		speed=300
	else:
		speed=100
		
	randomize()
	var screen_center = Vector2(1152 / 2, 648 / 2)
	direction = (screen_center - global_position).normalized()
	rotation = direction.angle()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
