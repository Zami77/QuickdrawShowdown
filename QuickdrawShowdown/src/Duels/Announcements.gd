extends Label



func _on_Player_start_duel():
	self.text = "Draw!"


func _on_Player_end_duel(win_message: String):
	self.text = win_message
