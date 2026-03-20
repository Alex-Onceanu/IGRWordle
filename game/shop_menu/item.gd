extends Control

class_name Item

var item_name : String = ""
var description : String = ""
var price : int = 0

static func create(item_name : String, description, price : int):
	var item = Item.new()
	item.item_name = item_name
	item.price = price
