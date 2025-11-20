extends Control
# ------------------------------------------- #
# --------- CORE GAMEPLAY SECTION ----------- #
# ------------------------------------------- #
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

# Test stuff to make sure the displaybox works
var dailytext = [
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
	randomize()
	NewDay()


func NewDay():
	# This runs everytime a new day is generated, either by ending turn or starting a new game
	day += 1
	print (day)
	$rsc_container/daylbl.text = "Day\n" + str(day)
	resource_update()
	income += incomerate
	$rsc_container/incomelbl.text = "Income\n$" + str(income)
	disaster_roll()
	disastertime -= 1
	$eventbox.text += "\n[Day " + str(day) + "]: " + dailytext.pick_random() + "\n" # This should have random text relating to the daily event how do I do this
	$eventbtn.disabled = false
	

func resource_update():
	# This updates the player's resource stats
	
	# Updates the resource labels
	$rsc_container/pollutionlbl.text = "Pollution\n" + str(pollution)
	$rsc_container/happinesslbl.text = "Happiness\n" + str(happiness)
	$rsc_container/securitylbl.text = "Security\n" + str(security)
	$rsc_container/awarenesslbl.text = "Awareness\n" + str(awareness)
	$rsc_container/incomelbl.text = "Income\n$" + str(income)


func quit_to_menu() -> void:
	# Exits to main menu
	# NEEDS A CONFIRMATION
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func nextday_pressed() -> void:
	# NEEDS CONFIRMATION
	# This one generates the next day
	NewDay()

# ------------------------------------ #
# --------- EVENTS SECTION ----------- #
# ------------------------------------ #

# Dedicded to try keeping all the everything in one script hope it works well
# Events section where the game decides what disaster

# This identifies what disaster is going to happen
var disaster = null
var disastertime = 0 # How much turns you have until the disaster arrives
var disasterlist = [ # List of available disasters, will add more soon
	"earthquake",
	"supertyphoon",
	"tsunami",
	"tornado",
	"flashflood"
]

# This function chooses which disaster will happen on your game
func disaster_roll() -> void:
	print ("disaster roll check")
	if disaster == null: # First checks if you already have a disaster
		print ("disaster null check")
		if day < 5 and day > 1 or day == 5: # Second checks what day it is to make sure disaster is chosen on or before day 5
			print ("disaster day check")
			var disasterchance = randf()
			if disasterchance >= 0.33: # 33 percent chance on day 2 to 4 for the disaster to be chosen
				disaster = disasterlist.pick_random()
				print (disaster)
				$rsc_container/disasterlbl.text = "Current Disaster\n" + str(disaster) # This should be hidden from the player and events will reveal what disaster it is
				print ("current disaster chosen as ", disaster)
				disastertime += randi_range(34, 52) # Determines how many turns before the disaster appears
				print ("disaster deadline is ", disastertime, " turns")
			else:
				pass
	else:
		print ("disaster already found")
		pass

# This is for testing purposes this should be removed when gameplay loop is complete
func eventbtn_pressed() -> void:
	if income >= 4:
		income -= 4
		var eventchance = randf()
		if eventchance <= 0.60:
			$eventbox.text += "\n[Day " + str(day) + "]: Negative event. Lose stats. I dislike you. Money left: " + str(income) + "\n"
		
			pollution += randi() % 6
			happiness -= randi() % 6
			security -= randi() % 6
			awareness -= randi() % 6
			resource_update()
		else:
			$eventbox.text += "\n[Day " + str(day) + "]: Positive event! Gain Stats! I love you! Money left: " + str(income) + "\n"
		
			pollution -= randi() % 8
			happiness += randi() % 8
			security += randi() % 8
			awareness += randi() % 8
			resource_update()
	else:
		$eventbox.text += "\n[Day " + str(day) + "]: No money. Poor. Go get more money." + "\n"
	$eventbtn.disabled = true


# ------------------------------------ #
# --------- PANELS SECTION ----------- #
# ------------------------------------ #


# ------------ PROJECTS -------------- #
func _show_projects() -> void:
	$projectpnl.visible = !$projectpnl.visible
	
func _close_projects() -> void:
	$projectpnl.visible = !$projectpnl.visible

# ---------- INITIATIVES ------------- #
func _show_initiatives() -> void:
	$initiativepnl.visible = !$initiativepnl.visible

func _close_initiatives() -> void:
	$initiativepnl.visible = !$initiativepnl.visible
