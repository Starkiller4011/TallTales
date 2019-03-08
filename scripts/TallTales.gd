extends Node2D

var player_words = []
var prompt = ["name", "thing", "feeling", "another feeling", "adjective", "some things"]
var story = "Once upon a time a %s ate a %s and felt %s. It was a %s day for all %s %s."

func _ready():
	$Blackboard/StoryText.clear()
	$Blackboard/TextBox.clear()
	$Blackboard/TextureButton/ButtonLabel.text = "Enter"
	var intro = "Welcome to Tall Tales!\n\n"
	intro += "We are going to create a tall tale together by mixing\n"
	intro += "and matching words together! Who doesn't like a good\n"
	intro += "story right? So without further ado let us begin!\n\n"
	intro += "Can I have a " + prompt[player_words.size()] + " please?"
	$Blackboard/StoryText.text = intro

func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		var new_text = $Blackboard/TextBox.get_text()
		_on_TextBox_text_entered(new_text)

func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	$Blackboard/TextBox.clear()
	check_player_words()

func is_story_done():
	return player_words.size() == prompt.size()

func prompt_player():
	$Blackboard/StoryText.text = ("Can I have a " + prompt[player_words.size()] + " please?")

func check_player_words():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	$Blackboard/StoryText.text = story % player_words
	end_game()

func end_game():
	$Blackboard/TextBox.queue_free()
	$Blackboard/TextureButton/ButtonLabel.text = "Again!"
