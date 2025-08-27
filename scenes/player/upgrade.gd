@tool
extends State

## Holds ordered list of upgrade states 
var levels := [
	"Level1",
	"Level2",
	"Level3",
]


func _on_player_upgrade_level_changed() -> void:
	change_state(levels[target.current_level])
