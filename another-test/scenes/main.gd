extends Node

@export var music : AudioStreamPlayer
@export var pause : Button
var dir_music = "/home/clumpl/Música/"
var ex : int = 0
var where_stopped : float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var directories := DirAccess.open(dir_music).get_directories()
	
	for dir in directories:
		create_button(dir, false)
	ex = 0
	pause.pressed.connect(stop_music)

func directory_chosen_get(dir : String) -> void:
	dir_music += dir+"/"
	var files := DirAccess.open(dir_music)
	
	var a = get_children()
	for ass in a:
		if(ass is Button and ass != pause):
			ass.queue_free.call_deferred()
	
	for musics in files.get_files():
		if(musics.get_extension() == "wav" || musics.get_extension() == "mp3" || musics.get_extension() == "ogg"):
			create_button(musics, true)
		if(musics.get_extension() == "jpg" || musics.get_extension() == "png"):
			print("hello")
			var sprite2d := Sprite2D.new()
			sprite2d.centered = false
			sprite2d.texture = ImageTexture.create_from_image(Image.load_from_file(dir_music+musics))
			sprite2d.position.x = 1152 - (sprite2d.texture.get_width()*0.135)
			sprite2d.position.y = 0
			sprite2d.scale *= 0.1
			add_child(sprite2d)
	
	for mm in files.get_directories():
		create_button(mm, false)

func play_music(nName : String) -> void:
	var path = dir_music+nName
	match nName.get_extension():
		"wav":
			music.stream = AudioStreamWAV.load_from_file(path)
		"ogg":
			music.stream = AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			music.stream = AudioStreamMP3.load_from_file(path)
		_:
			assert(false, "FORMAT " + nName.get_extension() + " IS NOT SUPPORTED!!!")
	print("playing " + nName.get_basename())
	music.play()

func create_button(dir : String, is_file : bool):
		var button := Button.new()
		button.text = dir
		button.position.y = ex
		ex+=31
		if is_file:
			button.pressed.connect(play_music.bind(dir))
		else:
			button.pressed.connect(directory_chosen_get.bind(dir))
		add_child(button)

func stop_music() -> void:
	if(music.playing):
		where_stopped = music.get_playback_position()
		music.stop()
	else:
		music.play(where_stopped)
