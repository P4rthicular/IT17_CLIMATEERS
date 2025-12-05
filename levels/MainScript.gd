extends Control
# ------------------------------------------- #
# --------- CORE GAMEPLAY SECTION ----------- #
# ------------------------------------------- #
# Current Day Number
var day = 0

# Flags from projects are stored here which contributes to whether you win or not
var flags = []

# The resources used in the game
# Should be Randomized based on difficulty
var pollution = randi_range(30, 55)
var happiness = randi_range(20, 31)
var security = randi_range(20, 31)
var awareness = randi_range(20, 31)
var income = randi_range(4, 6)
# How much Income you should get every day
#This exists so the game can change how much Income you earn
# Should also be dependent on difficulty
var incomerate = randi_range(4, 6)

var disaster = null
var disastertime = 0 # How much turns you have until the disaster arrives
var disasterlist = [ # List of available disasters, will add more soon
	"earthquake",
	"supertyphoon",
	"tsunami",
	"tornado",
	"flashflood"
]


# Test stuff to make sure the displaybox works
var dailytext = [
	"Test 1. YAY YIPPE WAHHOOO",
	"Test 2. WOAH WOWW WOOOOOO",
	"Test 3. YWOAOWOAWOAWOAWOAWO",
	"TEST 4. IT IS ALL CAPS.",
	"Test 5. Nuclear",
	"Test 6. long message to test the box. THE QUICK BROWN FUCK JUMPS OVER THE LAZY ROAD OMYGOD WHATOH
	 HOAWHO OWIHT AWIOBABJOJB OHIAWHIASHP PJO",
	"Test 7. WHat if I had alot of newlines
	like this\nor this
	did this work?
	\nlast try",
	"Test 8. You win. Just Kidding. Curse of Ra.\n𓂋𓄿𓎼𓉔 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲 𓂧𓇋𓅂 𓂧𓇋𓅂 𓂧𓇋𓅂 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲𓂋𓄿𓎼𓉔 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲 𓂧𓇋𓅂 𓂧𓇋𓅂 𓂧𓇋𓅂 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲𓂋𓄿𓎼𓉔 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲 𓂧𓇋𓅂 𓂧𓇋𓅂 𓂧𓇋𓅂 𓆑𓅲𓎢𓈎 𓇌𓅱𓅲",
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
	print ("day ", (day))
	$rsc_container/daylbl.text = "Day\n" + str(day)
	pollution += randi_range(-1, 4)
	if proj4lvl == 4:
		pollution -= 2
	happiness += randi_range(-2, 1)
	awareness += randi_range(-2, 1)
	resource_update()
	income += incomerate
	$rsc_container/incomelbl.text = "Income\n$" + str(income)
	disaster_roll()
	disastertime -= 1
	disasterend()
	if disastertime == 0:
		get_tree().change_scene_to_file("res://levels/endgame.tscn")
	$eventbox.text += "\n[Day " + str(day) + "]: " + dailytext.pick_random() + "\n" # This should have random text relating to the daily event how do I do this
	var eventchance = randi_range(1,2)
	if eventchance == 1:
		if day > 2:
			show_event()
		else:
			pass
	projhandler()
	inithandler()

func disasterend():
	if disastertime == 31:
		match disaster:
			"flashflood","supertyphoon","tsunami":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Reports have indicated that nearby bodies of water are moving erraticly. Those who live near the shores are advised to evacuate immediately."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"tornado","earthquake":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Reports have indicated of strong energy permeating around the land. All civillians near mountains or elevated terrain are advised to evacuate immediately."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
	elif disastertime == 21:
		match disaster:
			"tsunami","tornado","supertyphoon":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Governments predict that an incoming disaster will most likely travel into the mainland and make landfall at the nearby coast."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"flashflood","earthquake":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Geologists have shown proof of unexplainable shifts and traces of tectonic movement within the earth's crust. The Government warns of an immediate hazard of flooding should rain occur."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
	elif disastertime == 11:
		match disaster:
			"tsunami":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Scientists have pinpointed the anomalous findings towards a giant Tsunami. It's height has been recorded at twelve metres high. Urgent evacuation has been mandated."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"flashflood":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Scientists have pinpointed the anomalous findings towards a massive flood moving towards the town. A government order of evacuation has been sounded for your town."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"earthquake":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Scientists have pinpointed the anomalous findings towards a titanic fault line that runs right past your town. Two large military helicopters have been sent to rescue your town."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"supertyphoon":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Scientists have pinpointed the anomalous findings towards a huge supertyphoon quickly making it's way into your general direction. The Government orders your town to brace for impact and await evacuation."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"tornado":
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = "Scientists have pinpointed the anomalous findings towards a humongous tornado slowly moving towards your town. All citizens have been urged by the Government to evacuate as far away as possible."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
	elif disastertime == 4:
			$eventpnl.visible = true
			$eventpnl/eventtxt.text = "The Government quickly contacts your office and warns you they will be unable to reach your town for evacuation. They tell you to prepare as much as possible, pray, and be safe. They will arrive once the disaster has passed."
			$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
			await get_tree().create_timer(6.0).timeout
			$eventpnl.visible = false
	else:
		pass


func projhandler():
	if specialtimer > 0:
		specialtimer -= 1
		$eventbox.text += "\n[Day " + str(day) + "]: Current project finishes in " + str(specialtimer) + " days!"
	elif specialtimer == 0 and curspecial != null:
		$eventpnl/eventbtnok.disabled = false
		$eventpnl/eventbtn1.disabled = false
		$eventpnl/eventbtn2.disabled = false
		$eventpnl/eventbtn3.disabled = false
		match curspecial:
			"proj1":
				security += 8
				awareness += 2
				proj1lvl += 1
				if proj1lvl == 3:
					flags.append("EQ_RESIST")
				elif proj1lvl == 4:
					flags.append("EQ_RESIST_MAX")
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The current Project Town Infrastructure has been completed."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"proj2":
				security += 4
				happiness += 2
				proj2lvl += 1
				if proj2lvl == 3:
					flags.append("RAIN_RESIST_1")
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The current Project Canal System has been completed."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"proj3":
				security += 5
				proj3lvl += 1
				if proj3lvl == 3:
					flags.append("RAIN_RESIST_2")
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The current Project Reforestation Project has been completed."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"proj4":
				security += 7
				awareness += 2	
				proj4lvl += 1
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The current Project Garbage Management has been completed."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			"proj5":
				if proj5lvl == 3:
					security += 25
					flags.append("SHELTER")
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The current Project Emergency Shelter has been completed."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				curspecial = null
			_:
				pass
	else:
		print ("this isnt supposed to happen")

func inithandler():
	match specialinit:
		"init1":
			if initcount != 0:
				happiness += 4
				initcount -= 1
			else:
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Family Day Event has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
		"init2":
			if initcount == 0:
				happiness -= 6
				income += 13
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Tax Collection has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
			else:
				initcount -= 1
		"init3":
			if initcount == 0:
				happiness += 9
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Medical Drive has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
			else:
				initcount -= 1
		"init4":
			if initcount != 0:
				awareness += 2
				happiness += 2
				pollution -= 2
				initcount -= 1
			else:
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Garbage Recycling Competition has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
		"init6":
			if initcount != 0:
				awareness += 5
				initcount -= 1
			else:
				inittrained += 1
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Emergency Evacuation Drills has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
		"init7":
			if initcount == 0:
				awareness += 12
				inittrained += 1
				pollution -= 12
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Disaster Awareness Drive has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
			else:
				initcount -= 1
		"init8":
			if initcount == 0:
				security += 1
				inittrained += 1
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " The Ongoing Initiative Emergency Response Training has ended."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
				specialinit = null
			else:
				initcount -= 1




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
# --------- PANELS SECTION ----------- #
# ------------------------------------ #

var curspecial = null
var specialtimer = 0

# ------------ PROJECTS -------------- #
func _show_projects() -> void:
	$projectpnl.visible = !$projectpnl.visible
	$projectpnl/ColorRect/HBoxContainer/proj1.text = "Level\n" + str(proj1lvl)
	$projectpnl/ColorRect/HBoxContainer/proj2.text = "Level\n" + str(proj2lvl)
	$projectpnl/ColorRect/HBoxContainer/proj3.text = "Level\n" + str(proj3lvl)
	$projectpnl/ColorRect/HBoxContainer/proj4.text = "Level\n" + str(proj4lvl)
	$projectpnl/ColorRect/HBoxContainer/proj5.text = "Level\n" + str(proj5lvl)
	if specialtimer > 0:
		$projectpnl/ColorRect/projbuy.visible = false
	else:
		$projectpnl/ColorRect/projbuy.visible = true
	
func _close_projects() -> void:
	$projectpnl.visible = !$projectpnl.visible

var proj1lvl = 0
var proj2lvl = 0
var proj3lvl = 0
var proj4lvl = 0
var proj5lvl = 0

var projcostup = 10

var proj1cost = 20
var proj2cost= 20
var proj3cost= 20
var proj4cost = 20
var proj5cost = 30

var currentproj = 0

var curproj = null
func _proj1():
	currentproj = 1
	$projectpnl/ColorRect/projectname.text = "Town Infrastructure - Level " + str(proj1lvl) + "/4 - Cost: $" + str(proj1cost)
	$projectpnl/ColorRect/projectdesc.text = "Upgrade the structural integrity of crucial community buildings, houses, and roads. Higher levels make buildings resilient to earthquakes.\n\nIncreases SECURITY, as well as small amounts of AWARENESS. Takes eight days to accomplish."
	if income < proj1cost or proj1lvl == 4:
		$projectpnl/ColorRect/projbuy.disabled = true
	else: 
		$projectpnl/ColorRect/projbuy.disabled = false

func _proj2():
	currentproj = 2
	$projectpnl/ColorRect/projectname.text = "Canal System - Level " + str(proj2lvl) + "/4 - Cost: $" + str(proj2cost)
	$projectpnl/ColorRect/projectdesc.text = "Apply work on the town's canals and sewer systems to ensure proper water movement throughout the town. Higher levels can prevent floods.\n\nSlightly increases SECURITY. Mostly helps on rain events. Takes six days to accomplish."
	if income < proj2cost or proj1lvl == 4:
		$projectpnl/ColorRect/projbuy.disabled = true
	else: 
		$projectpnl/ColorRect/projbuy.disabled = false

func _proj3():
	currentproj = 3
	$projectpnl/ColorRect/projectname.text = "Reforestation Project - Level " + str(proj3lvl) + "/4 - Cost: $" + str(proj3cost)
	$projectpnl/ColorRect/projectdesc.text = "Replant trees in the immediate surroundings of the town, replacing stumps and fallen trees with young, growing ones. Higher levels prevent some negative events. Becomes very flammable at higher levels.\n\nIncreases SECURITY. Takes five days to accomplish."
	if income < proj3cost or proj1lvl == 4:
		$projectpnl/ColorRect/projbuy.disabled = true
	else: 
		$projectpnl/ColorRect/projbuy.disabled = false

func _proj4():
	currentproj = 4
	$projectpnl/ColorRect/projectname.text = "Garbage Management - Level " + str(proj4lvl) + "/4 - Cost: $" + str(proj4cost)
	$projectpnl/ColorRect/projectdesc.text = "Maintain the flow of trash in the town and either dispose of what cannot be salvaged, or create anything new with the spare materials. Reduces pollution daily at maximum level.\n\nSlightly increases SECURITY and increases AWARENESS. Takes seven days to accomplish"
	if income < proj4cost or proj1lvl == 4:
		$projectpnl/ColorRect/projbuy.disabled = true
	else: 
		$projectpnl/ColorRect/projbuy.disabled = false

func _proj5():
	currentproj = 5
	$projectpnl/ColorRect/projectname.text = "Emergency Shelter - Level " + str(proj5lvl) + "/3 - Cost: $" + str(proj5cost)
	$projectpnl/ColorRect/projectdesc.text = "Build and upgrade an Emergency Evacuation Shelter for your community should the need ever arises. Only takes effect in it's maximum level.\n\nIncreases SECUIRTY, and is required for more intense natural disasters. Takes nine days to complete"
	if income < proj5cost or proj1lvl == 3:
		$projectpnl/ColorRect/projbuy.disabled = true
	else: 
		$projectpnl/ColorRect/projbuy.disabled = false

func _projbuy():
	match currentproj:
		1:
			income -= proj1cost
			specialtimer += 8
			curspecial = "proj1"
			if proj1lvl >= 3:
				proj1cost = proj1cost + (proj1cost * 0.2) + projcostup
			else:
				proj1cost = proj1cost + projcostup
			$eventbox.text += "\n[Day " + str(day) + "]: Bought project " + str($projectpnl/ColorRect/Label2.text) + " which is under construction for " + str(specialtimer) + " days."
		2:
			income -= proj2cost
			specialtimer += 6
			curspecial = "proj2"
			if proj2lvl >= 3:
				proj2cost = proj2cost + (proj2cost * 0.2) + projcostup
			else:
				proj2cost = proj2cost + projcostup
			$eventbox.text += "\n[Day " + str(day) + "]: Bought project " + str($projectpnl/ColorRect/Label3.text) + " which is under construction for " + str(specialtimer) + " days."
		3:
			income -= proj1cost
			specialtimer += 5
			curspecial = "proj3"
			if proj1lvl >= 3:
				proj1cost = proj1cost + (proj1cost * 0.2) + projcostup
			else:
				proj1cost = proj1cost + projcostup
			$eventbox.text += "\n[Day " + str(day) + "]: Bought project " + str($projectpnl/ColorRect/Label4.text) + " which is under construction for " + str(specialtimer) + " days."
		4:
			income -= proj1cost
			specialtimer += 7
			curspecial = "proj4"
			if proj1lvl >= 3:
				proj1cost = proj1cost + (proj1cost * 0.2) + projcostup
			else:
				proj1cost = proj1cost + projcostup
			$eventbox.text += "\n[Day " + str(day) + "]: Bought project " + str($projectpnl/ColorRect/Label5.text) + " which is under construction for " + str(specialtimer) + " days."
		5:
			income -= proj1cost
			specialtimer += 9
			curspecial = "proj5"
			if proj1lvl >= 2:
				proj1cost = proj1cost + (proj1cost * 0.2) + projcostup
			else:
				proj1cost = proj1cost + projcostup
			$eventbox.text += "\n[Day " + str(day) + "]: Bought project " + str($projectpnl/ColorRect/Label6.text) + " which is under construction for " + str(specialtimer) + " days."
	resource_update()
	$projectpnl.visible = false

# ---------- INITIATIVES ------------- #
func _show_initiatives() -> void:
	$initiativepnl.visible = !$initiativepnl.visible
	if income < initbasecost or initcount != 0:
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init1.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init2.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init3.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init4.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init5.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init6.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init7.disabled = true
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init8.disabled = true
		$initiativepnl/ColorRect/initbuy.disabled = true
	else:
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init1.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init2.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init3.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer2/init4.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init5.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init6.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init7.disabled = false
		$initiativepnl/ColorRect/VBoxContainer/HBoxContainer3/init8.disabled = false
		$initiativepnl/ColorRect/initbuy.disabled = false
		

var initbasecost = 15
var initmarkup = 0
var currentinit = 0

var initcount = 0
var specialinit = null

var init7done = false
var inittrained = 0

func _init1():
	currentinit = 1
	$initiativepnl/ColorRect/initiativename.text = "Family Day Event - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Run a Family Day event for the townspeople, complete with food, prizes, and entertainment. Increases HAPPINESS for 3 days."

func _init2():
	currentinit = 2
	$initiativepnl/ColorRect/initiativename.text = "Tax Collection - Cost: Free"
	$initiativepnl/ColorRect/initiativedesc.text = "Collect taxes from the community. No one likes paying, but it's all for a better cause. Generates INCOME after 2 days, much to the people's annoyance."

func _init3():
	currentinit = 3
	$initiativepnl/ColorRect/initiativename.text = "Medical Assistance Drive - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Start a Medical Drive in your town, offering free check-ups, diagnosis, and other treatments. Boosts AWARENESS and HAPPINESS after 2 days."

func _init4():
	currentinit = 4
	$initiativepnl/ColorRect/initiativename.text = "Garbage Recycling Competition - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Host an Art competition where participants must use recycled materials. Inspire creativity amongst your compatriots and solve your garbage problem at the same time. Boosts AWARENESS, HAPPINESS, and reduces POLLUTION after 4 days."

func _init5():
	currentinit = 5
	$initiativepnl/ColorRect/initiativename.text = "Voluntary Cleaning Drive - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Gather volunteers to help clean the streets of the town. Reduces POLLUTION after 2 days."

func _init6():
	currentinit = 6
	$initiativepnl/ColorRect/initiativename.text = "Emergency Evacuation Drills - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Simulate a disaster evacuation routine throughout the town. Increases AWARENESS and TRAINS your fellows. Takes 1 whole day."

func _init7():
	currentinit = 7
	$initiativepnl/ColorRect/initiativename.text = "Disaster Awareness Drive - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Give seminars about disaster preparedness towards the local community and ready them for whatever disaster may come. Greatly Boosts AWARENESS, reduces POLLUTION, and TRAINS the townspeople after 1 day. CAN ONLY BE DONE ONCE."
	if init7done:
		$initiativepnl/ColorRect/initbuy.disabled = true

func _init8():
	currentinit = 8
	$initiativepnl/ColorRect/initiativename.text = "Emergency Response Training - Cost: " + str(initbasecost)
	$initiativepnl/ColorRect/initiativedesc.text = "Execute an Emergency Response Drill to gauge the readyness of the people. Raises SECURITY and TRAINS them after 3 days."


func _initbuy():
	match currentinit:
		1:
			income -= initbasecost
			initcount += 3
			initbasecost += initmarkup
			specialinit = "init1"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Family Day which is ongoing " + str(initcount) + " day(s)."
		2:
			income -= initbasecost
			initcount += 2
			initbasecost += initmarkup
			specialinit = "init2"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Tax Collection which is ongoing " + str(initcount) + " day(s)."
		
		3:
			income -= initbasecost
			initcount += 2
			initbasecost += initmarkup
			specialinit = "init3"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Medical Drive which is ongoing " + str(initcount) + " day(s)."
		
		4:
			income -= initbasecost
			initcount += 4
			initbasecost += initmarkup
			specialinit = "init4"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Garbage Recycling Competition which is ongoing " + str(initcount) + " day(s)."
		
		5:
			income -= initbasecost
			initcount += 2
			initbasecost += initmarkup
			specialinit = "init5"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Cleaning Drive which is ongoing " + str(initcount) + " day(s)."
		
		6:
			income -= initbasecost
			initcount += 1
			initbasecost += initmarkup
			specialinit = "init6"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Emergency Evacuation Drills which is ongoing " + str(initcount) + " day(s)."
		
		7:
			income -= initbasecost
			initcount += 1
			initbasecost += initmarkup
			specialinit = "init7"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Disaster Awareness Drive which is ongoing " + str(initcount) + " day(s)."
			init7done = true
		8:
			income -= initbasecost
			initcount += 3
			initbasecost += initmarkup
			specialinit = "init8"
			$eventbox.text += "\n[Day " + str(day) + "]: Started Initiative Emergency Response Training which is ongoing " + str(initcount) + " day(s)."
		_:
			$initiativepnl/ColorRect/initiativedesc.text += "An error has occurred."
	resource_update()
	$initiativepnl.visible = false

func _close_initiatives() -> void:
	$initiativepnl.visible = !$initiativepnl.visible

# ------------------------------------ #
# --------- EVENTS SECTION ----------- #
# ------------------------------------ #

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
				disastertime += randi_range(41, 61) # Determines how many turns before the disaster appears
				print ("disaster deadline is ", disastertime, " turns")
				$eventpnl.visible = true
				$eventpnl/eventtxt.text = " A report has come in that a disaster is approaching. The Goverment issues warningss to stay vigilant and prepare for what's to come. It has been estimated that the disaster will arive in " + str(disastertime) + " days."
				$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
				await get_tree().create_timer(6.0).timeout
				$eventpnl.visible = false
			else:
				pass
	else:
		print ("disaster already found")
		pass


# ---------------------------------------- #
# --------- DAILY RANDOM EVENT ----------- #
# ---------------------------------------- #


var eventop1 = false
var eventop2 = false
var eventop3 = false

var cur_event = "none"

var rndeventlist = [
	"greatday",
	"rain",
	"toosunny",
	"cleaning",
	"traffic",
	"suddenflood",
	"litter",
	"trash",
	"vandalism",
	"escapees"
]

func show_event():
	$btn_mcontainer/HBoxContainer/projectsbtn.disabled = true
	$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = true
	$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = true
	$eventpnl.visible = !$eventpnl.visible
	$eventpnl/eventbtnok.disabled = true
	print ("panel shown")
	$eventpnl/eventbtn1.disabled = false
	$eventpnl/eventbtn2.disabled = false
	$eventpnl/eventbtn3.disabled = false
	cur_event = rndeventlist.pick_random()
	match cur_event:
		"greatday":
			$eventpnl/eventtxt.text = "It's a beautiful day outside. Not a single thing going wrong within the neighbourhood. It's not usual for quiet times like these, so you decide to make the most of it.\nHow should you take advantage of this day?"
			$eventpnl/eventbtn1.text = "Patrol Area"
			$eventpnl/eventbtn2.text = "Clean Trash"
			$eventpnl/eventbtn3.text = "Hang Out"
		"toosunny":
			$eventpnl/eventtxt.text = "The sun beams down the town with not a cloud in sight. It is a little too hot. Now it is very hot.\nYou need to do something about this."
			if income < 16:
				$eventpnl/eventtxt.text += "\n\nYou do not have enough income to install parasols."
				$eventpnl/eventbtn1.disabled = true
				$eventpnl/eventbtn1.text = ""
			else:
				$eventpnl/eventbtn1.text = "Install Parasols"
			$eventpnl/eventbtn2.text = "Suspend Work"
			$eventpnl/eventbtn3.text = "Spray Water"
		"cleaning":
			$eventpnl/eventtxt.text = "It is a peaceful day outside. With nothing going on, you decide cleaning up the town would be a good idea."
			$eventpnl/eventbtn1.text = "Clean Streets"
			$eventpnl/eventbtn2.text = "Repair Buildings"
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn3.disabled = true
		"traffic":
			$eventpnl/eventtxt.text = "More and more cars are entering your town, causing road congestion and polluting the air. This day is especially bad. You have to do something."
			$eventpnl/eventbtn1.text = "Toll Booths"
			$eventpnl/eventbtn2.text = "Restrict Entry"
			$eventpnl/eventbtn3.text = "Discourage Driving"
		"suddenflood":
			$eventpnl/eventtxt.text = "After some light rain, the water doesn't seem to fade, as a small flood lays over the town. You have to get rid of it."
			$eventpnl/eventbtn1.text = "Check Drains"
			$eventpnl/eventbtn2.text = "Dig Channel"
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn3.disabled = true
		"litter":
			$eventpnl/eventtxt.text = "You spot a group of students tossing plastic and organic trash along their way."
			$eventpnl/eventbtn1.text = "Scold them"
			$eventpnl/eventbtn2.text = "Call a cleaner"
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn3.disabled = true
		"trash":
			$eventpnl/eventtxt.text = "You patrol the town and find a large pile of trash. You call on a few volunteers to help you clean it up, but the trash inside made you all sick just by smelling it. You and the volunteers can't handle the stench and are forced to wait until a truck can come pick it up."
			happiness -= 7
			pollution -= 16
			$eventpnl/eventbtn1.text = ""
			$eventpnl/eventbtn2.text = ""
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn1.disabled = true
			$eventpnl/eventbtn2.disabled = true
			$eventpnl/eventbtn3.disabled = true
			$eventpnl/eventbtnok.disabled = true
			resource_update()
			$eventpnl/eventtxt.text += "\n\nThis window will close in 5 seconds."
			await get_tree().create_timer(5.0).timeout
			$eventpnl.visible = !$eventpnl.visible
			$btn_mcontainer/HBoxContainer/projectsbtn.disabled = !$btn_mcontainer/HBoxContainer/projectsbtn.disabled
			$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = !$btn_mcontainer/HBoxContainer/initiativesbtn.disabled
			$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = !$btn_mcontainer/HBoxContainer/nextdaybtn.disabled
		"vandalism":
			$eventpnl/eventtxt.text = "Some community members come to you about having trash thrown at their houses at night while they were asleep. You come to check their houses and find garbage and graffiti splattered on their fences and doors. Cleaning takes a very long time and the smell lingers for awhile."
			happiness -= 9
			pollution -= 10
			security -= 4
			$eventpnl/eventbtn1.text = ""
			$eventpnl/eventbtn2.text = ""
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn1.disabled = true
			$eventpnl/eventbtn2.disabled = true
			$eventpnl/eventbtn3.disabled = true
			$eventpnl/eventbtnok.disabled = true
			resource_update()
			$eventpnl/eventtxt.text += "\n\nThis window will close in 5 seconds."
			await get_tree().create_timer(5.0).timeout
			$eventpnl.visible = !$eventpnl.visible
			$btn_mcontainer/HBoxContainer/projectsbtn.disabled = !$btn_mcontainer/HBoxContainer/projectsbtn.disabled
			$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = !$btn_mcontainer/HBoxContainer/initiativesbtn.disabled
			$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = !$btn_mcontainer/HBoxContainer/nextdaybtn.disabled
		"escapees":
			$eventpnl/eventtxt.text = "You catch some townsfolk eating out and leaving alot off mess and garbage. When you ask them to clean it up, they say they're going to go to fetch their cleaning tools, but they never return."
			awareness -= 8
			pollution -= 15
			$eventpnl/eventbtn1.text = ""
			$eventpnl/eventbtn2.text = ""
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn1.disabled = true
			$eventpnl/eventbtn2.disabled = true
			$eventpnl/eventbtn3.disabled = true
			$eventpnl/eventbtnok.disabled = true
			resource_update()
			$eventpnl/eventtxt.text += "\n\nThis window will close in 5 seconds."
			await get_tree().create_timer(5.0).timeout
			$eventpnl.visible = !$eventpnl.visible
			$btn_mcontainer/HBoxContainer/projectsbtn.disabled = !$btn_mcontainer/HBoxContainer/projectsbtn.disabled
			$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = !$btn_mcontainer/HBoxContainer/initiativesbtn.disabled
			$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = !$btn_mcontainer/HBoxContainer/nextdaybtn.disabled
		"rain":
			$eventpnl/eventtxt.text = "You are warned of incoming light rain tomorrow by the news, but when the rain comes it is stronger than anticipated. The rain pours so hard it might start to flood soon."
			$eventpnl/eventbtn1.text = "Issue warning"
			$eventpnl/eventbtn2.text = "Clear sewers"
			$eventpnl/eventbtn3.text = ""
			$eventpnl/eventbtn3.disabled = true
		_:
			$eventpnl/eventtxt.text = "This is an Error. You should not be seeing this."
			$eventpnl/eventbtn1.disabled = true
			$eventpnl/eventbtn2.disabled = true
			$eventpnl/eventbtn3.disabled = true
			$eventpnl/eventbtnok.disabled = true
			resource_update()
			$eventpnl/eventtxt.text += "\n\nThis window will close in 5 seconds."
			await get_tree().create_timer(5.0).timeout
			$eventpnl.visible = !$eventpnl.visible
			$btn_mcontainer/HBoxContainer/projectsbtn.disabled = !$btn_mcontainer/HBoxContainer/projectsbtn.disabled
			$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = !$btn_mcontainer/HBoxContainer/initiativesbtn.disabled
			$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = !$btn_mcontainer/HBoxContainer/nextdaybtn.disabled



func runevent():
	match cur_event:
		"greatday":
			if eventop1:
				$eventpnl/eventtxt.text = "You went for a patrol around the area, easing the worries of the people."
				security += 3
				happiness += 3
			elif eventop2:
				$eventpnl/eventtxt.text = "You decide to gather some folks and help clean the surrounding trash."
				pollution -= 4
				happiness += 3
			elif eventop3:
				$eventpnl/eventtxt.text = "You hang around with other community members, sharing some insight."
				awareness += 3
				happiness =+ 3
		"rain":
			if eventop1:
				$eventpnl/eventtxt.text = "You issue a rainfall warning which the people receive. Most of the community quickly duck into their houses."
				security += 2
				awareness += 2
			elif eventop2:
				$eventpnl/eventtxt.text = "You put on a raincoat and decide to clear the sewer channels and let the rainwater flow through. Your exposure to the rain gets you sick."
				pollution -= 5
				happiness -= 2
		"toosunny":
			if eventop1:
				$eventpnl/eventtxt.text = "You install Parasols for people to take shade under."
				happiness += 3
				security += 3
				income -= 16
			elif eventop2:
				$eventpnl/eventtxt.text = "You give the order to suspend all classes and work for the day, urging evereyone to chill at home."
				awareness += 3
			elif eventop3:
				$eventpnl/eventtxt.text = "You ask everyone to wet each other with water. It was very fun, but left alot of mess behind."
				pollution += 5
				happiness =+ 6
		"cleaning":
			if eventop1:
				$eventpnl/eventtxt.text = "You take some volunteers and clean garbage and leaves off the streets."
				pollution -= 7
			elif eventop2:
				$eventpnl/eventtxt.text = "You grab some workers and get to inspecting the town's infrastructure."
				security += 5
		"traffic":
			if eventop1:
				$eventpnl/eventtxt.text = "You set up toll booths to deter cars as well as earn income from the chaos."
				pollution += 6
				income += 13
				security += 2
				happiness -= 5
			elif eventop2:
				$eventpnl/eventtxt.text = "You limit what vehicles can enter your town temporarily."
				security += 4
				happiness -= 7
				pollution -= 3
			elif eventop3:
				$eventpnl/eventtxt.text = "You try and discourage townsfolk from using their cars all the time, asking them to walk, jog, or bike instead."
				awareness += 2
				happiness += 2
		"suddenflood":
			if eventop1:
				$eventpnl/eventtxt.text = "You and a few helpers try to remove any jams on the drains. Some of you get sick swimming in the flood."
				happiness -= 3
				security += 4
				pollution -= 2
			elif eventop2:
				$eventpnl/eventtxt.text = "You get some help and dig channels to have the trapped flood flow away from the town. The process is time consuming."
				security += 4
				awareness -= 2
				happiness -= 2
		"litter":
			if eventop1:
				$eventpnl/eventtxt.text = "You approach the students and scold them for littering in the streets. AFter they apologize, you ask them to pick up their trash and show them to dispose it properly."
				happiness -= 2
				awareness += 4
			elif eventop2:
				$eventpnl/eventtxt.text = "You call on a volunteer cleaners to make the students clean their trash. They take awhile to find the right trash can."
				pollution -= 3
		_:
			$eventpnl/eventtxt.text += "This is an Error. You should not be seeing this."
			
	$eventpnl/eventbtn1.disabled = true
	$eventpnl/eventbtn2.disabled = true
	$eventpnl/eventbtn3.disabled = true
	$eventpnl/eventbtnok.disabled = true
	resource_update()
	$eventpnl/eventtxt.text += "\n\nThis window will close in 6 seconds."
	await get_tree().create_timer(6.0).timeout
	$eventpnl.visible = !$eventpnl.visible
	$btn_mcontainer/HBoxContainer/projectsbtn.disabled = false
	$btn_mcontainer/HBoxContainer/initiativesbtn.disabled = false
	$btn_mcontainer/HBoxContainer/nextdaybtn.disabled = false
	
# This function handles the Event Panel, displaying events and choices.
func _eventop1_select() -> void:
	eventop1 = true
	eventop2 = false
	eventop3 = false
	$eventpnl/eventbtn1.disabled = true
	$eventpnl/eventbtn2.disabled = false
	$eventpnl/eventbtn3.disabled = false
	$eventpnl/eventbtnok.disabled = false
	
func _eventop2_select() -> void:
	eventop1 = false
	eventop2 = true
	eventop3 = false
	$eventpnl/eventbtn1.disabled = false
	$eventpnl/eventbtn2.disabled = true
	$eventpnl/eventbtn3.disabled = false
	$eventpnl/eventbtnok.disabled = false

func _eventop3_select() -> void:
	eventop1 = false
	eventop2 = false
	eventop3 = true
	$eventpnl/eventbtn1.disabled = false
	$eventpnl/eventbtn2.disabled = false
	$eventpnl/eventbtn3.disabled = true
	$eventpnl/eventbtnok.disabled = false
	
func _confirmevent() -> void:
	runevent()
