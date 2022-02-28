extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db

var db_name := "res://db/JTDB"
var fav_db := "res://db/JTDB_Fav"

signal output_received(text)

#func _ready():
	#
			
func cprint(text : String) -> void:
	#print(text)
	emit_signal("output_received", text)

func sql_fav_add(sGame: String, sPack: int) -> bool:
	db = SQLite.new()
	db.path = fav_db
	db.verbose_mode = false
	db.open_db()	
	var row_array : Array = []
	var row_dict : Dictionary = Dictionary()
	row_dict["game"] = sGame
	row_dict["pack"] = sPack
	row_array.append(row_dict.duplicate())
	db.insert_row("favorites", row_dict)
	row_dict.clear()
	db.close_db()
	return true

func sql_fav_read():
	var selected_array : Array 
	var gameDic: Dictionary
	db = SQLite.new()
	db.path = fav_db
	db.verbose_mode = false
	db.open_db()
	selected_array = db.select_rows("favorites", "", ["*"])
	if selected_array.size() > 0:
		for i in range(0, selected_array.size()):
			gameDic = sql_specific_game(selected_array[i]["game"])
			cprint(str("g,"+str(gameDic.Pack)+','+gameDic.Name+','+str(gameDic.Players)+','+str(gameDic.Audience)+','+str(gameDic.StreamFriendly)))
	db.close_db()
	
func sql_fav_remove(sGame: String, sPack: int) -> bool:
	db = SQLite.new()
	db.path = fav_db
	db.verbose_mode = true
	db.open_db()
	if sGame == "all":
		db.delete_rows("favorites", '1=1')
	else:
		db.delete_rows("favorites", 'game = "' + sGame + '"')
	db.close_db()
	return true

func regexp(pattern : String, subject : String) -> bool:
	var regex = RegEx.new()
	regex.compile(pattern)
	var result = regex.search(subject)
	if result:
		return true
	else:
		return false

func sql_specific_game(sGameName: String) -> Dictionary:
	var returnDic: Dictionary = {
		"Pack": "",
		"Name": "",
		"Players": "",
		"Audience": "",
		"StreamFriendly": ""
	}
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = false
	db.read_only = true
	db.open_db()
	var select_condition : String = 'Name = "' + sGameName + '"'
	var selected_array : Array = db.select_rows("gameList", select_condition, ["*"])
	if selected_array.size() > 0:
		returnDic.Pack = str(selected_array[0]["Pack"])
		returnDic.Name = str(selected_array[0]["Name"])
		returnDic.Players = str(selected_array[0]["Players"])
		returnDic.Audience = str(selected_array[0]["Audience"])
		returnDic.StreamFriendly = str(selected_array[0]["StreamFriendly"])
	db.close_db()
	return returnDic
	
func sql_read_games():
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = false
	db.read_only = true
	db.open_db()
	#var select_condition : String = ''
	#var selected_array : Array = db.select_rows("gameList", select_condition, ["*"])
	db.query('SELECT * FROM gameList ORDER BY "Name";')
	var selected_array : Array = db.query_result
	if selected_array.size() > 0:
		for i in range(0, selected_array.size()):
			cprint(str("g,"+str(selected_array[i]["Pack"]))+','+selected_array[i]["Name"]+','+str(selected_array[i]["Players"])+','+str(selected_array[i]["Audience"])+','+str(selected_array[i]["StreamFriendly"]))
	db.close_db()
	
func sql_read_specific_pack_games(sPack: String):
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = false
	db.read_only = true
	db.open_db()
	
	db.query('SELECT * FROM gameList WHERE Pack = "' + sPack + '" ORDER BY "Name";')
	var selected_array : Array = db.query_result
	
	#var select_condition : String = "Pack = " + sPack
	#var selected_array : Array = db.select_rows("gameList", select_condition, ["*"])
	if selected_array.size() > 0:
		for i in range(0, selected_array.size()):
			cprint(str("g,"+str(selected_array[i]["Pack"]))+','+selected_array[i]["Name"]+','+str(selected_array[i]["Players"])+','+str(selected_array[i]["Audience"]))
	#cprint("result: {0}".format([String(selected_array)]))
		
	# Select all the creatures that start with the letter 'b'
	#select_condition = "name LIKE 'b%'"
	#selected_array = db.select_rows("packList", select_condition, ["name"])
	#cprint("condition: " + select_condition)
	#cprint("Following creatures start with the letter 'b':")
	#for row in selected_array:
	##	cprint("* " + row["name"])
	db.close_db()

func sql_read_packs():
	db = SQLite.new()
	db.path = db_name
	db.verbose_mode = false
	db.read_only = true
	db.open_db()
	var select_condition : String = ""
	var selected_array : Array = db.select_rows("packList", select_condition, ["*"])
	if selected_array.size() > 0:
		for i in range(0, selected_array.size()):
			cprint(str("p,"+str(selected_array[i]["PackNum"])))
	db.close_db()
