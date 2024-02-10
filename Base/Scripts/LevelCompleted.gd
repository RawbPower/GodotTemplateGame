extends ColorRect

signal retry
signal next_level

@onready var retry_button = $CenterContainer/VBoxContainer/HBoxContainer/RetryButton
@onready var continue_button = $CenterContainer/VBoxContainer/HBoxContainer/ContinueButton

func _on_retry_pressed():
	retry.emit()


func _on_continue_pressed():
	next_level.emit()
