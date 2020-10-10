extends Node

var season = 0 # spring, summer, fall, winter
var low = 0  #low temp
var high = 0 #high temp
var current_temperature = 0

var time = 0
var seconds = 0 # how many seconds has passed
var minutes = 0 # how many minutes has passed
var day = 0 # the current day

const timed_seconds = 1 #ms, from 0-1, 1 is 1 real second
const timed_minutes = timed_seconds*60 # real minutes

export (int) var day_length = 4 # how many real minutes a day lasts
export (int) var season_length = 15 # how many days are in each season

var daily_change = 0 # the temp change throughout the day
var update_mid= true # updates the temp change

func _ready():
	gen_temp_ranges(3)
	current_temperature = (abs(low)+high) / 2

func _process(delta):
	time_controller(delta)
	temperature_controller()

func gen_temp_ranges(var _season):
	randomize()
	season = _season
	
	match season:
		0: #spring
			low = rand_range(50,60)
			high = rand_range(60,80)
			print("Spring day: " + String(day))
		1: #summer
			low = rand_range(65,80)
			high = rand_range(80,100)
			print("Summer day: " + String(day))
		2: #fall
			low = rand_range(50,60)
			high = rand_range(60,70)
			print("Fall day: " + String(day))
		3: # winter
			low = rand_range(-10,10)
			high = rand_range(10,40)
			print("Winter day:" + String(day))
	print("Low: " + String(low))
	print("High: " + String(high))

func temperature_controller():
	if update_mid:
		if minutes == 0:
			if current_temperature >= 0:
				daily_change = (high - current_temperature) / (day_length/2) / 60
			else:
				daily_change = (high + abs(current_temperature)) / (day_length/2) / 60
		
		if minutes == day_length/2:
			if low >= 0:
				daily_change = -(current_temperature - low) / (day_length/2) / 60
			else:
				daily_change = -(current_temperature + abs(low)) / (day_length/2) / 60
		
		update_mid = false

func time_controller(var d):
	time+=d
	
	if time >= timed_seconds:
		time = 0
		seconds+=1
		current_temperature += daily_change
		print("Temp: " +String(current_temperature))
	if seconds >= timed_minutes:
		seconds = 0
		minutes+=1
		print(minutes)
	
	if minutes == day_length:
		day += 1
		minutes = 0
		if day <= season_length:
			gen_temp_ranges(season)
	
	if time == 0 && seconds == 0:
		if minutes == 0 || minutes == day_length/2:
			update_mid = true
	
	if day > season_length:
		day = 0
		season+=1
		if season == 4:
			season = 0
		gen_temp_ranges(season)
