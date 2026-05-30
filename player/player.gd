extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


@export var _speed: int = 300;
var _direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("left", "right", "up", "down")
	velocity = _direction * _speed;
	
	if _direction != Vector2.ZERO:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	move_and_slide()
