extends Button

signal start_duel

func _on_StartDuelButton_pressed():
	emit_signal("start_duel")
	hide()

func _on_Announcements_next_duel():
	emit_signal("start_duel")


func _on_Player_end_duel(_win_message: String):
	self.text = "Duel Again!"
	show()
