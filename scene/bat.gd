extends Node2D
var crash
var current_scene
var current_anim = "Idle"
onready var anim = get_node("anim")
onready var sprite = get_node("AnimatedSprite")
export (int, 0, 9999) var speed = 400
export (int, 0, 2048) var bat_wight = 96


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	randomize()
	crash =false
	current_scene = get_tree().get_current_scene()
	set_pos(Vector2(OS.get_window_size().x,randi()%450))
	set_process(true)

func _process(delta):
	if current_scene.is_playing():
		if get_pos().x > -bat_wight:
			set_pos(get_pos()-Vector2(speed*delta,0))
		else:
			set_pos(Vector2(OS.get_window_size().x,randi()%450))
	elif not current_scene.is_playing() and not crash:
		anim.stop()
		pass
	elif crash:
		sprite.set_rotd(lerp(sprite.get_rotd(), -90.0, 5.0*delta))
		set_pos(get_pos()-Vector2(0,-speed*delta))

func _on_Area2D_body_enter( body ):
	current_scene.kill()
	crash = true
	if current_anim != "die":
		anim.play("die")
		current_anim = "die"

