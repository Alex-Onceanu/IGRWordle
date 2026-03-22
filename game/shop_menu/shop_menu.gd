extends Control

signal buy_pressed(summary : Dictionary)
signal next_level_pressed

#region Variables
var _shop_items_available : Array[ShopItem] = []
var _shop_items_selected_indices : Array[int] = []
#endregion

#region Private functions
func _ready():
	var shop_item = ShopItem.create("caca","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = ShopItem.create("caca2","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = ShopItem.create("caca3","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)
	shop_item = ShopItem.create("caca3","prout", 100, load("res://game/shop_menu/test_image.png"))
	append_item(shop_item)

func _on_selected_item_do(item : ShopItem) -> void:
	for i in range(_shop_items_available.size()):
		if _shop_items_available[i] == item :
			_shop_items_selected_indices.append(i)
			return
			
# TODO : Remove the intelligence here and put it somewhere else so that it is cleaner.
# The current framework is a problem because we cannot handle if the player hasn't enough money to buy those items. Must be delegated higher. 
func _on_buy_button_pressed() -> void:
	var bought_items : Array[ShopItem] = []
	var remaining_items : Array[ShopItem] = []
	var total_price : int = 0
	for i in range(_shop_items_available.size()):
		if (i in _shop_items_selected_indices):
			bought_items.append(_shop_items_available[i])
			total_price+=_shop_items_available[i].price
		else :
			remaining_items.append(_shop_items_available[i])
	_shop_items_selected_indices.clear()
	
	while (_shop_items_available.size() > 0):
		remove_item(_shop_items_available.size()-1)
	for item in remaining_items:
		append_item(item)
	for item in bought_items:
		item.queue_free()
	
	var summary : Dictionary = {
		"items": bought_items,
		"total_price": total_price
	}
	print(summary)
	buy_pressed.emit(summary)

func _on_next_level_pressed() -> void:
	next_level_pressed.emit()
#endregion

#region Public functions
func append_item(item : ShopItem) -> void:
	# adding to the items list
	_shop_items_available.append(item)
	# adding as a child of ItemsContainer 
	$ScrollContainer/ItemsContainer.add_child(item)
	item.item_selected.connect(func() : _on_selected_item_do(item))

func remove_item(index : int) -> ShopItem:
	var item : ShopItem = _shop_items_available[index]
	_shop_items_available.remove_at(index)
	return item

func get_items() -> Array[ShopItem]:
	return _shop_items_available
#endregion
