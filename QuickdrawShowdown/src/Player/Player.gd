extends Node2D

signal end_duel

export var enemyDrawTime: float = 0.5

var playerDrawTime: int = INF
var is_preduel: bool = true
var is_duelOver: bool = false
var is_playerDrawn: bool = false

onready var preDuelTimer: Timer = $QuickdrawTimers/PreDuelTimer
onready var duelTimer: Timer = $QuickdrawTimers/DuelTimer

func _ready():
	preDuelTimer.connect("timeout", self, "start_duel")
	duelTimer.connect("duel_ended", self, "end_duel")

func start_duel() -> void:
	is_preduel = false

func end_duel() -> void:
	is_duelOver = true
	emit_signal("end_duel")
	find_winner()

func find_winner() -> void:
	if playerDrawTime < enemyDrawTime:
		print("Player Wins!")
	else:
		print("Enemy Wins!")

func _process(delta):
	if is_duelOver or is_playerDrawn:
		pass
	if is_preduel:
		if Input.is_action_just_pressed("draw"):
			is_playerDrawn = true
	else:
		# in duel
		if Input.is_action_just_pressed("draw"):
			playerDrawTime = duelTimer.wait_time - duelTimer.time_left

