tool
extends Control

export (NodePath) var MainNode
var Key = "ui_focus_next"
var lineNum = 20

# var children = []
var color = Color(0, 0, 0, 0.5)
var my_style = StyleBoxFlat.new()
var textBuffer = []


var commands = {
	"reload": [funcref(self, "reloadCurrentScene"), "", "reloaded scene"],
	"help": [funcref(self, "prntHelp"), "", ""],
	"cls": [funcref(self, "ClsTextBuffer"), "", ""]
}
var text = []
var editInput = LineEdit
var currentInput = ""
var focused = false
var shown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	my_style.set_bg_color(color)
	anchor_right = 1
	anchor_bottom = 1
	
	
	
	commands["help"][2] = commands.keys()
	
	var vbox = VBoxContainer.new()
	vbox.rect_size = get_viewport().get_visible_rect().size
	add_child(vbox)
	var vbox2 = VBoxContainer.new()
	vbox2.add_constant_override("separation", -0)
	vbox.add_child(vbox2)
	
	for x in lineNum:
		if x + 1 != lineNum:
			var child = Label.new()
			child.rect_size.x = get_viewport().get_visible_rect().size.x
			#child.rect_size.y = 20
			#child.rect_position.y = x * 20
			child.add_stylebox_override("normal", my_style)
			child.text = ""
			vbox2.add_child(child)
			text.append(child)
		else:
			var child = LineEdit.new()
			editInput = child
			child.rect_size.x = get_viewport().get_visible_rect().size.x
			#child.rect_size.y = 20
			#child.rect_position.y = lineNum  * 20 - 20
			child.connect("text_changed", self, "OnEditedLine")
			vbox2.add_child(child)
	
	editInput.release_focus()
	focused = false
	rect_scale = Vector2(1, 0)
	shown = false

func loggWithout(strr):
	#var date = OS.get_datetime()
	#var displayDate = str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"]) + " " + str(date["hour"]) + ":" + str(date["minute"]) + ":" + str(date["second"])
	#var toLog = displayDate + " --> " + strr
	textBuffer.append(strr)
	
	for i in text.size():
		if i < textBuffer.size():
			text[text.size() - i - 1].text = textBuffer[textBuffer.size() - i - 1]

func loggMsg(strr):
	var date = OS.get_datetime()
	var displayDate = str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"]) + " " + str(date["hour"]) + ":" + str(date["minute"]) + ":" + str(date["second"])
	var toLog = displayDate + " --> " + strr
	textBuffer.append(toLog)
	
	for i in text.size():
		if i < textBuffer.size():
			text[text.size() - i - 1].text = textBuffer[textBuffer.size() - i - 1]
	
	#editInput.text = ""
	#currentInput = ""
	strr = ""

func logg(strr):
	var date = OS.get_datetime()
	var displayDate = str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"]) + " " + str(date["hour"]) + ":" + str(date["minute"]) + ":" + str(date["second"])
	var toLog = displayDate + " --> " + strr
	textBuffer.append(toLog)
	
	if strr in commands:
		commands[strr][0].call_func()
	else:
		textBuffer.append("--> wrong Commmand")
	
	for i in text.size():
		if i < textBuffer.size():
			text[text.size() - i - 1].text = textBuffer[textBuffer.size() - i - 1]
	
	editInput.text = ""
	currentInput = ""
	strr = ""

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and currentInput != "":
		logg(currentInput)
	pass
	
	
	if Input.is_action_just_pressed(Key):
		if !shown:
			editInput.grab_focus()
			focused = true
			rect_scale = Vector2(1 , 1)
			shown = true
	

	if focused and Input.is_action_just_pressed("ui_cancel"):
		if shown:
			editInput.release_focus()
			focused = false
			rect_scale = Vector2(1, 0)
			shown = false

func OnEditedLine(new_text):
	currentInput = new_text

func OnMouseEntered():
	editInput.grab_focus()

func ClsTextBuffer():
	textBuffer = []
	for _x in range(text.size()):
		loggWithout("")

func prntHelp():
	textBuffer.append(array_to_string(commands["help"][2]))

# custom functions for consol
func reloadCurrentScene():
	var _l = get_tree().reload_current_scene()

func prnt():
	textBuffer.append("shit done")

func _enter_tree():
	pass


func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i) + ", "
	return s

