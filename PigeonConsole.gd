tool
extends EditorPlugin

const AUTOLOAD_NAME = "Console"

func _enter_tree():
	add_custom_type("PigeonConsole", "Control", preload("Console.gd"), preload("PigeonConsole.png"))
	#add_autoload_singleton(AUTOLOAD_NAME, "res://addons/PigeonConsole/Console.gd")


func _exit_tree():
	#remove_autoload_singleton(AUTOLOAD_NAME)
	remove_custom_type("PigeonConsole")
