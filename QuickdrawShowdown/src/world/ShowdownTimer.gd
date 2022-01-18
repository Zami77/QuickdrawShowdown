extends Timer

var rng = RandomNumberGenerator.new()

export var timeRangeLow: float = 0.5
export var timeRangeHi: float = 4.5

func _ready():
	rng.randomize()
	var quickdrawStart = rng.randf_range(timeRangeLow, timeRangeHi)
	self.wait_time = quickdrawStart


func _on_ShowdownTimer_timeout():
	emit_signal("showdown_start")
