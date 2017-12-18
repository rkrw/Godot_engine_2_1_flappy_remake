extends Node2D


var current_scene
export (int, 0, 9999) var speed = 200
export (int, 0, 2048) var tube_wight = 96
export var removable = false
onready var coin = get_node("coin")
var scored
export var spawn_x = 0
export var spawn_y = 0

onready var add_score_sound = get_node("add_score")

func _ready ():
	randomize()
	current_scene = get_tree().get_current_scene()
	set_pos(Vector2(OS.get_window_size().x,-randi()%300))
	set_process(true)

func _process(delta):
	if current_scene.is_playing() == true:
		if get_pos().x > -tube_wight:
			set_pos(get_pos()-Vector2(speed*delta,0))
			removable = false
			
		else:
			set_pos(Vector2(OS.get_window_size().x,-randi()%300))
			coin.show()
			scored = false
			removable = true
			
func _on_Area2D3_body_enter( body ):
	print("got")
	if current_scene.is_playing() and not scored:
			add_score_sound.play()
			current_scene.add_score_big()
			scored = true
			coin.hide()
