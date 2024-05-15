extends ItemList
var char_button:PackedScene = preload("res://Scenes/Menus/char_select_button.tscn")

var offset: float = 0.0

func _ready():
	# Opens character schema and converts it into a dictionary.
	# For Documentation on the schema check out the wiki.
	var CharSchemaJSON = FileAccess.open("res://CharacterSchema.json", FileAccess.READ).get_as_text()
	var CharSchema: Dictionary = JSON.parse_string(CharSchemaJSON)
	for character in CharSchema:
		create_char_button(CharSchema[character])

func create_char_button(CharacterProperties):
	var button = char_button.instantiate()
	button.text = CharacterProperties["name"]
	button.character_id = CharacterProperties["id"]
	button.global_position = Vector2(0, offset)
	add_child(button)
	offset += 64
