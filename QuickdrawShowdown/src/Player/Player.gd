extends Node2D

signal start_round
signal end_round
signal end_duel

export var enemyDrawTime: float = 0.5

var playerDrawTime: float = INF
var is_preduel: bool = true
var is_duelOver: bool = false
var is_playerDrawn: bool = false

var player_wins: int = 0
var enemy_wins: int = 0

const PLAYER_VICTORY_MSG = "Player won round!"
const PLAYER_DUEL_VICTORY_MSG = "Player won the duel!"
const ENEMY_VICTORY_MSG = "Enemy won round!"
const ENEMY_DUEL_VICTORY_MSG = "Enemy won the duel!"
const PLAYER_MISS_MSG = "Player never drew or drew early!"
const PLAYER_DRAW_TIME_MSG = "Player Draw Time:%s"
const DUEL_STATS = "Player Wins:%s Enemy Wins:%s"

const ROUNDS_TO_WIN: int = 1

onready var preDuelTimer: Timer = $QuickdrawTimers/PreDuelTimer
onready var duelTimer: Timer = $QuickdrawTimers/DuelTimer

func _ready():
	preDuelTimer.connect("timeout", self, "start_round")
	duelTimer.connect("round_ended", self, "end_round")

func startup_duel() -> void:
	player_wins = 0
	enemy_wins = 0
	
func start_round() -> void:
	is_preduel = false
	emit_signal("start_round")

func end_round() -> void:
	is_duelOver = true
	find_round_winner()

func find_round_winner() -> void:
	var win_message: String = ""
	if playerDrawTime < enemyDrawTime:
		player_wins += 1
		win_message = PLAYER_VICTORY_MSG
	else:
		enemy_wins += 1
		win_message = ENEMY_VICTORY_MSG
	if playerDrawTime == INF:
		win_message += "\n" + PLAYER_MISS_MSG
	else:
		win_message += "\n" + PLAYER_DRAW_TIME_MSG % playerDrawTime
	
	if player_wins >= ROUNDS_TO_WIN or enemy_wins >= ROUNDS_TO_WIN:
		win_message = PLAYER_DUEL_VICTORY_MSG if player_wins >= ROUNDS_TO_WIN else ENEMY_DUEL_VICTORY_MSG
		win_message += "\n" + DUEL_STATS % [player_wins, enemy_wins]
		emit_signal("end_duel", win_message)
		return
	emit_signal("end_round", win_message)

func _process(_delta):
	if is_duelOver or is_playerDrawn:
		return
		
	if is_preduel:
		if Input.is_action_just_pressed("draw"):
			is_playerDrawn = true
	else:
		# in duel
		if Input.is_action_just_pressed("draw"):
			playerDrawTime = duelTimer.wait_time - duelTimer.time_left

