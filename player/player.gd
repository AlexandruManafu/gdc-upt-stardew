class_name Player extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var tools_animation: AnimatedSprite2D = $ToolsAnimatedSprite2d

@export var _speed: int = 100;
var walk_speed = 100.0
var run_speed = 200
var _direction: Vector2 = Vector2.ZERO
var press_x: bool
var press_z: bool
var face_direction = 1:
	set(value):
		face_direction = value
		animated_sprite_2d.flip_h = face_direction == -1;
		tools_animation.flip_h = face_direction == -1;
		
var is_running = false
var press_shift = false;
var selected_action = Tools.dig;
var mouse_up = false;
var mouse_down = false;
var click = false;
var walkable_anims = ["idle", "walk", "run"];
var can_move = true;

#TOOL
const TOOL_LEFT = 1.0
const TOOL_RIGHT = -1.0
const TOOL_OFFSET = 16

#region BUILT-IN
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if(!can_move): return;
	player_move()
	move_and_slide()
	
func _process(delta: float) -> void:
	if(!can_move): return;
	player_animate()

func _input(event: InputEvent) -> void:
	_direction = Input.get_vector("left", "right", "up", "down")
	press_x = Input.is_action_just_pressed("press_x")
	press_z = Input.is_action_just_pressed("press_z")
	press_shift = Input.is_action_pressed("press_shift")
	mouse_up = Input.is_action_just_pressed("mouse_wheel_up");
	mouse_down = Input.is_action_just_pressed("mouse_wheel_down");
	if(mouse_up || mouse_down):
		switch_tool();
	click = Input.is_action_just_pressed("click");

#endregion

func player_move() -> void:
	is_running = press_shift
	_speed = run_speed if is_running else walk_speed
	velocity = _direction * _speed;
	
func player_animate()->void:
	if(_direction.x != 0): face_direction = _direction.x
	if _direction != Vector2.ZERO && walkable_anims.has(animated_sprite_2d.animation):
		var anim = "run" if is_running else "walk"
		animated_sprite_2d.play(anim)
		tools_animation.play(anim)
	elif(click):
		can_move = false;
		animated_sprite_2d.play(Tools.keys()[selected_action])
		tools_animation.play(Tools.keys()[selected_action])
		await animated_sprite_2d.animation_finished
		await tools_animation.animation_finished
		_on_tool_finished(selected_action);
		can_move = true;
	else:
		animated_sprite_2d.play("idle")
		tools_animation.play("idle")
		
func switch_tool()-> void:
	if(mouse_up):
		selected_action = min(Tools.keys().size() - 1, selected_action + 1)
	elif(mouse_down):
		selected_action = max(0, selected_action - 1)
		
signal tool_used
func _on_tool_finished(tool: Tools)->void:
	var tool_dir = TOOL_RIGHT if face_direction == -1 else TOOL_LEFT
	var pos_offset = position + Vector2(tool_dir * TOOL_OFFSET, 0)
	tool_used.emit(tool, pos_offset)
		
enum Tools{
	dig,
	water
}
