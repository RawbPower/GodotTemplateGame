extends Node2D

@export var next_level: PackedScene
@export var level_timer: LevelTimer
@export var level_completed: ColorRect


func _ready():
	LevelTransition.fade_from_black()
	if level_completed:
		Events.level_completed.connect(show_level_completed)
	if level_timer:
		level_timer.start_timer()
	
func go_to_next_level():
	if not next_level is PackedScene:
		next_level = load("res://Base/Scenes/win_screen.tscn")
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	
func retry():
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func show_level_completed():
	level_completed.show()
	level_completed.continue_button.grab_focus()
	get_tree().paused = true


func _on_level_completed_next_level():
	go_to_next_level()

func _on_level_completed_retry():
	retry()
