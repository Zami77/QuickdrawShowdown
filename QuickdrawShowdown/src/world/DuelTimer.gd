extends Timer

signal duel_ended

func _on_PreDuelTimer_timeout():
	self.start()


func _on_DuelTimer_timeout():
	emit_signal("duel_ended")
