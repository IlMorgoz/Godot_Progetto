extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var musica = $AudioStreamPlayer2D
@onready var options: Panel = $Options
@onready var armadietto: Panel = $Armadietto
@onready var upgrade_button := $Armadietto/Miglioramenti/Upgrade1
@onready var monete_label := $MoneteLabel
@onready var back := $Back
@onready var selection := $Gioca
@onready var statistiche := $LeaderboardMenu
@onready var user := $PlayerInfo
@export var profile_textures: Array[Texture2D]
@onready var icons := $Armadietto/Icons

func _ready() -> void:
	# UI Setup
	$MainButtons/Button1.z_index = 10
	$MainButtons/Button2.z_index = 10
	$MainButtons/Button3.z_index = 10
	$Label.z_index = 10
	
	musica.volume_db = 0 
	musica.play()
	
	main_buttons.visible = true
	options.visible = false
	armadietto.visible = false
	back.visible = false
	selection.visible = false
	statistiche.visible = false
	icons.visible = false

	# Caricamento stato Upgrade
	upgrade_button.button_pressed = GameData.triple_shot_enabled

	# Aggiornamento Monete
	_update_monete_label()
	GameData.monete_aggiornate.connect(_on_monete_aggiornate_signal)

	# Aggiornamento Icona Profilo
	GameData.profile_icon_changed.connect(_update_player_icon)
	_update_player_icon() # Imposta subito l'icona salvata
	
func _update_monete_label():
	monete_label.text = ": %d" % GameData.monete_stella

func _on_monete_aggiornate_signal(_nuovo_valore):
	_update_monete_label()

func _on_start_pressed():
	main_buttons.visible = false
	back.visible = false
	selection.visible = true

func _on_settings1_pressed():
	main_buttons.visible = false
	options.visible = true
	back.visible = true

func _on_settings2_pressed():
	main_buttons.visible = false
	armadietto.visible = true
	back.visible = true

func _on_back_options_pressed() -> void:
	selection.visible = false
	armadietto.visible = false
	options.visible = false
	back.visible = false
	main_buttons.visible = true
	statistiche.visible = false
	user.visible = true

func _on_mod_1_pressed() -> void:
	fade_out_music(0.5) 
	FadeTransition.change_scene("res://scenes/Game/Game.tscn")

func _on_mod_2_pressed() -> void:
	fade_out_music(0.5)
	FadeTransition.change_scene("res://scenes/Game/game_mode_waves.tscn")
	
func _on_mod_3_pressed() -> void:
	fade_out_music(0.5)
	FadeTransition.change_scene("res://scenes/Game/Game_Endless.tscn")

func fade_out_music(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(musica, "volume_db", -80.0, duration)
	tween.tween_callback(musica.stop)

func _on_player_info_pressed() -> void:
	main_buttons.visible = false
	options.visible = false
	armadietto.visible = false
	back.visible = true
	selection.visible = false
	statistiche.visible = true
	user.visible = false

func _update_player_icon():
	if GameData.current_icon_index < profile_textures.size():
		user.icon = profile_textures[GameData.current_icon_index]
	else:
		print("Errore: Indice icona non trovato nell'array!")
