extends Node2D

signal start_duel
signal end_duel

export var enemyDrawTime: float = 0.5

var playerDrawTime: float = INF
var is_preduel: bool = true
var is_duelOver: bool = false
var is_playerDrawn: bool = false

const PLAYER_VICTORY_MSG = "Player Wins!"
const ENEMY_VICTORY_MSG = "Enemy Wins!"
const PLAYER_MISS_MSG = "Player never drew or drew early!"
const PLAYER_DRAW_TIME_MSG = "Player Draw Time:%s"

onready var preDuelTimer: Timer = $QuickdrawTimers/PreDuelTimer
onready var duelTimer: Timer = $QuickdrawTimers/DuelTimer

func _ready():
	preDuelTimer.connect("timeout", self, "start_duel")
	duelTimer.connect("duel_ended", self, "end_duel")

func start_duel() -> void:
	is_preduel = false
	emit_signal("start_duel")

func end_duel() -> void:
	is_duelOver = true
	find_winner()

func find_winner() -> void:
	var win_message: String = ""
	if playerDrawTime < enemyDrawTime:
		win_message = PLAYER_VICTORY_MSG
	else:
		win_message = ENEMY_VICTORY_MSG
	if playerDrawTime == INF:
		win_message += "\n" + PLAYER_MISS_MSG
	else:
		win_message += "\n" + PLAYER_DRAW_TIME_MSG % playerDrawTime
	emit_signal("end_duel", win_message)

func _process(delta):
	if is_duelOver or is_playerDrawn:
		return
		
	if is_preduel:
		if Input.is_action_just_pressed("draw"):
			is_playerDrawn = true
	else:
		# in duel
		if Input.is_action_just_pressed("draw"):
			playerDrawTime = duelTimer.wait_time - duelTimer.time_left

