extends Node2D

export var score = 0
var mode = 3
var show_mode=1
export var playing = false
export var toogle_bat = false
export var toogle_tube = false
export var toogle_coin = false
var kill = false
var current_user =""
var active_user = ""
#saving record
var savegame = File.new() #file
var save_path = "user://origin_game.save"
var save_data = {}
var saveuser = File.new() #file
var user_path = "user://origin_user.save"
var user_data = {}

#saving config
var saveconfig = File.new() #file
var config_path = "user://origin_config.save"
var config_data = {}
var name = config_path.get_base_dir()
onready var gr = get_node("ground")

var can_restart = false
var tube_half_w = 0
var tube_half_wB = 0
var bat_w = 0
var idx=0

onready var logo = get_node("LOGO")
onready var label = get_node("label")
onready var label1 = get_node("label1")
onready var label2 = get_node("label2")
onready var btn_play = get_node("Play")
onready var btn_option = get_node("Option")
onready var btn_Ladder = get_node("Ladder")
onready var btn_Exit = get_node("Exit")
onready var btn_Mode = get_node("Mode")
onready var btn_Next = get_node("Next")
onready var btn_Prev = get_node("Prev")
onready var usr_name = get_node("Menu/username")
onready var menu_reg = get_node("Menu")

#saving record
var highscore

func _ready():
	usr_name.set_align(1)
	usr_name.set_max_length(5)
	btn_Exit.hide()
	btn_Mode.hide()
	btn_Next.hide()
	btn_Prev.hide()
	if not saveuser.file_exists(user_path):
		reg_user()
	else:
		read_saveuser()
		current_user = active_user
		label2.set_text("Playing as\n"+current_user)
		if not saveconfig.file_exists(config_path):
			create_save_config()
			print(config_data["mode"])
			print("new config")
		else:
			read_saveconfig()
		idx_prepare()
		if not savegame.file_exists(save_path):
			create_save()
			print("new save")
		else:
			read_savegame()
		menu_reg.hide()
		label1.hide()
		btn_Exit.hide()
		btn_Mode.hide()
		btn_Next.hide()
		btn_Prev.hide()
		print(active_user)
#	label2.set_align("center")
	

func _on_Option_pressed():
	if mode==1:
		label1.set_text("Bat Frenzy")
	elif mode==2:
		label1.set_text("Casual Tube")
	elif mode==3:
		label1.set_text("Normal Mode")
	print(mode)

	label.hide()
	logo.set_text("Mode\nOption")
	btn_Ladder.hide()
	btn_play.hide()
	btn_option.hide()
	btn_Exit.show()
	label1.show()
	btn_Mode.show()

func _on_Play_pressed():
	get_tree().change_scene("res://scene/main.tscn")

func _on_Ladder_pressed():
	label.set_text("")
	idx_prepare()
	print("index: "+str(idx))
	var loop = idx+5
	var it = 1
	var scoreboard = ""
	if save_data[idx] ==0:
		scoreboard = "No Record yet!\n"
	else:
		while(idx<loop):
			if(save_data[idx]!=null and save_data[idx] !=0):
				scoreboard = scoreboard + (str(it)+"."+str(user_data[idx])+": "+str(save_data[idx])+"\n"	)
				it+=1
			idx+=1
	btn_Next.show()
	btn_Prev.show()
	btn_option.hide()
	btn_play.hide()
	btn_Ladder.hide()
	btn_Mode.hide()
	logo.set_text("Leader\nBoard")
	if show_mode==1:
		label.set_text("Bat Frenzy\nTop 5")
	elif show_mode==2:
		label.set_text("Casual Tube\nTop 5")
	elif show_mode==3:
		label.set_text("Normal Mode\nTop 5")
	elif show_mode<1:
		label.set_text("Casual Tube\nTop 5")
		show_mode=2
	else:
		label.set_text("Bat Frenzy\nTop 5")
	label1.set_text(scoreboard)
	label1.show()
	btn_Exit.show()

func _on_Exit_pressed():
	label1.hide()
	btn_Exit.hide()
	label.show()
	logo.set_text("Flappy\nGodot")
	btn_Ladder.show()
	btn_play.show()
	btn_option.show()
	btn_Mode.hide()
	label.set_text("-NIGHT-\n*/TAP/*")
	btn_Next.hide()
	btn_Prev.hide()
	save_config(mode)


func _on_Mode_pressed():
	mode+=1
	if mode==1:
		label1.set_text("Bat Frenzy")
	elif mode==2:
		label1.set_text("Casual Tube")
	elif mode==3:
		label1.set_text("Normal Mode")
	else:
		label1.set_text("Bat Frenzy")
		mode=1
	print(mode)

func read_savegame():
	savegame.open(save_path, File.READ) #open the file
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file

func create_save():
	var i = 0
	while i<16:
		save_data[i]=0
		i+=1
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()


func read_saveconfig():
	saveconfig.open(config_path, File.READ) #open the file
	config_data = saveconfig.get_var() #get the value
	saveconfig.close() #close the file
	mode = config_data["mode"]

func create_save_config():
	config_data["mode"]=1
	saveconfig.open(config_path, File.WRITE)
	saveconfig.store_var(config_data)
	saveconfig.close()
	mode = config_data["mode"]

func save_config(mode):#save record
   config_data["mode"] = mode #data to save
   saveconfig.open(config_path, File.WRITE) #open file to write
   saveconfig.store_var(config_data) #store the data
   saveconfig.close() # close the file


func _on_Next_pressed():
	show_mode+=1
	if show_mode==1:
		label.set_text("Bat Frenzy\nTop 5")
	elif show_mode==2:
		label.set_text("Casual Tube\nTop 5")
	elif show_mode==3:
		label.set_text("Normal Mode\nTop 5")
	elif show_mode>3:
		label.set_text("Bat Frenzy")
		show_mode=1
	print(show_mode)
	_on_Ladder_pressed()

func _on_Previous_pressed():
	show_mode-=1
	if show_mode==1:
		label.set_text("Bat Frenzy\nTop 5")
	elif show_mode==2:
		label.set_text("Casual Tube\nTop 5")
	elif show_mode==3:
		label.set_text("Normal Mode\nTop 5")
	elif show_mode<1:
		label.set_text("Normal Mode\nTop 5")
		show_mode=3
	print("prev")
	print(show_mode)
	_on_Ladder_pressed()

func idx_prepare():
	print("preparing")
	if show_mode==1:
		idx = 0
	elif show_mode==2:
		idx = 6
	elif show_mode==3:
		idx = 11
	print(show_mode)

func _on_Button_pressed():
	print("skip")
	if usr_name.get_text() != "":
		label.set_text("-NIGHT-\n*/TAP/*")
		menu_reg.hide()
		label.show()
		logo.show()
		btn_option.show()
		btn_Ladder.show()
		btn_play.show()
		label2.show()
		new_user()
		read_saveuser()
		current_user = active_user
		if not saveconfig.file_exists(config_path):
			create_save_config()
			print(config_data["mode"])
			print("new config")
		else:
			read_saveconfig()
		idx_prepare()
		if not savegame.file_exists(save_path):
				create_save()
				print("new save")
		else:
			read_savegame()

func read_saveuser():
	saveuser.open(user_path, File.READ) #open the file
	user_data = saveuser.get_var() #get the value
	saveuser.close() #close the file
	active_user = user_data["active"]
	

func create_save_user():
	var i = 0
	while i<16:
		user_data[i]=""
		i+=1
	user_data["active"] = current_user
	saveuser.open(user_path, File.WRITE)
	saveuser.store_var(user_data)
	saveuser.close()

func save_user(user,idx):#save record
	user_data[idx] = user #data to save
	active_user = user_data["active"]
	saveuser.open(user_path, File.WRITE)
	saveuser.store_var(user_data)
	saveuser.close()

func new_user():
	current_user = usr_name.get_text()
	create_save_user()
	active_user = user_data["active"]
	print(active_user)
	label2.set_text("Playing as\n"+current_user)
	
func reg_user():
	btn_play.hide()
	label1.hide()
	label.set_text("Welcome!")
	btn_option.hide()
	btn_Ladder.hide()
	label2.hide()