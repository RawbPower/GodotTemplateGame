class_name LevelTimer
extends Label

var level_time = 0.0
var start_time_msec = -1.0

# Called when the node enters the scene tree for the first time.
func start_timer():
	start_time_msec = Time.get_ticks_msec()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (start_time_msec >= 0.0):
		level_time = Time.get_ticks_msec() - start_time_msec
		text = "%0.2f" % (level_time / 1000.0)
