extends CanvasLayer

@export var start_level: PackedScene

@onready var start_game_button = %StartGameButton


func _ready():
	start_game_button.grab_focus()

func _on_start_game_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(start_level)
	LevelTransition.fade_from_black()


func _on_quit_button_pressed():
	get_tree().quit()
