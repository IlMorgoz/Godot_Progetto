extends CanvasLayer

@onready var contenitore = $Contenitore
@onready var lbl_titolo = $Contenitore/HBoxContainer/VBoxContainer/Titolo
@onready var lbl_descrizione = $Contenitore/HBoxContainer/VBoxContainer/Descrizione
@onready var icona_achievement = $Contenitore/HBoxContainer/TextureRect

# Aggiorniamo il dizionario aggiungendo la voce "icona"
var testi_achievements = {
	"primo_sparo": {
		"titolo": "Primo Sangue", 
		"desc": "Hai sparato il tuo primo proiettile!",
		"icona": preload("res://Sprites/Buttons/#TEMP1.png") 
	},
	"killer_kamikaze": {
		"titolo": "Sterminatore di ", 
		"desc": "Hai eliminato 10 Kamikaze!",
		"icona": preload("res://Sprites/Buttons/#TEMP4.png")
	},
	"killer_ufo": {
		"titolo": "Sterminatore di ufo", 
		"desc": "Hai eliminato 10 ufo!",
		"icona": preload("res://Sprites/Buttons/#TEMP2.png")
	}
}

func _ready():
	contenitore.modulate.a = 0
	contenitore.visible = false
	GameData.achievement_sbloccato.connect(mostra_popup)

func mostra_popup(id_achievement: String):
	# Prepariamo testi e immagine
	if testi_achievements.has(id_achievement):
		lbl_titolo.text = "🏆 " + testi_achievements[id_achievement]["titolo"]
		lbl_descrizione.text = testi_achievements[id_achievement]["desc"]
		# Cambiamo l'immagine assegnando quella del dizionario:
		icona_achievement.texture = testi_achievements[id_achievement]["icona"]
	else:
		lbl_titolo.text = "🏆 Sbloccato!"
		lbl_descrizione.text = id_achievement
		# Un'immagine di default nel caso ci scordassimo di metterla nel dizionario
		icona_achievement.texture = null 
		
	# ... (il resto del codice con l'animazione tween rimane UGUALE a prima)
	contenitore.visible = true
	var tween = create_tween()
	tween.tween_property(contenitore, "modulate:a", 1.0, 0.5)
	tween.tween_interval(5.0)
	tween.tween_property(contenitore, "modulate:a", 0.0, 0.5)
	tween.tween_callback(nascondi_contenitore)

func nascondi_contenitore():
	contenitore.visible = false
