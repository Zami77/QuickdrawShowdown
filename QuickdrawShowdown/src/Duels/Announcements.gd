extends Label

signal next_duel

export var roundEndTime: int = 3
export var nextRoundTime: int = 2

func _on_Player_start_round():
	self.text = "Draw!"


func _on_Player_end_round(win_message: String):
	self.text = win_message
	
	var t = Timer.new()
	t.set_wait_time(roundEndTime)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	self.text = "Next round coming!"
	
	t.set_wait_time(nextRoundTime)
	t.set_one_shot(true)
	t.start()
	yield(t, "timeout")
	
	emit_signal("next_duel")

func _on_StartDuelButton_start_duel():
	self.text = "Standby..."

func _on_Player_end_duel(win_message: String):
	self.text = win_message
