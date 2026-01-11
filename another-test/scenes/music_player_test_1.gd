extends Control
#there's probably a better way to do this
@export var music_player : AudioStreamPlayer
@export var container : VBoxContainer
@export var last : Button
@export var pause : Button
@export var next : Button

@export var progress_bar : HSlider
@export var fileDialog : FileDialog #

@export var pause_button_tx : Texture2D
@export var play_button_tx : Texture2D
@export var check_folder : Button
#TODO: make the path changable
var path : String
var _progress : float = 0.0
var songs_list : PackedStringArray
var current_song : int = 0
var stop : bool = false # TODO: probably not needed

func _ready() -> void:
	fileDialog.dir_selected.connect(get_dir)
	fileDialog.popup()
	check_folder.pressed.connect(open_file_dialog)

func get_dir(pathh : String) -> void: # doing all the stuff AFTER file is selected
	path = pathh+"/"
	_after_file_access()

func _process(_delta: float) -> void:
	if(music_player.playing && !stop):
		var m_playback_time = music_player.get_playback_position()
		var m_time = music_player.stream.get_length()/100
		if(m_playback_time != null):
			progress_bar.value = m_playback_time / m_time

func _after_file_access():
	songs_list = DirAccess.open(path).get_files()
	assert(DirAccess.get_open_error() == 0, "An Error ocurred while opening a folder")
	# when i erase something from the list while iterating on it
	# it could have unintended behaviour
	for song in songs_list.duplicate():
		if( song.get_extension() != "wav" && song.get_extension() != "ogg" 
									 	  && song.get_extension() != "mp3"):
			songs_list.erase(song)
			print("deleted " + song)
			continue
		var l := Label.new()
		l.text = song.get_basename()
		container.add_child(l)
	
	var first_song : String = path+songs_list[current_song]
	load_music(first_song)
	assert(music_player.stream != null, "music stream is not setted, no music found in this folder")
	
	progress_bar.drag_started.connect(stop_it)
	progress_bar.drag_ended.connect(slider)
	
	pause.pressed.connect(play_pause_music)
	next.pressed.connect(next_song.bind(false))
	last.pressed.connect(last_song)
	music_player.finished.connect(next_song.bind(true))

#TODO: add this to AudioStreamPlayer's script
func play_pause_music() -> void:
	var m_playback_time = music_player.get_playback_position()
	var m_time = music_player.stream.get_length()/100
	if(music_player.playing):
		pause.icon = play_button_tx
		
		_progress = m_playback_time
		_change_color(Color(255.014, 0.0, 0.0))
		progress_bar.value = m_playback_time / m_time
		music_player.stop()
	else:
		music_player.play(_progress)
		pause.icon = pause_button_tx
		_change_color(Color(0.0, 255.014, 0.0))

func next_song(is_music_player : bool):
	progress_bar.value = 0
	music_player.stop()
	_change_color(Color.WHITE)
	current_song = (current_song+1) % songs_list.size()
	_change_color(Color(0.0, 255.014, 0.0))
	var song_now = path + songs_list[current_song]
	pause.icon = play_button_tx
	load_music(song_now)
	if(!is_music_player):
		print("hii")
		music_player.play()
		pause.icon = pause_button_tx
	progress_bar.value = music_player.get_playback_position()

func last_song():
	progress_bar.value = 0
	music_player.stop()
	_change_color(Color.WHITE)
	current_song = (current_song-1) % songs_list.size()
	_change_color(Color(0.0, 255.014, 0.0))
	if(current_song < 0):
		current_song = songs_list.size()-1
	var song_now = path + songs_list[current_song]
	load_music(song_now)
	music_player.play()
	progress_bar.value = music_player.get_playback_position()

# TODO: change this to Container logic
func _change_color(color : Color):
	var a := container.get_children()
	if(a[current_song] is Label):
		var ll : Label = a[current_song]
		ll.modulate = color

# TODO: change this to HSlider logic
func stop_it():
	stop = true
	play_pause_music()

func slider(_holo):
	stop = false
	music_player.play((music_player.stream.get_length()/100)*progress_bar.value)
	_change_color(Color(0.0, 255.014, 0.0))

func load_music(holo : String): # func needs the full path or extension
	var song_now =  path + songs_list[current_song]
	match holo.get_extension():
		"wav":
			music_player.stream = AudioStreamWAV.load_from_file(song_now)
		"ogg":
			music_player.stream = AudioStreamOggVorbis.load_from_file(song_now)
		"mp3":
			music_player.stream = AudioStreamMP3.load_from_file(song_now)
		_:
			assert(false, "file type " + holo.get_extension() + " unknown")
	assert(music_player.stream != null, "song selected has not been queried correctly")

func open_file_dialog():
	fileDialog.popup()
