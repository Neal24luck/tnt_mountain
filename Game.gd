extends Node

export(NodePath) var combat_screen
export(NodePath) var exploration_screen

const PLAYER_WIN = "res://dialogue/dialogue_data/player_won.json"
const PLAYER_LOSE = "res://dialogue/dialogue_data/player_lose.json"

func _ready():
	print("func_ready")
	print("func ready")
	exploration_screen = get_node(exploration_screen)
	print("10 neal")
	combat_screen = get_node(combat_screen)
	print("2wq")
	combat_screen.connect("combat_finished", self, "_on_combat_finished")
	print("3eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
	for n in $Exploration/Grid.get_children():
		print("4th")
		if not n.type == n.CellType.ACTOR:
			print("HIGH 5")
			continue
		if not n.has_node("DialoguePlayer"):
			continue
		n.get_node("DialoguePlayer").connect("dialogue_finished", self,
			"_on_opponent_dialogue_finished", [n])
	remove_child(combat_screen)


func start_combat(combat_actors):
	print("Start_Cobat")
	remove_child($Exploration)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	add_child(combat_screen)
	combat_screen.show()
	combat_screen.initialize(combat_actors)
	$AnimationPlayer.play_backwards("fade")


func _on_opponent_dialogue_finished(opponent):
	print("Inside _on_opponent_dialogue_finished ")
	if opponent.lost:
		return
	var player = $Exploration/Grid/Playerm


func _on_combat_finished(winner, _loser):
	print("func _on_combat_finished(winner, _loser):")
	remove_child(combat_screen)
	$AnimationPlayer.play_backwards("fade")
	add_child(exploration_screen)
	var dialogue = load("res://dialogue/dialogue_player/DialoguePlayer.tscn").instance()
	if winner.name == "Player":
		dialogue.dialogue_file = PLAYER_WIN
	else:
		dialogue.dialogue_file = PLAYER_LOSE
	yield($AnimationPlayer, "animation_finished")
	var player = $Exploration/Grid/Player
	exploration_screen.get_node("DialogueUI").show_dialogue(player, dialogue)
	combat_screen.clear_combat()
	yield(dialogue, "dialogue_finished")
	dialogue.queue_free()
