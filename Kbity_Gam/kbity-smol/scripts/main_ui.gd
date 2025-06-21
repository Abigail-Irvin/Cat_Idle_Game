extends Control
@export var kbity_ref: MenuButton
@export var bed_ref: MenuButton
@export var food_ref: MenuButton
@export var toy_ref: MenuButton
@export var litter_ref: MenuButton
@export var happy_bar: RichTextLabel
@export var hungi_bar: RichTextLabel
@export var energy_bar: RichTextLabel
@export var kbity_bux_bar: RichTextLabel

@export var toy_img_list: Array
@export var bed_img_list: Array
@export var food_img_list: Array
@export var litter_img_list: Array
@export var toy_desc_list: Array
@export var bed_desc_list: Array
@export var food_desc_list: Array
@export var litter_desc_list: Array
@export var toy_cost_list: Array
@export var bed_cost_list: Array
@export var food_cost_list: Array
@export var litter_cost_list: Array
@export var max_level: int

@export var kbity_awake_img: String
@export var kbity_eepy_img: String

@export var console: RichTextLabel

var pet_cooldown = 5
var treat_cooldown = 15
var play_cooldown = 10
var brush_cooldown = 10

var eating_cooldown = 10
var eat_timer = 0
var is_eat = false
var mood_cooldown = 25
var mood_timer = 0
var is_mood = false

var is_eepy = false
var eepy_cooldown = 10
var eepy_timer = 0

var sleep_scaling_factor = 2
var eating_scaling_factor = 2
var hungi_gain_factor = 0.25
var eepy_gain_factor = 0.25
var sad_gain_factor = 0.25

var eating_timer = 0
var magic_number = 3.75

enum {PET_KBITY, TREAT_KBITY, PLAY_KBITY, BRUSH_KBITY}
enum {DETAILS, UPGRADE} 
enum {KBITY, TOY, BED, FOOD, LITTER}

class ItemData:
	var level: int
	var desc: String
	var cost: int
	var image: String
	func _init(level: int, desc: String, cost: int, image: String) -> void:
		self.level = level
		self.desc = desc
		self.cost = cost
		self.image = image

var bed_dict = {}
var food_dict = {}
var toy_dict = {}
var litter_dict = {}

func _ready() -> void:
	kbity_ref.popup_menu_selection.connect(self._process_input)
	bed_ref.popup_menu_selection.connect(self._process_input)
	food_ref.popup_menu_selection.connect(self._process_input)
	toy_ref.popup_menu_selection.connect(self._process_input)
	litter_ref.popup_menu_selection.connect(self._process_input)
	for i in range(max_level):
		bed_dict[i] = ItemData.new(i, bed_desc_list[i], bed_cost_list[i], bed_img_list[i])
		food_dict[i] = ItemData.new(i, food_desc_list[i], food_cost_list[i], food_img_list[i])
		litter_dict[i] = ItemData.new(i, litter_desc_list[i], litter_cost_list[i], litter_img_list[i])
		toy_dict[i] = ItemData.new(i, toy_desc_list[i], toy_cost_list[i], toy_img_list[i])
	update_icons()
	
func _process(delta: float) -> void:
	if GlobalData.paused:
		return
	# pet interaction timers
	if GlobalData.is_pet:
		GlobalData.pet_timer += delta
		if GlobalData.pet_timer >= pet_cooldown:
			GlobalData.pet_timer = 0
			GlobalData.is_pet = false
		kbity_ref.get_popup().set_item_text(0, "Pet: Cooldown(" + str(round(pet_cooldown - GlobalData.pet_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(0, "Pet")
	if GlobalData.is_treated:
		GlobalData.treat_timer += delta
		if GlobalData.treat_timer >= treat_cooldown:
			GlobalData.treat_timer = 0
			GlobalData.is_treated = false
		kbity_ref.get_popup().set_item_text(1, "Treat: Cooldown(" + str(round(treat_cooldown - GlobalData.treat_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(1, "Treat")
	if GlobalData.is_played:
		GlobalData.play_timer += delta
		if GlobalData.play_timer >= play_cooldown:
			GlobalData.play_timer = 0
			GlobalData.is_played = false
		kbity_ref.get_popup().set_item_text(2, "Play: Cooldown(" + str(round(play_cooldown - GlobalData.play_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(2, "Play")
	if GlobalData.is_brushed:
		GlobalData.brush_timer += delta
		if GlobalData.brush_timer >= brush_cooldown:
			GlobalData.brush_timer = 0
			GlobalData.is_brushed = false
		kbity_ref.get_popup().set_item_text(3, "Brush: Cooldown(" + str(round(brush_cooldown - GlobalData.brush_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(3, "Brush")
		
	# normal cat activities
	if GlobalData.energy_level <= 50:
		if not is_eepy:
			is_eepy = true
			kbity_ref.icon = load(kbity_eepy_img)
			console.text = "kbity is so eepy, she just take a nap."
			
	if is_eepy:
		eepy_timer += delta
		if GlobalData.energy_level <= 100:
			GlobalData.energy_level += delta * ((GlobalData.cur_bed_level + 1) * sleep_scaling_factor)
		else:
			GlobalData.energy_level = 100
		if eepy_timer >= eepy_cooldown or GlobalData.energy_level >= 100:
			console.text = "kbity wakes up from her slumber."
			is_eepy = false
			eepy_timer = 0
			kbity_ref.icon = load(kbity_awake_img)
			
	if GlobalData.hungi_level <= 50 and not is_eepy:
		if not is_eat:
			is_eat = true
			console.text = "kbity just needs nibl"
	elif GlobalData.hungi_level > 100:
		GlobalData.hungi_level = 100
		
	if is_eat and not is_eepy:
		eat_timer += delta
		if GlobalData.hungi_level <= 100:
			GlobalData.hungi_level += delta * ((GlobalData.cur_food_level + 1) * eating_scaling_factor)
		else:
			GlobalData.hungi_level = 100
		if eat_timer >= eating_cooldown or GlobalData.hungi_level >= 100:
			GlobalData.hungi_level = 100
			is_eat = false
			eat_timer = 0
				
	if GlobalData.happy_level <= 25 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity is so sad, she just cri"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
	
	if GlobalData.happy_level >= 50 and GlobalData.happy_level <= 75 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity is so happy she purrs and plays with her favorite toy mouse"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
		
		
	if GlobalData.happy_level >= 75 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity feels so content, she appreciates your gentle care"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
		
	
	if not is_eat and not is_eepy:
		if GlobalData.hungi_level - delta * hungi_gain_factor > 0:
			GlobalData.hungi_level -= delta * hungi_gain_factor / (GlobalData.cur_food_level + 1)
		else:
			GlobalData.hungi_level = 0
	if not is_eepy:
		if GlobalData.energy_level - delta * eepy_gain_factor > 0:
			GlobalData.energy_level -= delta * eepy_gain_factor / (GlobalData.cur_bed_level + 1)
		else:
			GlobalData.energy_level = 0
	var base_happy_level = ((GlobalData.cur_bed_level * 3.75) + (GlobalData.cur_food_level*3.75) + (GlobalData.cur_litter_level*3.75) + (GlobalData.cur_toy_level*3.75))
	if GlobalData.happy_level >= base_happy_level:
		if GlobalData.happy_level - delta * sad_gain_factor > 0:
			GlobalData.happy_level -= delta * sad_gain_factor / ((base_happy_level / 37.5) + 1)
		else:
			GlobalData.happy_level = 0
	else:
		GlobalData.happy_level += delta
		
	# Final Graphics Updates:
	
	happy_bar.text = "Happiness: " + str(round(GlobalData.happy_level))
	energy_bar.text = "Energy: " + str(round(GlobalData.energy_level))
	hungi_bar.text = "Hungi level: " + str(round(GlobalData.hungi_level))
	kbity_bux_bar.text = "Kbity Bux: " + str(round(GlobalData.coins))

func _process_input(id: int, idx: int) -> void:
	if GlobalData.paused:
		return
	match id:
		KBITY:
			match idx:
				PET_KBITY:
					if not GlobalData.is_pet:
						console.text = "You pet kbity :3"
						GlobalData.happy_level += 10
						GlobalData.is_pet = true
				TREAT_KBITY:
					if not GlobalData.is_treated and not (is_eepy or is_eat):
						console.text = "kbity loves eating treats ^w^"
						GlobalData.happy_level += 5
						if GlobalData.hungi_level < 100:
							GlobalData.hungi_level += 10
						else:
							GlobalData.hungi_level = 100
						GlobalData.is_treated = true
					if is_eepy:
						console.text = "Kbity is just eepy rn, she eats treat when she wake up"
					if is_eat:
						console.text = "Kbity is eating food now, dont ruin her appetite"
				PLAY_KBITY:
					if not GlobalData.is_played and GlobalData.happy_level >= 25:
						console.text = "You play with kbity"
						GlobalData.happy_level += 5
						GlobalData.is_played = true
						GlobalData.paused = false
						get_tree().change_scene_to_file("res://scenes/maps/Kbity_Challenge_Play.tscn")
					elif GlobalData.happy_level < 25:
						console.text = "Kbity is too depressed to play, she needs care"
				BRUSH_KBITY:
					if not GlobalData.is_brushed and not is_eepy:
						console.text = "Kbity purr, she so soft now"
						GlobalData.is_brushed = true
						GlobalData.paused = false
						get_tree().change_scene_to_file("res://scenes/maps/Brush_Game.tscn")
					if is_eepy:
						console.text = "Kbity is just so eepy, brush when she done with nap"
		TOY:
			var toy = toy_dict[GlobalData.cur_toy_level]
			match idx:
				DETAILS:
					console.text = toy.desc
				UPGRADE:
					if GlobalData.cur_toy_level + 1 < max_level and GlobalData.coins >= toy.cost:
						GlobalData.cur_toy_level += 1
						GlobalData.coins -= toy.cost
						update_icons()
		BED:
			var bed = bed_dict[GlobalData.cur_bed_level]
			match idx:
				DETAILS:
					console.text = bed.desc
				UPGRADE:
					if GlobalData.cur_bed_level + 1 < max_level and GlobalData.coins >= bed.cost:
						GlobalData.cur_bed_level += 1
						GlobalData.coins -= bed.cost
						update_icons()
		FOOD:
			var food = food_dict[GlobalData.cur_food_level]
			match idx:
				DETAILS:
					console.text = food.desc
				UPGRADE:
					if GlobalData.cur_food_level + 1 < max_level and GlobalData.coins >= food.cost:
						GlobalData.cur_food_level += 1
						GlobalData.coins -= food.cost
						update_icons()
		LITTER:
			var litter = litter_dict[GlobalData.cur_litter_level]
			match idx:
				DETAILS:
					console.text = litter.desc
				UPGRADE:
					if GlobalData.cur_litter_level + 1 < max_level and GlobalData.coins >= litter.cost:
						GlobalData.cur_litter_level += 1
						GlobalData.coins -= litter.cost
						update_icons()
						
func update_icons():
	var toy = toy_dict[GlobalData.cur_toy_level]
	var bed = bed_dict[GlobalData.cur_bed_level]
	var food = food_dict[GlobalData.cur_food_level]
	var litter = litter_dict[GlobalData.cur_litter_level]
	if GlobalData.cur_toy_level == max_level:
		toy_ref.get_popup().set_item_text(1, "Max Upgrade Reached")
	else:
		toy_ref.get_popup().set_item_text(1, "Upgrade: " + str(toy.cost))
		
	if GlobalData.cur_bed_level == max_level:
		bed_ref.get_popup().set_item_text(1, "Max Upgrade Reached")
	else:
		bed_ref.get_popup().set_item_text(1, "Upgrade: " + str(bed.cost))
		
	if GlobalData.cur_food_level == max_level:
		food_ref.get_popup().set_item_text(1, "Max Upgrade Reached")
	else:
		food_ref.get_popup().set_item_text(1, "Upgrade: " + str(food.cost))
		
	if GlobalData.cur_litter_level == max_level:
		litter_ref.get_popup().set_item_text(1, "Max Upgrade Reached")
	else:
		litter_ref.get_popup().set_item_text(1, "Upgrade: " + str(litter.cost))
	
	
	
	
	toy_ref.icon = load(toy_img_list[GlobalData.cur_toy_level])
	bed_ref.icon = load(bed_img_list[GlobalData.cur_bed_level])
	food_ref.icon = load(food_img_list[GlobalData.cur_food_level])
	litter_ref.icon = load(litter_img_list[GlobalData.cur_litter_level])
		
