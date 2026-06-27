extends Node2D

@onready var player: Player = $Player
@onready var dirt: TileMapLayer = $GrassLayer
@onready var water_dirt_layer: TileMapLayer = $WaterDirtLayer
var tile_size = 16
var simple_dirt_tile_coords = Vector2i(6,35)
var water_new_tile = Vector2(50,12);


func _ready() -> void:
	player.tool_used.connect(
		on_signal_player_tool_used
	)
func _process(delta: float) -> void:
	pass

'''
In Editor select TileSet (right hand side) within TileMap
Add boolean data layer

In Editor select tileset (down) then paint the new data layer 
on the tile that can be watered

do this for dig too, check which tiles are diggable.
'''
func on_signal_player_tool_used(tool: Player.Tools, pos: Vector2)->void:
	var grid_pos: Vector2i = Vector2i(int(pos.x / tile_size), int(pos.y / tile_size))
	match tool:
		Player.Tools.dig:
			print("DIG", grid_pos)
			var dirt_data = dirt.get_cell_tile_data(grid_pos)
			var can_dig = dirt_data.get_custom_data("can_dig")
			print("can dig", can_dig)
			print(dirt_data)
			if(can_dig):
				dirt.set_cell(grid_pos, 0, simple_dirt_tile_coords);
		Player.Tools.water:
			var dirt_data = dirt.get_cell_tile_data(grid_pos)
			var can_water = dirt_data.get_custom_data("can_water")
			if(can_water):
				water_dirt_layer.set_cell(grid_pos, 0, water_new_tile)
