extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var timer: Timer = $ProgressBar/Label/Timer
@onready var label: Label = $ProgressBar/Label

signal game_over

func _ready() -> void:
	progress_bar.max_value = timer.wait_time
	timer.start()
	
func _process(_delta: float) -> void:
	label.text = "%.1f" % timer.time_left
	progress_bar.value = timer.time_left

func _on_cut_bar_mouse_clicked(type) -> void:
	match type:
		CutType.Result.PERFECT:
			add_to_current_timer(1)
		CutType.Result.GOOD:
			add_to_current_timer(0.5)
		CutType.Result.MISS:
			add_to_current_timer(-2)
			
func add_to_current_timer(value: float) -> void:
	var new_time: float = timer.time_left + value
	if new_time > 0:
		timer.stop()
		timer.start(new_time)

func _on_timer_timeout() -> void:
	$"../GameOver".appear()
