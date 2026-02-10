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
@onready var icons := $Armadietto/Icons

func _ready() -> void:
	# Porta in primo piano i pulsanti
	$MainButtons/Button1.z_index = 10
	$MainButtons/Button2.z_index = 10
	$MainButtons/Button3.z_index = 10
	$Label.z_index = 10
	
	# Reset audio
	musica.volume_db = 0 
	musica.play()
	
	# Impostazioni visibilità
	main_buttons.visible = true
	options.visible = false
	armadietto.visible = false
	back.visible = false
	selection.visible = false
	statistiche.visible = false
	icons.visible = false

	# --- MODIFICA 1: Caricamento stato Upgrade da GameData ---
	# Usa GameData invece di Global
	upgrade_button.button_pressed = GameData.triple_shot_enabled

	# --- MODIFICA 2: Aggiornamento Monete ---
	_update_monete_label()
	
	# Colleghiamo il segnale: se GameData cambia i soldi, la label si aggiorna da sola
	GameData.monete_aggiornate.connect(_on_monete_aggiornate_signal)

# Funzione chiamata manualmente o dal segnale
func _update_monete_label():
	# Usa GameData invece di MoneteManager
	monete_label.text = ": %d" % GameData.monete_stella

# Funzione helper per gestire il segnale (che passa il nuovo valore come argomento)
func _on_monete_aggiornate_signal(_nuovo_valore):
	_update_monete_label()

func _on_start_pressed():
	main_buttons.visible = false
	back.visible = false
	selection.visible = true

func _on_settings1_pressed(): # Opzioni
	main_buttons.visible = false
	options.visible = true
	back.visible = true

func _on_settings2_pressed(): # Armadietto
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
