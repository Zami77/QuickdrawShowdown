extends Node2D

signal end_duel

var is_preduel: bool = true
var is_duelOver: bool = false

func _ready():
	$QuickdrawTimers/PreDuelTimer.connect("timeout", self, "start_duel")
	$QuickdrawTimers/DuelTimer.connect("duel_ended", self, "end_duel")

func start_duel() -> void:
	is_preduel = false

func end_duel() -> void:
	is_duelOver = true
	emit_signal("end_duel")

func _process(delta):
	if is_preduel:
		# Try to draw = loss
		pass
	elif is_duelOver:
		# duel is over, do nothing
		pass
	else:
		# in duel
		pass
