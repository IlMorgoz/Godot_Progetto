extends Node
var monete_stella: int = 5
@onready var monete_label=$MoneteLabel
func add_monete(amount: int) -> void:
	monete_stella += amount
	_update_monete_label()

func _update_monete_label():
	if monete_label:
		monete_label.text = ": %d" % monete_stella
