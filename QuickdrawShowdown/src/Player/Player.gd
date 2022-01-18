extends Node2D

var is_preduel: bool = false

func _ready():
	get_node("QuickdrawTimers/ShowdownTimers").connect("timeout", self, "set_preduel")

func set_preduel() -> void:
	is_preduel = true
