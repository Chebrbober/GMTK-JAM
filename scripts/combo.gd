extends Control

@onready var label: Label = $Label
@onready var start_size: Vector2 = label.size
@onready var countdown: Control = $"../Countdown"
@onready var rush_mode: Node = $RushMode
@export var succesful_cuts_done: int = 0
var tween: Tween

func _ready() -> void:
	label.visible = false

func _on_cut_bar_mouse_clicked(type: CutType.Result) -> void:
	if type in [CutType.Result.PERFECT, CutType.Result.GOOD]:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(label, "size", start_size, 0.25).set_trans(Tween.TRANS_ELASTIC).from(Vector2(0,0))
		label.visible = true
		label.rotation = randf_range(-1, 1)
		succesful_cuts_done += 1
		label.text = str(succesful_cuts_done) + "x"
		if succesful_cuts_done != 1:
			check_upgrade()
	else:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(label, "size", start_size, 0.25).set_trans(Tween.TRANS_EXPO).from_current()
		succesful_cuts_done = 0
		label.visible = false
		
func check_upgrade() -> void:
	if succesful_cuts_done != 1:
		if succesful_cuts_done % 30:
			rush_mode.enable_mode()
		elif succesful_cuts_done % 20:
			countdown.add_to_current_timer(5)
		elif succesful_cuts_done % 10:
			countdown.add_to_current_timer(3)
	elif succesful_cuts_done > 1:
		countdown.add_to_current_timer(1)
