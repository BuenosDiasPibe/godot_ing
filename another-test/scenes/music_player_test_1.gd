extends Control
@export var container : VBoxContainer
@export var last : Button
@export var pause : Button
@export var next : Button
@export var music_player : AudioStreamPlayer
@export var progress_bar : HSlider

#TODO: make the path changable
var path : String = "/home/clumpl/Música/Lateralis - OTXO Original Soundtrack/"
var _progress : float = 0.0
var songs_list : PackedStringArray
var current_song : int = 0

var stop : bool = false

func _ready() -> void:
	
	songs_list = DirAccess.open(path).get_files()
	assert(DirAccess.get_open_error() == 0, "An Error ocurred while opening a folder")
	
	var first_song : String = path+songs_list[current_song]
	for song in songs_list:
		if(song.get_extension() == "ogg"):
			var l := Label.new()
			l.text = song.get_basename()
			container.add_child(l)
		if(song.get_extension() == "png" || song.get_extension() == "jpg"):
			songs_list.erase(song)
	music_player.stream = AudioStreamOggVorbis.load_from_file(first_song)
	
	progress_bar.drag_started.connect(stop_it)
	progress_bar.drag_ended.connect(slider)
	
	pause.pressed.connect(play_pause_music)
	next.pressed.connect(next_song)
	last.pressed.connect(last_song)

func _process(_delta: float) -> void:
	if(music_player.playing && !stop):
		var m_playback_time = music_player.get_playback_position()
		var m_time = music_player.stream.get_length()/100
		if(m_playback_time != null):
			progress_bar.value = m_playback_time / m_time

#TODO: add this to AudioStreamPlayer's script
func play_pause_music() -> void:
	var m_playback_time = music_player.get_playback_position()
	var m_time = music_player.stream.get_length()/100
	if(music_player.playing):
		_progress = m_playback_time
		_change_color(Color(255.014, 0.0, 0.0))
		progress_bar.value = m_playback_time / m_time
		music_player.stop()
	else:
		music_player.play(_progress)
		_change_color(Color(0.0, 255.014, 0.0))

func next_song():
	progress_bar.value = 0
	music_player.stop()
	_change_color(Color.WHITE)
	current_song = (current_song+1) % songs_list.size()
	_change_color(Color(0.0, 255.014, 0.0))
	var song_now = path + songs_list[current_song]
	music_player.stream = AudioStreamOggVorbis.load_from_file(song_now)
	music_player.play()
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
	music_player.stream = AudioStreamOggVorbis.load_from_file(song_now)
	music_player.play()
	progress_bar.value = music_player.get_playback_position()


func _change_color(color : Color):
	var a := container.get_children()
	if(a[current_song] is Label):
		var ll : Label = a[current_song]
		ll.modulate = color
		
func stop_it():
	stop = true
	play_pause_music()

func slider(_holo) -> void:
	stop = false
	music_player.play((music_player.stream.get_length()/100)*progress_bar.value)
	
