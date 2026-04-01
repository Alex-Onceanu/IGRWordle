extends Control
class_name Item

enum ItemType{
	PERMANENT,
	TEMPORARY,
	CHALLENGE,
}

#region Signals
signal item_selected
#endregion

#region Variables
var item_name : String = "test title":
	set(item_name_v):
		item_name = item_name_v
		_update_display(item_name, description)
var description : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.":
	set(description_v):
		description = description_v
		_update_display(item_name, description)
var price : int = 0
var i : int = 0
var icon : Texture2D = preload("res://icon.svg"):
	set(icon_v):
		icon = icon_v
		if icon != null:
			$TextureButton.texture_normal = icon
		_apply_click_mask()
		
const ITEM_SCENE_PATH : String = "res://game/shop_menu/shop_item.tscn"
var item_type : ItemType = ItemType.TEMPORARY
#endregion

#region Private functions
func _apply_click_mask():
	if icon == null:
		return
	var bitmap = BitMap.new()
	var image = icon.get_image()
	bitmap.create_from_image_alpha(image)
	$TextureButton.texture_click_mask = bitmap

func _update_display(titre: String, desc: String):
	var template = "[center][b][font_size=24]{nom}[/font_size][/b]\n\n{info}[/center]"
	var final_text = template.format({"nom": titre, "info": desc})
	$PanelContainer/MarginContainer/Description.text = final_text

func _on_texture_button_pressed() -> void:
	item_selected.emit()
#endregion

#region Public functions
static func create(p_name: String, p_desc: String, p_price: int, p_tex: Texture2D) -> Item:
	var scene = load(ITEM_SCENE_PATH)
	var node = scene.instantiate()
	node.item_name = p_name
	node.description = p_desc
	node.price = p_price
	node.icon = p_tex
	return node
#endregion
