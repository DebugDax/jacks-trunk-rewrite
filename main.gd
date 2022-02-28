extends Control

var key: String = ""
var iv: String = ""
	
var toast;
var formMode: String = "list"

const PORT = 9080
var _server = WebSocketServer.new()

var settings: Dictionary = {
	"Audio": false,
	"Logging": false,
	"Setup": false,
	"Stats": false,
	"UpdateCheck": false,
	"WebServer": false,
	"UpdateNews": false,
	"VideoPopup": false,
	"SmallList": false,
	"Version": "0.0",
	"Language": "default"
}
var packDirs: Dictionary = {
	"One": "",
	"Two": "",
	"Three": "",
	"Four": "",
	"Five": "",
	"Six": "",
	"Seven": "",
	"Eight": "",
	"SAdf": "",
	"SAf": "",
	"SAq": "",
	"SAq2": ""
}

func PrepGame(gameName: String, gamePack: String) -> bool:
	var file = File.new()
	#var packNum = packWordToNum(gamePack)
	var packNum = packNumToWord(gamePack)
	print("Prepping " + gameName)
	if !file.file_exists(str(readConfig("Packs", packNum, false))):
		OS.alert("The exe was not found for that game.")
		return false
	var patchPath = "res://patches/JBPP" + packNum + "_" + gameName.replace(" ", "") + ".patch"
	#if !file.file_exists(str(patchPath)):
		#OS.alert("The patch was not found for that game.")
		#return false
	if settings.Audio: 
		$HSplitContainer/conMain/AudioStreamPlayer.stream = "res://audio/button_chime.wav"
		$HSplitContainer/conMain/AudioStreamPlayer.play()
	return true
	
	

func packNumToWord(sGamePack: String) -> String:
	match sGamePack:
		"1": return "One"
		"2": return "Two"
		"3": return "Three"
		"4": return "Four"
		"5": return "Five"
		"6": return "Six"
		"7": return "Seven"
		"8": return "Eight"
		"0": return "Zero"
		"E": return "Extra"
	return ""
func packWordToNum(sGamePack: String) -> String:
	match sGamePack:
		"One": return "1"
		"Two": return "2"
		"Three": return "3"
		"Four": return "4"
		"Five": return "5"
		"Six": return "6"
		"Seven": return "7"
		"Eight": return "8"
		"Zero": return "0"
		"Extra": return "E"
	return ""

func readConfig(sSection: String, sKey: String, bMode: bool, sINIFile: String = "jt_settings.ini") -> String:
	var config = ConfigFile.new()
	config.load("res://" + sINIFile)
	if config.has_section_key(sSection, sKey):
		return config.get_value(sSection, sKey)
	else:
		if bMode:
			return "false"
		else:
			return ""
			
func logLine(sMsg: String):
	var file = File.new()
	var tStamp = OS.get_datetime()
	file.open("res://debug_log.txt", File.WRITE)
	file.seek_end()
	file.store_line(str(tStamp.month)+"/"+str(tStamp.day)+"/"+str(tStamp.year)+"/ "+str(tStamp.hour)+":"+str(tStamp.minute) + ": " + sMsg)
	file.close()
	
func _ready():	
	var file = File.new()
	if file.file_exists("res://jt_settings.ini"):
		if settings.Logging: logLine("Loading Existing Config")
		settings.Audio = bool(readConfig("Settings", "Audio", true))
		settings.Logging = bool(readConfig("Settings", "Logging", true))
		settings.Setup = bool(readConfig("Settings", "Setup", true))
		settings.Stats = bool(readConfig("Settings", "Stats", true))
		settings.UpdateCheck = bool(readConfig("Settings", "UpdateCheck", true))
		settings.WebServer = bool(readConfig("Settings", "WebServer", true))
		settings.SmallList = bool(readConfig("Settings", "SmallList", false))
		settings.UpdateNews = bool(readConfig("Main", "UpdateNews", true))
		settings.VideoPopup = bool(readConfig("Main", "VideoPopup", true))
		settings.Version = str(readConfig("Main", "Version", false))
		settings.Language = str(readConfig("Main", "Language", false))				
		packDirs.One = str(readConfig("Packs", "One", false))
		packDirs.Two = str(readConfig("Packs", "Two", false))
		packDirs.Three = str(readConfig("Packs", "Three", false))
		packDirs.Four = str(readConfig("Packs", "Four", false))
		packDirs.Five = str(readConfig("Packs", "Five", false))
		packDirs.Six = str(readConfig("Packs", "Six", false))
		packDirs.Seven = str(readConfig("Packs", "Seven", false))
		packDirs.Eight = str(readConfig("Packs", "Eight", false))		
		packDirs.SAdf = str(readConfig("Packs", "SAdf", false))
		packDirs.SAf = str(readConfig("Packs", "SAf", false))
		packDirs.SAq = str(readConfig("Packs", "SAq", false))
		packDirs.SAq2 = str(readConfig("Packs", "SAq2", false))		
			
	else:
		if settings.Logging: logLine("No Config Found, Creating...")
		var config = ConfigFile.new()
		config.set_value("Main", "UpdateNews", settings.UpdateNews)
		config.set_value("Main", "VideoPopup", settings.VideoPopup)
		config.set_value("Main", "Version", settings.Version)
		config.set_value("Main", "Language", settings.Language)
		config.set_value("Settings", "Audio", settings.Audio)
		config.set_value("Settings", "Logging", settings.Logging)
		config.set_value("Settings", "Setup", settings.Setup)
		config.set_value("Settings", "Stats", settings.Stats)
		config.set_value("Settings", "UpdateCheck", settings.UpdateCheck)
		config.set_value("Settings", "WebServer", settings.WebServer)
		config.set_value("Settings", "SmallList", settings.SmallList)
		config.set_value("Packs", "One", "")
		config.set_value("Packs", "Two", "")
		config.set_value("Packs", "Three", "")
		config.set_value("Packs", "Four", "")
		config.set_value("Packs", "Five", "")
		config.set_value("Packs", "Six", "")
		config.set_value("Packs", "Seven", "")
		config.set_value("Packs", "Eight", "")
		config.set_value("Packs", "SAdf", "")
		config.set_value("Packs", "SAf", "")
		config.set_value("Packs", "SAq", "")
		config.set_value("Packs", "SAq2", "")		
		config.save("res://jt_settings.ini")
		if settings.Logging: logLine("New Default Configuration Saved")
		
	var dir = Directory.new()
	dir.open("res://languages/")
	dir.list_dir_begin()
	while true:
		var filel = dir.get_next()
		if filel == "":
			break
		elif not filel.begins_with(".") and filel.ends_with("ini") and filel != "jt_settings.ini":
			$HSplitContainer/conSettings/OptionButton.add_item(filel)
			if filel == settings.Language:
				$HSplitContainer/conSettings/OptionButton.select($HSplitContainer/conSettings/OptionButton.get_item_count()-1)
	dir.list_dir_end()
		
	if settings.Audio:
		$HSplitContainer/conSettings/chkAudio.pressed = true
	else:
		$HSplitContainer/conSettings/chkAudio.pressed = false
		
	if settings.Logging:
		$HSplitContainer/conSettings/chkDebug.pressed = true
	else:
		$HSplitContainer/conSettings/chkDebug.pressed = false

	if settings.Stats:
		$HSplitContainer/conSettings/chkStats.pressed = true
	else:
		$HSplitContainer/conSettings/chkStats.pressed = false
		
	if settings.UpdateCheck:
		$HSplitContainer/conSettings/chkUpdate.pressed = true
	else:
		$HSplitContainer/conSettings/chkUpdate.pressed = false
		
	if settings.SmallList:
		$HSplitContainer/conSettings/chkSmallList.pressed = true
	else:
		$HSplitContainer/conSettings/chkSmallList.pressed = false
			
	if settings.WebServer:
		$HSplitContainer/conSettings/chkServer.pressed = true
		var addresses = []
		for ip in IP.get_local_addresses():
			if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
				addresses.push_back(ip)
		$HSplitContainer/conSettings/lblIP.text = str(addresses[0])
		if settings.Logging: logLine("Local IP - " + str(addresses[0]))
	else:
		$HSplitContainer/conSettings/chkServer.pressed = false
	
	if settings.Logging: logLine("Init Static Side Panel")	
	var favBtn = get_node("HSplitContainer/ScrollContainer/VBoxContainer/btnFavorites")
	var setBtn = get_node("HSplitContainer/ScrollContainer/VBoxContainer/btnSettings")
	var allBtn = get_node("HSplitContainer/ScrollContainer/VBoxContainer/btnAll")
	var filterBtn = get_node("HSplitContainer/ScrollContainer/VBoxContainer/btnFilter")
	var randomBtn = get_node("HSplitContainer/ScrollContainer/VBoxContainer/btnRandom")
	favBtn.connect("pressed", self, "_on_press_loadfav")
	setBtn.connect("pressed", self, "_on_press", ["Set"])
	allBtn.connect("pressed", self, "_on_press", ["All"])
	filterBtn.connect("pressed", self, "_on_press", ["Filter"])
	randomBtn.connect("pressed", self, "_on_press", ["Random"])
	allBtn.add_color_override("font_color", Color(0.30,0.50,0.90,1))
	setBtn.add_color_override("font_color", Color(0.60,0.90,0.60,1))
	favBtn.add_color_override("font_color", Color(0.80,0.50,0.70,1))
	filterBtn.add_color_override("font_color", Color(0.80,0.80,0.70,1))
	randomBtn.add_color_override("font_color", Color(0.80,0.30,0.30,1))
	
	if settings.Logging: logLine("Init Tree")
	var tree = get_node("HSplitContainer/conMain/VBoxContainer/Tree")
	tree.set_column_min_width(0, 1)
	tree.set_column_min_width(1, 1)
	tree.set_column_min_width(2, 1)
	tree.set_column_min_width(3, 1)
	tree.set_column_min_width(4, 1)	
	tree.set_column_min_width(5, 1)	
	tree.set_column_title(0, "Icon")
	tree.set_column_title(1, "Game")
	tree.set_column_title(2, "Players")
	tree.set_column_title(3, "Pack")
	tree.set_column_title(4, "Audience")
	tree.set_column_title(5, "Stream-Friendly")
	tree.set_column_titles_visible(true)
	
	var root = tree.create_item()
	root.set_text(0, "Root")
	root.set_text(0, "center")
	
	if settings.Logging: logLine("Init SQL")
	$Database.sql_read_games()
	$Database.sql_read_packs()
	$HSplitContainer/conMain/VBoxContainer/Tree.grab_focus()
	
	if settings.Logging: logLine("Init LAN Server")
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	_server.connect("data_received", self, "_on_data")
	
	if settings.WebServer:
		if settings.Logging: logLine("[LAN] Server Enabled, Activating...")
		var err = _server.listen(PORT)
		if err != OK:
			if settings.Logging: logLine("[LAN] Unable to Host")
			set_process(false)	
			
	if settings.Logging: logLine("Setup Screen Views")
	var _scenehide
	if !settings.Setup:
		_scenehide = get_node("HSplitContainer/ScrollContainer").hide()
		_scenehide = get_node("HSplitContainer/conMain").hide()
		_scenehide = get_node("HSplitContainer/conSetup").show()
	else:
		_scenehide = get_node("HSplitContainer/conSetup").hide()
		_scenehide = get_node("HSplitContainer/ScrollContainer").show()
		_scenehide = get_node("HSplitContainer/conMain").show()

func _on_output_received(text : String) -> void:
	if settings.Logging: logLine("Message: " + text)
	var readType : String = text.substr(0,1)
	if readType == "g":
		var gameData = text.split(",")
		var tree = get_node("HSplitContainer/conMain/VBoxContainer/Tree")
		var root = tree.get_root()
		var packNum : String = gameData[1]
		var gameName : String = gameData[2]
		if packNum == "e":
			if readConfig("Extra", gameName.replace(" ", ""), false).length() < 4:
				return
		
		var gameNameTranslated : String = gameName
		if settings.Language != "default":
			var lang = readConfig("GAMES", gameNameTranslated.replace(" ", ""), false, "languages/"+settings.Language)
			if lang.length() > 0:
				gameNameTranslated = lang				
		
		var gamePlayers : String = gameData[3]
		var gameAudience : String = gameData[4]
		var gameStream : String = gameData[5]
		var gameImage = Image.new()
		var gameIcon = ImageTexture.new()
		
		var child = tree.create_item(root)
		child.set_text_align(0, 1)
		child.set_text_align(1, 1)
		child.set_text_align(2, 1)
		child.set_text_align(3, 1)
		child.set_text_align(4, 1)
		child.set_text_align(5, 1)
		child.set_icon(0, gameIcon)
		child.set_text(1, gameNameTranslated)
		child.set_text(2, gamePlayers)
		child.set_text(3, packNum)
		child.set_text(4, gameAudience)
		child.set_text(5, gameStream)
			
		if ResourceLoader.exists("res://images/JBPP" + packNum + "/" + gameName + ".png"):
			gameImage.load("res://images/JBPP" + packNum + "/" + gameName + ".png")
			if settings.SmallList: gameImage.shrink_x2()
			gameIcon.create_from_image(gameImage)
			if settings.Logging: logLine("Adding Game (With_Image) - " + gameNameTranslated)
			$HSplitContainer/conMain/VBoxContainer/Tree/ItemList.add_item(gameNameTranslated, gameIcon, true)
		else:
			#$HSplitContainer/conMain/VBoxContainer/ItemList.add_item(gameName, null, true)			
			if settings.Logging: logLine("Adding Game - " + gameNameTranslated)
			$HSplitContainer/conMain/VBoxContainer/Tree/ItemList.add_item(gameNameTranslated, null, true)			
	elif readType == "p":
		var packNum : String = text.substr(2,1)
		if settings.Logging: logLine("Pack " + packNum + " Registered")
		var newButton := Button.new()	
		$HSplitContainer/ScrollContainer/VBoxContainer.add_child(newButton)
		newButton.text = "Pack " + packNum
		newButton.set("custom_colors/font_color", Color.limegreen)
		newButton.name = "btnPack" + packNum
		#newButton.add_font_override()
		newButton.connect("pressed", self, "_on_press", [str(packNum)])
		#newButton.add_color_override("font_color", Color(1,1,1,1))
		newButton.add_color_override("font_color", Color(0.8,0.8,0.1,1))
		#var gameImage = Image.new()
		#var gameIcon = ImageTexture.new()
		#gameImage.load("res://images/JBPP0/Drawful 2.png")
		#gameImage.shrink_x2()
		#gameIcon.create_from_image(gameImage)
		#newButton.icon = gameIcon
		newButton.icon = ResourceLoader.load("res://images/Icons/JBPP3.png")
	$HSplitContainer/conMain/VBoxContainer/Tree/ItemList.sort_items_by_text()
			
func _on_press(sPNum: String) -> void:
	if settings.Logging: logLine("[Side] Panel Pressed")
	var tree = get_node("HSplitContainer/conMain/VBoxContainer/Tree")
	if sPNum == "Set":
		if settings.Logging: logLine("[Side] Settings Selected")
		formMode = "settings"
		get_node("HSplitContainer/conMain").hide()
		get_node("HSplitContainer/conSettings").show()
	elif sPNum == "All":	
		if settings.Logging: logLine("[Side] All Selected")
		formMode = "list"	
		get_node("HSplitContainer/conMain").show()
		get_node("HSplitContainer/conSettings").hide()
		tree.clear()	
		var root = tree.create_item()
		root.set_text(0, "Root")
		root.set_text(0, "center")	
		$Database.sql_read_games()
	else:
		if settings.Logging: logLine("[Side] Pack Selected")
		formMode = "list"
		get_node("HSplitContainer/conMain").show()
		get_node("HSplitContainer/conSettings").hide()
		tree.clear()	
		var root = tree.create_item()
		root.set_text(0, "Root")
		root.set_text(0, "center")	
		$Database.sql_read_specific_pack_games(sPNum)
	
func _on_press_loadfav() -> void:
	if settings.Logging: logLine("[SideF] Favorites Selected")
	formMode = "fav"
	get_node("HSplitContainer/conMain").show()
	get_node("HSplitContainer/conSettings").hide()
	var tree = get_node("HSplitContainer/conMain/VBoxContainer/Tree")
	tree.clear()	
	var root = tree.create_item()
	root.set_text(0, "Root")
	root.set_text(0, "center")	
	$Database.sql_fav_read()
	
func _enter_tree():
	var _error : int = $Database.connect("output_received", self, "_on_output_received")

func _on_Tree_column_title_pressed(column):
	if settings.Logging: logLine("[Tree] Column " + str(column) + " Selected")
	if column == 1:
		showToast("normal", "Sorting Not Yet Implemented")
		# SORT TREE

func _on_Tree_item_activated():
	var tree = get_node("HSplitContainer/conMain/VBoxContainer/Tree")
	var sel = tree.get_selected()
	if sel.get_text(1).length() <= 1: return	
	if formMode == "fav":
		if Input.is_key_pressed(KEY_SHIFT):
			if $Database.sql_fav_remove(sel.get_text(1), int(sel.get_text(3))):
				showToast("full", "Removed from Favorites: " + sel.get_text(1))
			else:
				showToast("full", "Failed To Remove! :(")
			_on_press_loadfav()
		else:
			showToast("full", "Launching " + sel.get_text(1) + " ...")
	else:
		if Input.is_key_pressed(KEY_SHIFT):
			if $Database.sql_fav_add(sel.get_text(1), int(sel.get_text(3))):
				showToast("full", "Added to Favorites: " + sel.get_text(1))
			else:
				showToast("full", "Failed To Add! :(")
		else:
			print("Calling Prep")
			if !PrepGame(sel.get_text(1), sel.get_text(3)): 
				print("Failed")
			else:
				showToast("full", "Launching " + sel.get_text(1) + " ...")

func showToast(type: String, sMsg: String):
	if settings.Logging: logLine("[Toast] " + type + " - " + sMsg)
	match type:
		"normal":
			toast = Toast.new(sMsg, Toast.LENGTH_SHORT)
			get_node("/root").add_child(toast)
			toast.show()
		"full":
			toast = Toast.new(sMsg, Toast.LENGTH_SHORT, preload("res://full_bottom_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.show()
		"normal_top":
			toast = Toast.new(sMsg, Toast.LENGTH_SHORT, preload("res://float_top_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.show()
		"full_top":
			toast = Toast.new(sMsg, Toast.LENGTH_SHORT, preload("res://full_top_toast_style.tres"))
			get_node("/root").add_child(toast)
			toast.show()


func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	showToast("full", "WEB has Connected (" + str(id) + ")")
	print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	showToast("full", "WEB has Dirty Disconnected (" + str(id) + ")")
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	showToast("full", "WEB has Clean Disconnected (" + str(id) + ")")
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _server.get_peer(id).get_packet()
	if settings.Logging: logLine("[Web] Data Recvd - " + pkt.get_string_from_utf8())
	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	if pkt.get_string_from_utf8() == "shutdown":
		get_tree().quit()
	elif pkt.get_string_from_utf8() == "jbpp0_drawful2":
		# LAUNCH GAME
		showToast("full", "WEB has Launched Drawful 2")
	_server.get_peer(id).put_packet(pkt)

func _process(_delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	if settings.WebServer: _server.poll()

func _exit_tree():
	if settings.Logging: logLine("[Tree] Exit")
	_server.stop()

func validateExisting(txtPath: TextEdit, lblGame: Label, sPath: String) -> bool:
	#var setuplevel = get_node("../../HSplitContainer/conSetup")
	#validateExisting(get_node("../../HSplitContainer/conSetup/txtPP1"), get_node("../../HSplitContainer/conSetup/lblPP1"), toplevel.packDirs.get("One", ""))
	
	if sPath.length() <= 4: return false
	var file = File.new()
	if file.file_exists(sPath):
		txtPath.text = sPath
		lblGame.add_color_override("font_color", Color(0,1,0,1))
		return true	
	else:
		txtPath.text = ""
		lblGame.add_color_override("font_color", Color(1,0,0,1))
		return false
