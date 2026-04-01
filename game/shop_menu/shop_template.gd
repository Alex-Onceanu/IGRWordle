extends Control

signal next_level_pressed

#region Variables
var _shop_items_available : Array[Item] = []
var _shop_items_selected_indices : Array[int] = []
#endregion

#region Private functions
func _ready():
	var shop_item = Item.create("caca","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = Item.create("caca2","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = Item.create("caca3","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = Item.create("caca3","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)

func _on_selected_item_do(item : Item) -> void:
	for i in range(_shop_items_available.size()):
		if _shop_items_available[i] == item :
			_shop_items_selected_indices.append(i)
			return
			
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
	# remove only the items bought
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
	# add bought items.

func _on_next_level_pressed() -> void:
	next_level_pressed.emit()
#endregion

#region Public functions
func append_item(item : Item) -> void:
	# adding to the items list
	_shop_items_available.append(item)
	# adding as a child of ItemsContainer 
	$ScrollContainer/ItemsContainer.add_child(item)
	item.item_selected.connect(func() : _on_selected_item_do(item))

func remove_item(index : int) -> Item:
	var item : Item = _shop_items_available[index]
	_shop_items_available.remove_at(index)
	return item

func get_items(index : int) -> Item:
	return _shop_items_available[index]
#endregion
