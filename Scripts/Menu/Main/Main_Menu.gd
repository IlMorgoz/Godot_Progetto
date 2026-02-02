extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var musica = $AudioStreamPlayer2D
@onready var options: Panel = $Options
@onready var armadietto: Panel = $Armadietto
@onready var upgrade_button := $Armadietto/Miglioramenti/Upgrade1
@onready var monete_label := $MoneteLabel
@onready var back := $Back
@onready var selection := $Gioca

func _ready() -> void:
	# Porta in primo piano i pulsanti
	$MainButtons/Button1.z_index = 10
	$MainButtons/Button2.z_index = 10
	$MainButtons/Button3.z_index = 10
	$Label.z_index = 10
	
	# --- CORREZIONE QUI ---
	# Resettiamo il volume a 0 (massimo) prima di riprodurre, 
	# nel caso fosse rimasto basso da un precedente fade out.
	musica.volume_db = 0 
	musica.play()
	# ----------------------
	
	# Impostazioni visibilità
	main_buttons.visible = true
	options.visible = false
	armadietto.visible = false
	back.visible = false
	selection.visible = false
	
	# Stato upgrade attivo
	upgrade_button.button_pressed = Global.triple_shot_enabled

	# Mostra monete
	_update_monete_label()

func _update_monete_label():
	monete_label.text = ": %d" % MoneteManager.monete_stella

func _on_start_pressed():
	main_buttons.visible = false
	back.visible=false
	selection.visible=true

func _on_settings1_pressed(): # Opzioni
	main_buttons.visible = false
	options.visible = true
	back.visible=true

func _on_settings2_pressed(): # Armadietto
	main_buttons.visible = false
	armadietto.visible = true
	back.visible=true

func _on_back_options_pressed() -> void:
	selection.visible=false
	armadietto.visible = false
	options.visible = false
	back.visible=false
	main_buttons.visible=true
	
func _on_mod_1_pressed() -> void:
	fade_out_music(0.5) # Consiglio una durata più breve (0.5s) per transizioni rapide
	FadeTransition.change_scene("res://scenes/Game/Game.tscn")

func _on_mod_2_pressed() -> void:
	fade_out_music(0.5)
	FadeTransition.change_scene("res://scenes/Game/game_mode_waves.tscn")
	
func _on_mod_3_pressed() -> void:
	fade_out_music(0.5)
	FadeTransition.change_scene("res://scenes/Game/Game_Endless.tscn")
	
# --- FUNZIONE CORRETTA ---
func fade_out_music(duration: float = 1.0):
	var tween = create_tween()
	# Abbassa il volume a -80 (silenzio) nel tempo indicato
	tween.tween_property(musica, "volume_db", -80.0, duration)
	# Solo QUANDO HA FINITO, ferma il player
	tween.tween_callback(musica.stop)
