extends Control

onready var setsets = get_node("../../../Control")

func AutoDetect(txtBox: TextEdit, sPackName: String, lblBox: Label, cmdBox: Button) -> bool:
	var jbExeName = sPackName + ".exe"
	var file = File.new()
	txtBox.text = "C:\\Program Files (x86)\\Steam\\steamapps\\common"
	if file.file_exists(txtBox.text + "\\" + sPackName + "\\" + jbExeName):
		txtBox.text = "C:\\Program Files (x86)\\Steam\\steamapps\\common" + "\\" + sPackName + "\\" + jbExeName
		lblBox.add_color_override("font_color", Color(0,1,0,1))
		cmdBox.disabled = true
		return true
	else:
		txtBox.text = ""		
		var alphabet: Array = ["A","B","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
		for i in len(alphabet):
			txtBox.text = str(alphabet[i]) + ":\\Steam\\steamapps\\common"
			if file.file_exists(txtBox.text + "\\" + sPackName + "\\" + jbExeName):				
				txtBox.text = str(alphabet[i]) + ":\\Steam\\steamapps\\common" + "\\" + sPackName + "\\" + jbExeName
				lblBox.add_color_override("font_color", Color(0,1,0,1))
				cmdBox.disabled = true
				return true
			txtBox.text = str(alphabet[i]) + ":\\Games\\SteamLibrary\\steamapps\\common"
			if file.file_exists(txtBox.text + "\\" + sPackName + "\\" + jbExeName):				
				txtBox.text = str(alphabet[i]) + ":\\Games\\SteamLibrary\\steamapps\\common" + "\\" + sPackName + "\\" + jbExeName
				lblBox.add_color_override("font_color", Color(0,1,0,1))
				cmdBox.disabled = true
				return true
	txtBox.text = ""			
	cmdBox.disabled = false
	return false

func _on_cmdAuto_pressed():
	if setsets.settings.get("Logging"): logLine("[Setup] Auto Scanning")
	$lblScan.text = "Scanning..."
	var foundStr: String = ""
	$cmdAuto.disabled = true
	if AutoDetect($txtPP1, "The Jackbox Party Pack", $lblPP1, $cmdPP1): foundStr = foundStr + "The Jackbox Party Pack" + "\n"
	if AutoDetect($txtPP2, "The Jackbox Party Pack 2", $lblPP2, $cmdPP2): foundStr = foundStr + "The Jackbox Party Pack 2" + "\n"
	if AutoDetect($txtPP3, "The Jackbox Party Pack 3", $lblPP3, $cmdPP3): foundStr = foundStr + "The Jackbox Party Pack 3" + "\n"
	if AutoDetect($txtPP4, "The Jackbox Party Pack 4", $lblPP4, $cmdPP4): foundStr = foundStr + "The Jackbox Party Pack 4" + "\n"
	if AutoDetect($txtPP5, "The Jackbox Party Pack 5", $lblPP5, $cmdPP5): foundStr = foundStr + "The Jackbox Party Pack 5" + "\n"
	if AutoDetect($txtPP6, "The Jackbox Party Pack 6", $lblPP6, $cmdPP6): foundStr = foundStr + "The Jackbox Party Pack 6" + "\n"
	if AutoDetect($txtPP7, "The Jackbox Party Pack 7", $lblPP7, $cmdPP7): foundStr = foundStr + "The Jackbox Party Pack 7" + "\n"
	if AutoDetect($txtPP8, "The Jackbox Party Pack 8", $lblPP8, $cmdPP8): foundStr = foundStr + "The Jackbox Party Pack 8" + "\n"
	if AutoDetect($txtSADrawful, "Drawful 2", $lblSADrawful, $cmdSADrawful): foundStr = foundStr + "Drawful 2" + "\n"
	if AutoDetect($txtSAFibbageXL, "Fibbage XL", $lblSAFibbageXL, $cmdSAFibbageXL): foundStr = foundStr + "Fibbish XL" + "\n"
	if AutoDetect($txtSAQuiplash, "Quiplash", $lblSAQuiplash, $cmdSAQuiplash): foundStr = foundStr + "Quiplash" + "\n"
	if AutoDetect($txtSAQuiplashB, "Quiplash 2 InterLASHional", $lblSAQuiplashB, $cmdSAQuiplashB): foundStr = foundStr + "Quiplash 2 InterLASHional" + "\n"
	$cmdAuto.disabled = false
	$lblScan.text = "Done Scanning!"
	if foundStr.length() > 0:
		OS.alert("Found the following:\n" + foundStr)
	if setsets.settings.get("Logging"): logLine("[Setup] " + foundStr.replace("\n", " "))

func _on_cmdSave_pressed():
	if setsets.settings.get("Logging"): logLine("[Setup] Saving")
	var config = ConfigFile.new()
	config.load("res://jt_settings.ini")
	config.set_value("Packs", "One", $txtPP1.text)
	config.set_value("Packs", "Two", $txtPP2.text)
	config.set_value("Packs", "Three", $txtPP3.text)
	config.set_value("Packs", "Four", $txtPP4.text)
	config.set_value("Packs", "Five", $txtPP5.text)
	config.set_value("Packs", "Six", $txtPP6.text)
	config.set_value("Packs", "Seven", $txtPP7.text)
	config.set_value("Packs", "Eight", $txtPP8.text)	
	config.set_value("Packs", "SAdf", $txtSADrawful.text)
	config.set_value("Packs", "SAf", $txtSAFibbageXL.text)
	config.set_value("Packs", "SAq", $txtSAQuiplash.text)
	config.set_value("Packs", "SAq2", $txtSAQuiplashB.text)	
	config.set_value("Settings", "Setup", true)	
	config.save("res://jt_settings.ini")
	OS.alert("If you ever need to adjust the packs here you can always go to the Settings tab and run Setup again!", "Jack's Trunk")
	var toplevel = get_node("../../../Control/HSplitContainer/ScrollContainer").show()
	get_node("../conSetup").hide()
	var allBtn = get_node("../../../Control/HSplitContainer/ScrollContainer/VBoxContainer/btnAll").emit_signal("pressed")

func _on_conSetup_ready():
	var toplevel = get_node("../../../Control/HSplitContainer/ScrollContainer").hide()

func _on_FileDialog_file_selected(path):
	if setsets.settings.get("Logging"): logLine("[Setup] FilePicker - " + str(path))
	match path.get_file():
		"The Jackbox Party Pack.exe":
			$txtPP1.text = path
			$lblPP1.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 2.exe":
			$txtPP2.text = path
			$lblPP2.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 3.exe":
			$txtPP3.text = path
			$lblPP3.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 4.exe":
			$txtPP4.text = path
			$lblPP4.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 5.exe":
			$txtPP5.text = path
			$lblPP5.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 6.exe":
			$txtPP6.text = path
			$lblPP6.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 7.exe":
			$txtPP7.text = path
			$lblPP7.add_color_override("font_color", Color(0,1,0,1))
		"The Jackbox Party Pack 8.exe":
			$txtPP8.text = path
			$lblPP8.add_color_override("font_color", Color(0,1,0,1))
		"Drawful 2.exe":
			$txtSADrawful.text = path
			$lblSADrawful.add_color_override("font_color", Color(0,1,0,1))
		"Fibbage XL.exe":
			$txtSAFibbageXL.text = path
			$lblSAFibbageXL.add_color_override("font_color", Color(0,1,0,1))
		"Quiplash.exe":
			$txtSAQuiplash.text = path
			$lblSAQuiplash.add_color_override("font_color", Color(0,1,0,1))
		"Quiplash 2 InterLASHional.exe":
			$txtSAQuiplashB.text = path
			$lblSAQuiplashB.add_color_override("font_color", Color(0,1,0,1))


func _on_cmdPP1_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP2_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 2.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP3_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 3.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP4_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 4.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP5_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 5.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP6_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 6.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP7_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 7.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdPP8_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("The Jackbox Party Pack 8.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdSADrawful_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("Drawful 2.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdSAFibbageXL_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("Fibbage XL.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdSAQuiplash_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("Quiplash.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

func _on_cmdSAQuiplashB_pressed():
	$FileDialog.clear_filters()
	$FileDialog.add_filter("Quiplash 2 InterLASHional.exe ; Game")
	$FileDialog.current_path = OS.get_system_dir(0)
	$FileDialog.popup_centered_ratio()

	
func logLine(sMsg: String):
	var file = File.new()
	var tStamp = OS.get_datetime()
	file.open("res://debug_log.txt", File.WRITE)
	file.seek_end()
	file.store_line(str(tStamp.month)+"/"+str(tStamp.day)+"/"+str(tStamp.year)+"/ "+str(tStamp.hour)+":"+str(tStamp.minute) + ": " + sMsg)
	file.close()
