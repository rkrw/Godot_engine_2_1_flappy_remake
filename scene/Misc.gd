extends Node2D

var current_scene
export (int, 0, 9999) var speed = 96
export (int, 0, 2048) var bat_wight = 96


func _ready ():
	randomize()#reseting the randomized number to new value
	current_scene = get_tree().get_current_scene()
	set_pos(Vector2(OS.get_window_size().x,randi()%300))#random number between 0-299 and set it as height
	set_process(true)

func _process(delta):
	if current_scene.is_playing() == true:
		if get_pos().x > -bat_wight:
			set_pos(get_pos()-Vector2(speed*delta,0))
		else:
			set_pos(Vector2(OS.get_window_size().x,randi()%300))
			
func _on_Area2D_body_enter( body ):
	current_scene.kill()

