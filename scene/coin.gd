extends Node2D


var current_scene
export var removable = false
onready var coin = get_node("coin")
onready var master = get_parent()
var scored
var fk_y
var main_scene = preload("res://scene/main.tscn")

export (int, 0, 9999) var speed = 96

export var spawn_x = 0
export var spawn_y = 0
onready var add_score_sound = get_node("add_score")

func _ready ():
	current_scene = get_tree().get_current_scene()
	set_process(true)
	
func _process(delta):
	if main_scene.is_playing()==true:
		set_pos(get_pos()-Vector2(speed*delta,fk_y))
	
func _on_Area2D3_body_enter( body ):
	if current_scene.is_playing() and not scored and not master.get_coin_hide_status():
			add_score_sound.play()
			current_scene.add_score_big()
			scored = true
			coin.show()

func set_init_pos(pos_y):
	fk_y = pos_y
