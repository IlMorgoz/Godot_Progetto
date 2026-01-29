extends CanvasLayer

@onready var anim = $AnimationPlayer

func change_scene(target_scene_path: String) -> void:
	# 1️⃣ Fade in
	anim.play("dissolve")
	await anim.animation_finished
	
	# 2️⃣ Cambia scena
	get_tree().change_scene_to_file(target_scene_path)
	
	# 3️⃣ Aspetta un frame per essere sicuro che la nuova scena sia caricata
	await get_tree().process_frame
	
	# 4️⃣ Fade out
	anim.play_backwards("dissolve")
