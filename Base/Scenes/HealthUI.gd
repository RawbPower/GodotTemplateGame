extends Control

@onready var heart_ui_full = $HeartUIFull
@onready var heart_ui_empty = $HeartUIEmpty

var hearts = 4:
	set = set_hearts
		
var max_hearts = 4:
	set = set_max_hearts
		
func _ready():
	self.max_hearts = PlayerStatus.max_health
	self.hearts = PlayerStatus.health
	PlayerStatus.connect("health_changed", set_hearts)
	PlayerStatus.connect("max_health_changed", set_max_hearts)
	
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full:
		heart_ui_full.size.x = hearts * 12
		
func set_max_hearts(value):
	max_hearts = max(value, 1)
	hearts = min(hearts, max_hearts)
	if heart_ui_empty:
		heart_ui_empty.size.x = max_hearts * 12
