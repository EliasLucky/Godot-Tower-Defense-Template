extends Node

const SAVE_PATH := "user://save_data.json"

func _ready():
	call_deferred("load_game")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		Gameplay.game_loaded = true
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_string)
	if data == null: return

	#var pads = get_tree().get_nodes_in_group("buy_pad")
	#for pad in pads:
	#	if pad.has_method("set_load_state"):
	#		pad.set_load_state(data.get(pad.name, false))

	#var notices = get_tree().get_nodes_in_group("notice")
	#for notice in notices:
	#	notice.visible = data.get(notice.name, false)

	#Gameplay.player_money = data.get("player_money",0)
	#Gameplay.player_gems = data.get("player_gems",0)
	#Gameplay.game_loaded = true

func save_game():
	var data = {}
	
	#var pads = get_tree().get_nodes_in_group("buy_pad")
	#for pad in pads:
	#	if pad.has_method("get_load_state"):
	#		data[pad.name] = pad.get_load_state()
	
	#data["player_money"] = Gameplay.player_money
	#data["player_gems"] = Gameplay.player_gems

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()
