extends Panel

@onready var upgrade1=$Upgrade1
@onready var upgrade2=$Upgrade2
@onready var paywall1=$Button
@onready var paywall2=$Button2
@onready var nodo=get_parent()

func _ready():
	# Controlla lo stato di acquisto all'avvio e nasconde i bottoni di conseguenza
	if Global.triple_shot_purchased:
		paywall1.visible = false
	if Global.speed_boost_purchased:
		paywall2.visible = false

func _on_button_pressed() -> void:
	if MoneteManager.monete_stella < -500:
		print("Monete Insufficienti")
	else:
		MoneteManager.add_monete(-500)
		# Imposta lo stato di acquisto e salva
		Global.triple_shot_purchased = true
		Global.save_upgrades()
		# Nascondi il bottone dopo l'acquisto
		paywall1.visible = false
		
func _on_button_2_pressed() -> void:
	if MoneteManager.monete_stella < -750:
		print("Monete Insufficienti")
	else:
		MoneteManager.add_monete(-750)
		# Imposta lo stato di acquisto e salva
		Global.speed_boost_purchased = true
		Global.save_upgrades()
		# Nascondi il bottone dopo l'acquisto
		paywall2.visible = false

func _on_upgrade_1_toggled(toggled_on: bool) -> void:
	Global.triple_shot_enabled = toggled_on
	Global.save_upgrades()

func _on_upgrade_2_toggled(toggled_on: bool) -> void:
	Global.speed_boost_enabled = toggled_on
	Global.save_upgrades()
	print("NUOVO STATO VELOCITÀ BOOST:", toggled_on)
	
func _on_ritorno_pressed() -> void:
	nodo.turn_on(self)
