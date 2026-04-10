extends Node2D

@onready var statistiche: Label = $Panel/Stats
@onready var phrase: Label = $Panel/Phrase
@onready var replay: Button = $Panel/Replay 
@onready var menu: Button = $Panel/Menu

# Viene chiamata dallo script del gioco appena prima di mostrare questa schermata
func setup_game_over(monete, uccisioni, tempo_testo, survived) -> void:
	statistiche.text = generate_stats(monete, uccisioni, tempo_testo)
	phrase.text = generate_phrase(survived)

func generate_stats(monete: int, uccisioni: int, tempo_testo: String) -> String:
	var testo = "--- STATISTICHE ---\n"
	testo += tempo_testo + "\n"
	testo += "Nemici Distrutti: " + str(uccisioni) + "\n"
	testo += "Monete Ottenute: " + str(monete)
	return testo

func generate_phrase(survived: bool) -> String:
	if survived:
		return "Hai Sopravvissuto!"
	else:
		return "Nave Distrutta!"

func _on_replay_pressed() -> void:
	# Controlla che il percorso della scena di gioco sia corretto
	var game_scene_path = "res://scenes/Game/Game.tscn" 
	
	if FileAccess.file_exists("res://scenes/AnimationAddOn/fade_transition.tscn"):
		FadeTransition.change_scene(game_scene_path)
	else:
		get_tree().change_scene_to_file(game_scene_path)
	
func _on_menu_pressed() -> void:
	if FileAccess.file_exists("res://scenes/AnimationAddOn/fade_transition.tscn"):
		FadeTransition.change_scene("res://scenes/Menu/Main_Menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/Menu/Main_Menu.tscn")
