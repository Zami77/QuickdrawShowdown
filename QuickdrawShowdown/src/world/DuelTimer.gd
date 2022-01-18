extends Timer

signal duel_ended

func _on_PreDuelTimer_timeout():
	print("DuelTimer started...")
	self.start()


func _on_DuelTimer_timeout():
	print("DuelTimer ended...")
	emit_signal("duel_ended")
