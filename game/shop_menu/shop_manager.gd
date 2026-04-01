extends Node
class_name ShopManager

signal next_level_pressed
@export var items_container : Control
@export var MAX_ITEMS_PER_TYPES : int = 3
#region Variables
var _shop_items_available : Array[Item] = []
var _shop_items_selected_indices : Array[int] = []
#endregion

#region Private functions
func _ready():
	var shop_item : Item;
	for child in items_container.get_children():
		for i in range(MAX_ITEMS_PER_TYPES):
			shop_item = Item.create("caca","prout", 100, load("res://game/shop_menu/test_image.png"))
			if child.name == "Permanents":
				shop_item.item_type = Item.ItemType.PERMANENT
			elif child.name == "Temporaries":
				shop_item.item_type = Item.ItemType.TEMPORARY
			elif child.name == "Challenges" :
				shop_item.item_type = Item.ItemType.CHALLENGE
			append_item(shop_item)

func _on_selected_item_do(item : Item) -> void:
	for i in range(_shop_items_available.size()):
		if _shop_items_available[i] == item && i not in _shop_items_selected_indices:
			_shop_items_selected_indices.append(i)
			break
	print(_shop_items_selected_indices)

func _on_buy_button_pressed() -> void:
	var bought_items : Array[Item] = []
	var remaining_items : Array[Item] = []
	var total_price : int = 0
	
	# verify if the player has enough money
	for i in range(_shop_items_available.size()):
		if (i in _shop_items_selected_indices):
			total_price+=_shop_items_available[i].price
	if total_price > GameState.coins :
		print("you cannot buy that much !")
		return
	# remove only the bought items
	for i in range(_shop_items_available.size()):
		if (i in _shop_items_selected_indices):
			bought_items.append(_shop_items_available[i])
		else :
			remaining_items.append(_shop_items_available[i])
	_shop_items_selected_indices.clear()
	while (_shop_items_available.size() > 0):
		remove_item(_shop_items_available.size()-1)
	for item in remaining_items:
		append_item(item)
	for item in bought_items:
		item.queue_free()
	
	# update the GameState
	GameState.coins -= total_price
	# TODO: add bought items to something

func _on_next_level_pressed() -> void:
	next_level_pressed.emit()
#endregion

#region Public functions
func append_item(item : Item) -> void:
	var target_name : String = ""
	match item.item_type:
		Item.ItemType.PERMANENT: target_name = "Permanents"
		Item.ItemType.TEMPORARY: target_name = "Temporaries"
		Item.ItemType.CHALLENGE: target_name = "Challenges"

	var category_node = items_container.get_node_or_null(target_name)

	if category_node and category_node.get_child_count() < MAX_ITEMS_PER_TYPES:
		category_node.add_child(item)
		_shop_items_available.append(item)
		item.item_selected.connect(_on_selected_item_do.bind(item))
	else:
		print("Impossible to add {n} : not found or full.".format({"n": item.item_name}))

func remove_item(index : int) -> Item:
	var item : Item = _shop_items_available[index]
	_shop_items_available.remove_at(index)
	match item.item_type:
		Item.ItemType.PERMANENT : items_container.find_child("Permanents").remove_child(item); return item
		Item.ItemType.TEMPORARY : items_container.find_child("Temporaries").remove_child(item); return item
		Item.ItemType.CHALLENGE : items_container.find_child("Challenges").remove_child(item); return item
		_ : return null
		


func get_items(index : int) -> Item:
	return _shop_items_available[index]
#endregion
