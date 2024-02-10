extends CanvasLayer

@onready var menu_button = %MenuButton

func _ready():
	LevelTransition.fade_from_black()
	menu_button.grab_focus()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Base/Scenes/start_menu.tscn")
