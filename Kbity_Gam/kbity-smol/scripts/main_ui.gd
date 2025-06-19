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

var happy_level: float = 0
var hungi_level: float = 0
var energy_level: float = 0
var kbity_bux: float = 0
var cur_toy_level = 0
var cur_food_level = 0
var cur_litter_level = 0
var cur_bed_level = 0
var pet_cooldown = 5
var treat_cooldown = 15
var play_cooldown = 10
var brush_cooldown = 10
var is_pet = false
var is_treated = false
var is_played = false
var is_brushed = false

var eating_cooldown = 10
var eat_timer = 0
var is_eat = false
var mood_cooldown = 40
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
var play_timer = 0
var brush_timer = 0
var treat_timer = 0
var pet_timer = 0
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
	# pet interaction timers
	if is_pet:
		pet_timer += delta
		if pet_timer >= pet_cooldown:
			pet_timer = 0
			is_pet = false
		kbity_ref.get_popup().set_item_text(0, "Pet: Cooldown(" + str(round(pet_cooldown - pet_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(0, "Pet")
	if is_treated:
		treat_timer += delta
		if treat_timer >= treat_cooldown:
			treat_timer = 0
			is_treated = false
		kbity_ref.get_popup().set_item_text(1, "Treat: Cooldown(" + str(round(treat_cooldown - treat_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(1, "Treat")
	if is_played:
		play_timer += delta
		if play_timer >= play_cooldown:
			play_timer = 0
			is_played = false
		kbity_ref.get_popup().set_item_text(2, "Play: Cooldown(" + str(round(play_cooldown - play_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(2, "Play")
	if is_brushed:
		brush_timer += delta
		if brush_timer >= brush_cooldown:
			brush_timer = 0
			is_brushed = false
		kbity_ref.get_popup().set_item_text(3, "Brush: Cooldown(" + str(round(brush_cooldown - brush_timer)) + ")")
	else:
		kbity_ref.get_popup().set_item_text(3, "Brush")
		
	# normal cat activities
	if energy_level <= 50:
		if not is_eepy:
			is_eepy = true
			kbity_ref.icon = load(kbity_eepy_img)
			console.text = "kbity is so eepy, she just take a nap."
			
	if is_eepy:
		eepy_timer += delta
		if energy_level <= 100:
			energy_level += delta * ((cur_bed_level + 1) * sleep_scaling_factor)
		else:
			energy_level = 100
		if eepy_timer >= eepy_cooldown or energy_level >= 100:
			console.text = "kbity wakes up from her slumber."
			is_eepy = false
			eepy_timer = 0
			kbity_ref.icon = load(kbity_awake_img)
			
	if hungi_level <= 50 and not is_eepy:
		if not is_eat:
			is_eat = true
			console.text = "kbity just needs nibl"
			
	if is_eat and not is_eepy:
		eat_timer += delta
		if hungi_level <= 100:
			hungi_level += delta * ((cur_food_level + 1) * eating_scaling_factor)
		else:
			hungi_level = 100
		if eat_timer >= eating_cooldown or hungi_level >= 100:
			is_eat = false
			eat_timer = 0
				
	if happy_level <= 25 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity is so sad, she just cri"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
	
	if happy_level >= 50 and happy_level <= 75 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity is so happy she purrs and plays with her favorite toy mouse"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
		
		
	if happy_level >= 75 and not is_eepy and not is_eat:
		if not is_mood:
			console.text = "baby kbity feels so content, she appreciates your gentle care"
			is_mood = true
		else:
			mood_timer += delta
			if mood_timer >= mood_cooldown:
				mood_timer = 0
				is_mood = false
		
	
	if not is_eat:
		if hungi_level - delta * hungi_gain_factor > 0:
			hungi_level -= delta * hungi_gain_factor / (cur_food_level + 1)
		else:
			hungi_level = 0
	if not is_eepy:
		if energy_level - delta * eepy_gain_factor > 0:
			energy_level -= delta * eepy_gain_factor / (cur_bed_level + 1)
		else:
			energy_level = 0
	var base_happy_level = ((cur_bed_level * 3.75) + (cur_food_level*3.75) + (cur_litter_level*3.75) + (cur_toy_level*3.75))
	if happy_level >= base_happy_level:
		if happy_level - delta * sad_gain_factor > 0:
			happy_level -= delta * sad_gain_factor / ((base_happy_level / 37.5) + 1)
		else:
			happy_level = 0
	else:
		happy_level += delta
		
	# Final Graphics Updates:
	
	happy_bar.text = "Happiness: " + str(round(happy_level))
	energy_bar.text = "Energy: " + str(round(energy_level))
	hungi_bar.text = "Hungi level: " + str(round(hungi_level))
	kbity_bux_bar.text = "Kbity Bux: " + str(round(kbity_bux))

func _process_input(id: int, idx: int) -> void:
	match id:
		KBITY:
			match idx:
				PET_KBITY:
					if not is_pet:
						console.text = "You pet kbity :3"
						happy_level += 10
						kbity_bux += 5
						is_pet = true
				TREAT_KBITY:
					if not is_treated:
						console.text = "kbity loves eating treats ^w^"
						happy_level += 5
						kbity_bux += 25
						hungi_level += 10
						is_treated = true
				PLAY_KBITY:
					if not is_played:
						console.text = "You play with kbity"
						happy_level += 5
						kbity_bux += 5
						is_played = true
				BRUSH_KBITY:
					if not is_brushed:
						console.text = "kbity purr, she so soft now"
						happy_level += 10
						kbity_bux += 10
						is_brushed = true
		TOY:
			var toy = toy_dict[cur_toy_level]
			match idx:
				DETAILS:
					console.text = toy.desc
				UPGRADE:
					if cur_toy_level + 1 < max_level and kbity_bux >= toy.cost:
						cur_toy_level += 1
						kbity_bux -= toy.cost
						update_icons()
		BED:
			var bed = bed_dict[cur_bed_level]
			match idx:
				DETAILS:
					console.text = bed.desc
				UPGRADE:
					if cur_bed_level + 1 < max_level and kbity_bux >= bed.cost:
						cur_bed_level += 1
						kbity_bux -= bed.cost
						update_icons()
		FOOD:
			var food = food_dict[cur_food_level]
			match idx:
				DETAILS:
					console.text = food.desc
				UPGRADE:
					if cur_food_level + 1 < max_level and kbity_bux >= food.cost:
						cur_food_level += 1
						kbity_bux -= food.cost
						update_icons()
		LITTER:
			var litter = litter_dict[cur_litter_level]
			match idx:
				DETAILS:
					console.text = litter.desc
				UPGRADE:
					if cur_litter_level + 1 < max_level and kbity_bux >= litter.cost:
						cur_litter_level += 1
						kbity_bux -= litter.cost
						update_icons()
						
func update_icons():
	var toy = toy_dict[cur_toy_level]
	var bed = bed_dict[cur_bed_level]
	var food = food_dict[cur_food_level]
	var litter = litter_dict[cur_litter_level]
	toy_ref.get_popup().set_item_text(1, "Upgrade: " + str(toy.cost))
	bed_ref.get_popup().set_item_text(1, "Upgrade: " + str(bed.cost))
	food_ref.get_popup().set_item_text(1, "Upgrade: " + str(food.cost))
	litter_ref.get_popup().set_item_text(1, "Upgrade: " + str(litter.cost))
	toy_ref.icon = load(toy_img_list[cur_toy_level])
	bed_ref.icon = load(bed_img_list[cur_bed_level])
	food_ref.icon = load(food_img_list[cur_food_level])
	litter_ref.icon = load(litter_img_list[cur_litter_level])
		
