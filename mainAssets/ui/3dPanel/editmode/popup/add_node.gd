extends Control

var target :Node

@onready var item_list = $ItemList
@onready var line_edit = $LineEdit

var event_manager

func set_target(item:Node):
	target = item

func _ready():
	event_manager = Engine.get_singleton("event_manager")
	print("event supplier: "+str(event_manager))
	item_list.item_selected.connect(func(index):
		if is_instance_valid(target):
			var tmpclass :String = item_list.get_item_text(index)
			if is_instance_valid(event_manager):
				event_manager.add_node(event_manager.root.get_path_to(target),{
					"node_class":tmpclass,
					"properties":[
						{
							"name": "metadata/display_name",
							"value" :tmpclass
						}
					]
				})
		item_list.deselect_all()
		)
	line_edit.text_changed.connect(func(new_text:String):
		item_list.deselect_all()
		item_list.clear()
		new_text = new_text.to_lower()
		for cls in ClassDB.get_class_list():
			if ClassDB.is_parent_class(cls, "Node"):
				var contains_all_chars :bool = true
				var clslower := cls.to_lower()
				for char in new_text:
					if !clslower.contains(char):
						contains_all_chars = false
						break
				if contains_all_chars or clslower.contains(new_text) or clslower.similarity(new_text) > .6:
					item_list.add_item(cls)
		)
	for cls in ClassDB.get_class_list():
		if ClassDB.is_parent_class(cls, "Node"):
			item_list.add_item(cls)
