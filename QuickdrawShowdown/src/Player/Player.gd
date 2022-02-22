extends Node2D

signal start_round
signal end_round
signal end_duel
signal enemy_sprite_update(enemy_sprite)

export var enemyDrawTime: float = 0.5
export var maxPlayerBoosts: int = 1
export var maxPlayerBlocks: int = 1

var playerDrawTime: float = INF
var is_preduel: bool = true
var is_duelOver: bool = true
var is_playerDrawn: bool = false
var is_playerBoosted: bool = false
var is_playerBlocked: bool = false

var player_wins: int = 0
var enemy_wins: int = 0
var cur_player_blocks: int = 0
var cur_player_boosts: int = 0

const PLAYER_VICTORY_MSG = "Player won round!"
const PLAYER_DUEL_VICTORY_MSG = "Player won the duel!"
const ENEMY_VICTORY_MSG = "Enemy won round!"
const ENEMY_DUEL_VICTORY_MSG = "Enemy won the duel!"
const PLAYER_MISS_MSG = "Player never drew or drew early!"
const PLAYER_BLOCK_MSG = "Player blocked attack!"
const PLAYER_STALEMATE_MSG = "Player and Enemy hit a stalemate!"
const PLAYER_DRAW_TIME_MSG = "Player Draw Time:%s"
const DUEL_STATS = "Player Wins:%s Enemy Wins:%s"

const ROUNDS_TO_WIN: int = 3
const BOOST_TIME: float = 0.05

onready var preDuelTimer: Timer = $QuickdrawTimers/PreDuelTimer
onready var duelTimer: Timer = $QuickdrawTimers/DuelTimer
onready var playerSprite: Sprite = $Sprite
onready var playerIdleTexture: Texture = load("res://assets/showdown-samurai-test.png")
onready var playerDrawnTexture: Texture = load("res://assets/showdown-samurai-test-sword-up.png")
onready var playerKOTexture: Texture = load("res://assets/showdown-samurai-test-KO.png")

func _ready():
	preDuelTimer.connect("preDuelTimerStart", self, "start_preduel")
	preDuelTimer.connect("timeout", self, "start_round")
	duelTimer.connect("round_ended", self, "end_round")

# -----------------------------------------------------------------------------
# ------------------------------ Duel/Round Logic -----------------------------
# -----------------------------------------------------------------------------

func start_preduel() -> void:
	is_playerDrawn = false
	is_playerBlocked = false
	is_playerBoosted = false
	playerDrawTime = INF
	is_duelOver = false
	playerSprite.texture = playerIdleTexture
	emit_signal("enemy_sprite_update", "idle")
	
func reset_duel() -> void:
	playerDrawTime = INF
	is_preduel = true
	is_duelOver = true
	is_playerDrawn = false
	is_playerBoosted = false
	is_playerBlocked = false
	player_wins = 0
	enemy_wins = 0
	cur_player_blocks = 0
	cur_player_boosts = 0
	
func start_round() -> void:
	is_preduel = false
	playerSprite.texture = playerIdleTexture
	emit_signal("enemy_sprite_update", "idle")
	emit_signal("start_round")

func end_round() -> void:
	is_duelOver = true
	find_round_winner()
	reset_round()

func reset_round() -> void:
	is_duelOver = true
	is_playerDrawn = false
	is_preduel = true
	is_playerBlocked = false
	is_playerBoosted = false
	playerDrawTime = INF

func handle_round_win() -> String:
	var win_message: String = ""
	
	if playerDrawTime < enemyDrawTime:
		player_wins += 1
		win_message = PLAYER_VICTORY_MSG
		playerSprite.texture = playerDrawnTexture
		emit_signal("enemy_sprite_update", "ko")
	elif playerDrawTime == enemyDrawTime:
		win_message = PLAYER_STALEMATE_MSG
		playerSprite.texture = playerDrawnTexture
		emit_signal("enemy_sprite_update", "sword")
	else:
		enemy_wins += 1
		win_message = ENEMY_VICTORY_MSG
		playerSprite.texture = playerKOTexture
		emit_signal("enemy_sprite_update", "sword")
		
	if playerDrawTime == INF:
		win_message += "\n" + PLAYER_MISS_MSG
	else:
		win_message += "\n" + PLAYER_DRAW_TIME_MSG % playerDrawTime
	
	return win_message

func is_final_match() -> bool:
	return player_wins >= ROUNDS_TO_WIN or enemy_wins >= ROUNDS_TO_WIN

func handle_final_match() -> void:
	var win_message = ""
	if player_wins >= ROUNDS_TO_WIN:
		win_message = PLAYER_DUEL_VICTORY_MSG
	else:
		win_message = ENEMY_DUEL_VICTORY_MSG
		playerSprite.texture = playerKOTexture
		emit_signal("enemy_sprite_update", "sword")
	win_message += "\n" + DUEL_STATS % [player_wins, enemy_wins]
	reset_duel()
	emit_signal("end_duel", win_message)
	
func find_round_winner() -> void:
	if is_playerBlocked:
		playerSprite.texture = playerDrawnTexture
		emit_signal("enemy_sprite_update", "sword")
		emit_signal("end_round", PLAYER_BLOCK_MSG)
		return
	
	var win_message = handle_round_win()
	
	if is_final_match():
		handle_final_match()
		return
	
	emit_signal("end_round", win_message)

# -----------------------------------------------------------------------------
# ------------------------------ Duel controls --------------------------------
# -----------------------------------------------------------------------------

func is_draw_illegal() -> bool:
	return is_duelOver or is_playerDrawn or is_playerBlocked or is_playerBoosted

func is_boosted_draw() -> bool:
	return Input.is_action_pressed("boost") and Input.is_action_just_pressed("draw") and not cur_player_boosts >= maxPlayerBoosts

func is_normal_draw() -> bool:
	return Input.is_action_just_pressed("draw")

func is_block() -> bool:
	return Input.is_action_just_pressed("block") and not cur_player_blocks >= maxPlayerBlocks
	
func handle_duel_input() -> void:
	if is_boosted_draw():
		playerDrawTime = duelTimer.wait_time - duelTimer.time_left - BOOST_TIME
		is_playerBoosted = true
		cur_player_boosts += 1
		print("BOOST")
			
	elif is_normal_draw():
		playerDrawTime = duelTimer.wait_time - duelTimer.time_left
		is_playerDrawn = true
	
	elif is_block():
		is_playerBlocked = true
		cur_player_blocks += 1

func handle_preduel_input() -> void:
	if is_boosted_draw():
		is_playerBoosted = true
		cur_player_boosts += 1
		print("BOOST FAIL")
		
	elif is_normal_draw():
		is_playerDrawn = true
		
	elif is_block():
		is_playerBlocked = true
		cur_player_blocks += 1
	
func _process(_delta):
	if is_draw_illegal():
		return
	if is_preduel:
		handle_preduel_input()
	else:
		# in duel
		handle_duel_input()
