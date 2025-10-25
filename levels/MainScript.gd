extends Control

# Current Day Number
var day = 0

# The resources used in the game
# Should be Randomized based on difficulty
var pollution = 20
var happiness = 20
var security = 20
var awareness = 20
var income = 0

# How much Income you should get every day
#This exists so the game can change how much Income you earn
# Should also be dependent on difficulty
var incomerate = 3

# Connect the resource labels so they can be rewritten
# Expect alot of these I am going to stick with this one method
@export var resc1: Label
@export var resc2: Label
@export var resc3: Label
@export var resc4: Label

# List of stuff that should be displayed in the event box
var eventtext = [
	"Test 1. YAY YIPPE WAHHOOO",
	"Test 2. WOAH WOWW WOOOOOO",
	"Test 3. YWOAOWOAWOAWOAWOAWO",
	"TEST 4. IT IS ALL CAPS.",
	"Test 5. Display resources(?)" + str(pollution) + str(happiness) + str(security) + str(awareness),
	"Test 6. long message to test the box. THE QUICK BROWN FUCK JUMPS OVER THE LAZY ROAD OMYGOD WHATOH
	 HOAWHO OWIHT AWIOBABJOJB OHIAWHIASHP PJO",
	"Test 7. WHat if I had alot of newlines
	like this
	or this
	did this work?
	\nlast try",
	"Test 8. You win. Just Kidding. Curse of Ra.\n𓂋𓄿𓎼𓉔 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲 𓂧𓇋𓅂 𓂧𓇋𓅂 𓂧𓇋𓅂 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲",
	"Test 9.",
	"Test 10. abcdefghijklmnopqrstuvwxyz 1234567890"
	]
	
# Anything in here is run as soon as the game loads
# Needs to detect what level or difficulty is chosen
func _ready():
	NewDay()

func NewDay():
	# This runs everytime a new day is generated, either by ending turn or starting a new game
	day += 1
	print (day)
	$daylbl.text = "Day " + str(day)
	resource_update()
	$incomelbl.text = "Income: $" + str(income)
	$eventbox.text += "\n[Day " + str(day) + "]: " + eventtext.pick_random() + "\n" # This should have random text relating to the daily event how do I do this
	$eventbtn.disabled = false
	

func resource_update():
	# This updates the player's resource stats
	# Sets resource to 0 if it's a negative integer
	# Maybe theres a better way idk for now
	if awareness < 0:
		awareness = 0
	if happiness < 0:
		happiness = 0
	if security < 0:
		security = 0
	if pollution > 100:
		pollution = 100
	# For some reason this is the only working solution
	resc1.text = "Pollution: " + str(pollution)
	resc2.text = "Happiness: " + str(happiness)
	resc3.text = "Security: " + str(security)
	resc4.text = "Awareness: " + str(awareness)
	income += incomerate # THIS DOESNT WORK FOR NOW WHY


func quit_to_menu() -> void:
	# Exits to main menu
	# NEEDS A CONFIRMATION
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func nextday_pressed() -> void:
	# NEEDS CONFIRMATION
	# This one generates the next day
	NewDay()
	


func eventbtn_pressed() -> void:
	if income >= 4:
		var eventchance = randf()
		if eventchance <= 0.75:
			$eventbox.text += "\n[Day " + str(day) + "]: Negative event. Lose stats. I dislike you. Money left: " + str(income) + "\n"
		
			pollution += randi() % 6
			happiness -= randi() % 6
			security -= randi() % 6
			awareness -= randi() % 6
			income -= 4
			resource_update()
		else:
			$eventbox.text += "\n[Day " + str(day) + "]: Positive event! Gain Stats! I love you! Money left: " + str(income) + "\n"
		
			pollution -= randi() % 5
			happiness += randi() % 5
			security += randi() % 5
			awareness += randi() % 5
			income -= 4
			resource_update()
	else:
		$eventbox.text += "\n[Day " + str(day) + "]: No money. Poor. Go get more money." + "\n"
	$eventbtn.disabled = true
	
		
