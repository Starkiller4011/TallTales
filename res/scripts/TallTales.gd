extends Node2D

var player_words = []
var template
var current_story
var strings

func _ready():
	template = get_from_json("res/json/stories.json")
	strings = get_from_json("res/json/strings.json")
	set_random_story()
	$Blackboard/TextBox.clear()
	$Blackboard/StoryText.clear()
	$Blackboard/TextureButton/ButtonLabel.text = strings.pre_label
	$Blackboard/StoryText.text = get_intro()

func get_intro():
	var intro = strings.intro
	intro += (strings.story % current_story.name)
	intro += (strings.prompt % current_story.prompt[player_words.size()])
	return intro

func set_random_story():
	randomize()
	current_story = template[randi() % template.size()]

func get_from_json(filename):
	var file = File.new() # File object
	file.open(filename, File.READ) # Assumes file exists and is json file
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

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
	return player_words.size() == current_story.prompt.size()

func prompt_player():
	$Blackboard/StoryText.text = (strings.prompt % current_story.prompt[player_words.size()])

func check_player_words():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	$Blackboard/StoryText.text = current_story.story % player_words
	end_game()

func end_game():
	$Blackboard/TextBox.queue_free()
	$Blackboard/TextureButton/ButtonLabel.text = strings.post_label
