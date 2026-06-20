extends Node2D

@onready var player: Player = $Player
@onready var dirt: TileMapLayer = $GrassLayer
var tile_size = 16

func _ready() -> void:
	player.tool_used.connect(
		on_signal_player_tool_used
	)
func _process(delta: float) -> void:
	pass

func on_signal_player_tool_used(tool: Player.Tools, pos: Vector2)->void:
	var grid_pos: Vector2i = Vector2i(int(pos.x / tile_size), int(pos.y / tile_size))
	match tool:
		Player.Tools.dig:
			print("DIG", grid_pos)
			dirt.set_cell(grid_pos, 0, Vector2i(6,35));
		Player.Tools.water:
			print("WATER")
