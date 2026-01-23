extends PanelContainer
class_name InfoPanel

signal actionRequested(action: String, data: Dictionary)

@onready var panelTitle : Label = $MarginContainer/VBoxContainer/Header/PanelName
@onready var closeButton : Button = $MarginContainer/VBoxContainer/Header/CloseButton
@onready var infoVBox : VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/InfoVBox

var tween : Tween
var isOpen : bool = false
"""
var exampleModel = {
	"title": "Galaxy Ring: INNER",
	"sections": [
		{"header":"Summary",
		 "rows":[
			{"type":"kv","k":"Systems","v":"12"},
			]
		},
		{"header":"Star Systems",
		"rows":[
			{"type":"button","text":"Sol","action":"open_system","id":"sol"}
		]
		}
	]
}
"""

var baseLeft := 0.0
var baseRight := 0.0
var slide := 0.0
var cached := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	closeButton.text = "✕"
	closeButton.custom_minimum_size = Vector2(30,30)
	closeButton.pressed.connect(closePanel)
	call_deferred("cacheLayout")
	pass # Replace with function body.

func cacheLayout() -> void:
	await get_tree().process_frame

	baseLeft = offset_left
	baseRight = offset_right
	slide = size.x
	cached = true

	offset_left = baseLeft + slide
	offset_right = baseRight + slide
	visible = false
	isOpen = false

func openPanelWithData(data: Dictionary) -> void:
	panelTitle.text = str(data.get("title"))

	# Clear out old data
	for child in infoVBox.get_children():
		child.queue_free()

	# Create updated data
	var sections : Array = data.get("sections")
	for section in sections:
		addSection(section)

	openPanel()

func tweenPanel(isOpening : bool) -> void:
	await get_tree().process_frame
	killTween()

	var width = size.x

	tween = create_tween()
	if isOpening:
		offset_left = baseLeft + slide
		offset_right = baseRight + slide
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "offset_left", baseLeft, 0.2)
		tween.parallel().tween_property(self, "offest_right", baseRight, 0.2)
	else:
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "offset_left", width, 0.2)
		tween.parallel().tween_property(self, "offest_right", width, 0.2)
		tween.finished.connect(func():
			visible = false
		)

## Open and close just hold simple tween and position state logic for open/closing the panel
func openPanel() -> void:
	if isOpen:
		return
	isOpen = true
	
	visible = true

	tweenPanel(true)
	"""
	await get_tree().process_frame
	killTween()

	var width = size.x


	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "offset_left", 0.0, 0.2)
	tween.parallel().tween_property(self, "offest_right", 0.0, 0.2)
	"""


func closePanel() -> void:
	if not isOpen:
		visible = false
		return
	isOpen = false

	tweenPanel(false)
	"""
	await get_tree().process_frame
	killTween()

	var width = size.x

	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "offset_left", width, 0.2)
	tween.parallel().tween_property(self, "offest_right", width, 0.2)
	tween.finished.connect(func():
		visible = false
	)
	"""

func killTween() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = null

func addSection(section: Dictionary) -> void:
	var name : String = str(section.get("header"))

	# Sets name from data and adds child to the VBox
	if name != "":
		print_debug("section not null/empty")
		var header = Label.new()
		header.text = name
		header.add_theme_font_size_override("font_size", 18)
		infoVBox.add_child(header)

	# Gets the relevant data
	var rows : Array = section.get("rows")
	for row in rows:
		addRow(row)

	# Space between sections
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0,10)
	infoVBox.add_child(spacer)

func addRow(row: Dictionary) -> void:
	var t := str(row.get("type", "emptyType"))

	match t:
		"kv":
			rowKV(str(row.get("k", "emptyKey")), str(row.get("v", "emptyValue")))
		"label":
			rowLabel(str(row.get("text", "emptyText")))
		"button":
			rowButton(str(row.get("text", "emptyButton")))
		"separator":
			infoVBox.add_child(HSeparator.new())
		_:
			rowLabel("Unknown Row")
	
func rowLabel(text : String) -> void:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	infoVBox.add_child(label)

func rowKV(k : String, v : String) -> void:
	var header = HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var keyLabel = makeNewLabel(k)
	keyLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var valueLabel = makeNewLabel(v)
	valueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	header.add_child(keyLabel)
	header.add_child(valueLabel)
	infoVBox.add_child(header)

func makeNewLabel(text : String) -> Label:
	var label = Label.new()
	label.text = text
	return label

func rowButton(text : String) -> void:
	var button = Button.new()
	button.text = text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#button.pressed.connect(func():
	#    action_requested.emit(action, payload)
	#)
	infoVBox.add_child(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
