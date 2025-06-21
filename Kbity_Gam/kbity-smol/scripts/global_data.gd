extends Node
var coins = 0
var happy_level: float = 0
var hungi_level: float = 0
var energy_level: float = 5
var cur_toy_level = 0
var cur_food_level = 0
var cur_litter_level = 0
var cur_bed_level = 0
var is_brushed = false
var is_played = false
var is_treated = false
var is_pet = false

var play_timer = 0
var brush_timer = 0
var treat_timer = 0
var pet_timer = 0

var paused = false

# Metadata section
var master_volume = 100
var music_volume = 100
var sfx_volume = 100

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "kbity_save.json"
const SECURITY_KEY = "8675309"

const CONFIG_DIR = "user://config/"
const CONFIG_FILE_NAME = "config.json"

func _ready() -> void:
	verify_save_directory(GlobalData.SAVE_DIR)
	verify_config_directory(GlobalData.CONFIG_DIR)
	load_config(CONFIG_DIR + CONFIG_FILE_NAME)
	load_data(SAVE_DIR + SAVE_FILE_NAME)
	
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func verify_config_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save_config(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"config_data": {
			"master_volume": GlobalData.master_volume,
			"music_volume": GlobalData.music_volume,
			"sfx_volume": GlobalData.sfx_volume
		}
	}
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_config(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json string: [%s]" % [path, content])
			return
			
		GlobalData.master_volume = data.config_data.master_volume
		GlobalData.music_volume = data.config_data.music_volume
		GlobalData.sfx_volume = data.config_data.sfx_volume
		
	else:
		print("No config found, loading up default values.")

func save_data(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, GlobalData.SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
		
	var data = {
		"player_data": {
			"coins": GlobalData.coins,
			"happy_level": GlobalData.happy_level,
			"hungi_level": GlobalData.hungi_level,
			"energy_level": GlobalData.energy_level,
			"cur_toy_level": GlobalData.cur_toy_level,
			"cur_food_level": GlobalData.cur_food_level,
			"cur_litter_level": GlobalData.cur_litter_level,
			"cur_bed_level": GlobalData.cur_bed_level,
			"is_brushed": GlobalData.is_brushed,
			"is_played": GlobalData.is_played,
			"is_treated": GlobalData.is_treated,
			"is_pet": GlobalData.is_pet,
			"play_timer": GlobalData.play_timer,
			"brush_timer": GlobalData.brush_timer,
			"treat_timer": GlobalData.treat_timer,
			"pet_timer": GlobalData.pet_timer
		}
	}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, GlobalData.SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json string: [%s]" % [path, content])
			return
		
		GlobalData.coins = data.player_data.coins
		GlobalData.happy_level = data.player_data.happy_level
		GlobalData.hungi_level = data.player_data.hungi_level
		GlobalData.energy_level = int(data.player_data.energy_level)
		GlobalData.cur_toy_level = int(data.player_data.cur_toy_level)
		GlobalData.cur_food_level = int(data.player_data.cur_food_level)
		GlobalData.cur_litter_level = int(data.player_data.cur_litter_level)
		GlobalData.cur_bed_level = int(data.player_data.cur_bed_level)
		GlobalData.is_brushed = bool(data.player_data.is_brushed)
		GlobalData.is_played = bool(data.player_data.is_played)
		GlobalData.is_treated = bool(data.player_data.is_treated)
		GlobalData.is_pet = bool(data.player_data.is_pet)
		GlobalData.play_timer = data.player_data.play_timer
		GlobalData.brush_timer = data.player_data.brush_timer
		GlobalData.treat_timer = data.player_data.treat_timer
		GlobalData.pet_timer = data.player_data.pet_timer
		
	else:
		printerr("Cannot open file at %s!" % [path])
