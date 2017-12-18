extends Node2D

var score = 0
var tube = preload("res://scene/tube.tscn")
var bat = preload("res://scene/bat.tscn")
var tubeD = preload("res://scene/tubeD.tscn")
var playing = true
var kill = false
var can_restart = false
var tube_half_w = 0
var tube_half_wB = 0
var bat_w = 0
var y_pos
var coin_spawn_base
var maxidx=0
#saving record
var savegame = File.new() #file
var save_path = "user://origin_game.save" #place of the file
var save_data = {} #variable to store data
var saveuser = File.new() #file
var user_path = "user://origin_user.save"
var user_data = {}

#saving config
var saveconfig = File.new() #file
var config_path = "user://origin_config.save"
var config_data = {}

var toogle_bat = false
var toogle_tube =false

var highscore
var spawned
var idx=0
var saved_idx=0
var mode
var play_time=0
var coin_spawn_time=0
var active_user = ""

export (int, 0, 64) var tube_count = 2
export (int, 0, 64) var tube_count_bonus = 1
export (int, 0, 64) var bat_count = 2

onready var label = get_node("label")
onready var lose = get_node("lose")
onready var announce = get_node("lose/announce")
onready var alert = get_node("Alert")
onready var score_board = get_node("score")
onready var notif = get_node("notif")
onready var tubes = get_node("tubes")
onready var tubesD = get_node("tubesD")
onready var bats = get_node("bats")
onready var start_time = get_node("start_time")
onready var player = get_node("player")
onready var dead_timer = get_node("dead_time")
onready var flash_anim = get_node("flash/anim")
onready var ground_anim = get_node("ground/anim")
onready var kill_sound = get_node("kill")

func _ready():
	lose.hide()
	announce.set_align(1)
	if saveconfig.file_exists(config_path):
		read_saveconfig()
	print(config_data["mode"])
	mode_prepare()
	set_idx()
	if not savegame.file_exists(save_path):
		create_save()
		read_saveuser()
		print("new save")
	else:
		read_savegame()
		read_saveuser()
	
	highscore = save_data[idx]
	print(highscore)
	set_title()
	print("mode"+str(mode))
	print("tube"+str(toogle_tube))
	print("bat"+str(toogle_bat))
	print("idx"+str(idx))
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.SCREEN_TOUCH or Input.is_action_pressed("ui_accept"):
		if event.is_pressed():
			print("tap first")
			on_tap()
			
func _process(delta):
	if playing:
		var tubes_ch = tubes.get_children()
		var bats_ch = bats.get_children()
		var tubesD_ch = tubesD.get_children()
		var tubesD_spawned_ch = tubesD.get_children()
		var tD = tubeD.instance()
		var t = tube.instance()
		#spawn tube
		if toogle_tube:
			if tubes_ch.back().get_pos().x < OS.get_window_size().x - (OS.get_window_size().x/tube_count) - tube_half_w and tubes_ch.size() < tube_count:
					tubes.add_child(tube.instance())
					print("spawned")
		#spawn Bats
		if toogle_bat:
			if bats_ch.back().get_pos().x < OS.get_window_size().x - (OS.get_window_size().x/bat_count) - bat_w and bats_ch.size() < bat_count:
					bats.add_child(bat.instance())
		#spawn bonus tube coin
		if toogle_tube:
			if tubes_ch.back().get_pos().x < OS.get_window_size().x - (OS.get_window_size().x/tube_count/2) - tube_half_w and (score % coin_spawn_base) == 0 and tubesD_ch.size()<tube_count_bonus and score !=0:
					print("coin")
					tubesD.add_child(tD)
					tubesD_spawned_ch = tubesD.get_children()
					spawned = true
		#remove coin
		if spawned:
			if tubesD_spawned_ch.back().get_pos().x<-tD.tube_wight:
				tubesD.get_child(0).queue_free()
				print("removable")
				spawned = false
		if mode==1:
			play_time+=delta
			coin_spawn_time+=delta
			if play_time>2:
				add_score()
				play_time=0
			if coin_spawn_time>5 and tubesD_ch.size()<tube_count_bonus:
				tubesD.add_child(tubeD.instance())
				tubesD_spawned_ch = tubesD.get_children()
				coin_spawn_time = 0
				spawned = true
			

func is_playing():
	return playing

func _on_start_time_timeout():
	var t = tube.instance()
	var b = bat.instance()
	bat_w = b.bat_wight/2
	tube_half_w = t.tube_wight/2
	if is_playing():
		set_process(true)
		if toogle_tube:
			tubes.add_child(t) #spawn first tube
		print("spawned2")
		if toogle_bat:
			bats.add_child(b)

func on_tap():
	print("tap")
	playing = true
	label.hide()
	alert.hide()
	score_board.set_text(str(score))
	set_process_input(false)
	start_time.start()
	player.set_sleeping(false)
	player.jump()
	
func create_save():
	save_data[idx]=0
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func save(in_score,idx):#save record
   save_data[idx] = in_score #data to save
   savegame.open(save_path, File.WRITE) #open file to write
   savegame.store_var(save_data) #store the data
   savegame.close() # close the file

func read_savegame():
	savegame.open(save_path, File.READ) #open the file
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	
func read_saveconfig():
	saveconfig.open(config_path, File.READ) #open the file
	config_data = saveconfig.get_var() #get the value
	saveconfig.close() #close the file
	mode = config_data["mode"]
	print(config_data["mode"])

func read_saveuser():
	saveuser.open(user_path, File.READ) #open the file
	user_data = saveuser.get_var() #get the value
	saveuser.close() #close the file
	active_user = user_data["active"]
	
func save_user(user,idx):#save record
	user_data[idx] = user #data to save
	active_user = user_data["active"]
	saveuser.open(user_path, File.WRITE)
	saveuser.store_var(user_data)
	saveuser.close()

func add_score():
	if not kill:
		score += 1
		score_board.set_text(str(score))
		
func add_score_big():
	if not kill:
		score += 10
		score_board.set_text(str(score))

func kill():
	if not kill:
		score_board.hide()
		kill = true
		dead_timer.start()
		flash_anim.play("flash")
		playing = false
		set_process(false)
		ground_anim.stop()
		set_idx()
		if score > highscore:
			save(score,idx)
			save_user(active_user,idx)
			announce.set_text("\nYOU LOSE\n\nNEW\nHIGH SCORE!:\n"+str(score))
		else:
			announce.set_text("\nYOU LOSE\n\nYOUR SCORE:\n"+str(score)+"\nHIGH SCORE\n"+str(highscore))
			var loop = maxidx
			while(idx<loop):
				if(score>save_data[idx]):
					break
				idx+=1
			save(score,idx)
			save_user(active_user,idx)
		kill_sound.play()

func kill_ground(body):
	player.set_sleeping(true)
	kill()

func has_restart():
	return can_restart

func mode_prepare():
	print("preparing")
	if mode==1:
		toogle_tube = false
		toogle_bat = true
		tube_count_bonus = 3
		coin_spawn_base = 0
		bat_count = 5
		saved_idx = 0
		maxidx = 4
	elif mode==2:
		toogle_bat = false
		toogle_tube = true
		coin_spawn_base = 10
		tube_count_bonus = 1
		saved_idx = 6
		maxidx = 10
	else:
		toogle_tube = true
		toogle_bat = true
		tube_count_bonus = 1
		coin_spawn_base = 5
		saved_idx = 11
		maxidx = 15

func set_idx():
	idx = saved_idx
func set_title():
	if mode==1:
		label.set_text("Bat Frenzy!")
	elif mode==2:
		label.set_text("Casual!")
	else:
		label.set_text("Normal Mode!")
	
func _on_exit_pressed():
	get_tree().change_scene("res://scene/ready.tscn")

func _on_retry_pressed():
	get_tree().change_scene("res://scene/main.tscn")

func _on_dead_time_timeout():
	can_restart = true
	lose.show()

func get_score():
	return score