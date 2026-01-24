extends CanvasLayer

@onready var label: Label = $HistoryLabel

func _ready():
	update_text()

	if Harvest_History.has_signal("history_changed"):
		Harvest_History.connect("history_changed", Callable(self, "update_text"))

func update_text():
	var text := "HARVEST HISTORY:\n"

	var data = Harvest_History.get_all()
	for item in data.keys():
		text += "%s : %d\n" % [item, data[item]]

	label.text = text
