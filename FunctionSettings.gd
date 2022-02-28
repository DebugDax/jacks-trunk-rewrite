extends Control

onready var setsets = get_node("../../../Control")
var clickCount: int = 0

func readConfig(sSection: String, sKey: String, bMode: bool) -> String:
	var config = ConfigFile.new()
	config.load("res://jt_settings.ini")
	if config.has_section_key(sSection, sKey):
		return config.get_value(sSection, sKey)
	else:
		if bMode:
			return "false"
		else:
			return ""

func updateConfig(sSection: String, sKey: String, bMode: bool, bValue: bool = false, sValue: String = ""):
	var config = ConfigFile.new()
	config.load("res://jt_settings.ini")
	if bMode:
		print("INI Write B: " + str(bValue))
		config.set_value(sSection, sKey, bValue)
	else:
		print("INI Write B: " + str(sValue))
		config.set_value(sSection, sKey, sValue)
	config.save("res://jt_settings.ini") 

func validateExisting(txtPath: TextEdit, lblGame: Label, sPath: String) -> bool:
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
		
func _on_cmdSClearFav_pressed():	
	if get_node("../../Database").sql_fav_remove("all", 999):
		OS.alert("Favorites have been cleared!")	
	else:
		OS.alert("Something went wrong, your favorites could not be cleared.")

func _on_cmdSSetup_pressed():	
	var toplevel = get_node("../../../Control")
	var setuplevel = get_node("../../HSplitContainer/conSetup")
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP1"), get_node("../../HSplitContainer/conSetup/lblPP1"), toplevel.packDirs.get("One", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP2"), get_node("../../HSplitContainer/conSetup/lblPP2"), toplevel.packDirs.get("Two", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP3"), get_node("../../HSplitContainer/conSetup/lblPP3"), toplevel.packDirs.get("Three", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP4"), get_node("../../HSplitContainer/conSetup/lblPP4"), toplevel.packDirs.get("Four", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP5"), get_node("../../HSplitContainer/conSetup/lblPP5"), toplevel.packDirs.get("Five", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP6"), get_node("../../HSplitContainer/conSetup/lblPP6"), toplevel.packDirs.get("Six", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP7"), get_node("../../HSplitContainer/conSetup/lblPP7"), toplevel.packDirs.get("Seven", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtPP8"), get_node("../../HSplitContainer/conSetup/lblPP8"), toplevel.packDirs.get("Eight", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtSADrawful"), get_node("../../HSplitContainer/conSetup/lblSADrawful"), toplevel.packDirs.get("SAdf", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtSAFibbageXL"), get_node("../../HSplitContainer/conSetup/lblSAFibbageXL"), toplevel.packDirs.get("SAf", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtSAQuiplash"), get_node("../../HSplitContainer/conSetup/lblSAQuiplash"), toplevel.packDirs.get("SAq", ""))
	validateExisting(get_node("../../HSplitContainer/conSetup/txtSAQuiplashB"), get_node("../../HSplitContainer/conSetup/lblSAQuiplashB"), toplevel.packDirs.get("SAq2", ""))
	
	var scenehide
	scenehide = get_node("../../HSplitContainer/ScrollContainer").hide()
	scenehide = get_node("../../HSplitContainer/conMain").hide()
	scenehide = get_node("../../HSplitContainer/conSettings").hide()
	scenehide = get_node("../../HSplitContainer/conSetup").show()

func _on_chkUpdate_toggled(button_pressed):
	if bool(readConfig("Settings", "UpdateCheck", true)) != bool(button_pressed):
		setsets.settings["UpdateCheck"] = button_pressed
		updateConfig("Settings", "UpdateCheck", true, button_pressed)

func _on_chkAudio_toggled(button_pressed):
	if bool(readConfig("Settings", "Audio", true)) != bool(button_pressed):
		setsets.settings["Audio"] = button_pressed
		updateConfig("Settings", "Audio", true, button_pressed)

func _on_chkDebug_toggled(button_pressed):
	if bool(readConfig("Settings", "Logging", true)) != bool(button_pressed):
		setsets.settings["Logging"] = button_pressed
		updateConfig("Settings", "Logging", true, button_pressed)

func _on_chkStats_toggled(button_pressed):
	if bool(readConfig("Settings", "Stats", true)) != bool(button_pressed):
		setsets.settings["Stats"] = button_pressed
		updateConfig("Settings", "Stats", true, button_pressed)	

func _on_chkSmallList_toggled(button_pressed):
	if bool(readConfig("Settings", "SmallList", true)) != bool(button_pressed):
		setsets.settings["SmallList"] = button_pressed
		updateConfig("Settings", "SmallList", true, button_pressed)

func _on_chkServer_toggled(button_pressed):
	print("WebServer Click")
	if bool(readConfig("Settings", "WebServer", true)) != bool(button_pressed):
		setsets.settings["WebServer"] = button_pressed
		updateConfig("Settings", "WebServer", true, button_pressed)
	if button_pressed:
		print("WebServer Enable")
		var addresses = []
		for ip in IP.get_local_addresses():
			if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
				addresses.push_back(ip)
		$lblIP.text = str(addresses[0])
		var toplevel = get_node("../../../Control")		
		var err = toplevel._server.listen(toplevel.PORT)
		if err != OK:
			print("Unable to start server")
			$lblIP.text = str("ERROR")
			set_process(false)	
	else:
		print("WebServer Disable")
		$lblIP.text = str("N/A")
	pass # Replace with function body.

func _on_lblWebsite_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			OS.shell_open("https://foolishpixel.com/jackstrunk/web")

func _on_OptionButton_item_selected(index):
	if str(readConfig("Main", "Language", false)) != $OptionButton.get_item_text(index):
		OS.alert("Changes will take affect the next time Jack's Trunk is opened.")
		updateConfig("Main", "Language", false, false, $OptionButton.get_item_text(index))

func _on_cmdSRestore_pressed():
	# DO FILE COPY RESTORE OPERATIONS HERE
	pass # Replace with function body.


func _on_chkSkipIntro_toggled(button_pressed):
	# DO VIDEO SKIP FILE OPERATIONS HERE
	pass # Replace with function body.

func _on_lblEgg_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			clickCount = clickCount + 1
			print(clickCount)
			if clickCount == 10:
				OS.alert("/jtw?code=NICE")
