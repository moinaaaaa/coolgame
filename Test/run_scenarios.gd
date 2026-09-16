extends Node

@onready var _timeout : Timer = $Timer

var _scenario_scenes : Array[IScenario] = []
var _scenario_idx : int = 0
var _scenario_ready : bool = false
var _test_passed : bool = true
var _total_scenario : int
var _passed_scenarios : int

signal finished(passed: bool, msg: String)

func run_scenarios(dir: String):
	_FindScenarioScenes(dir)
	_total_scenario = _scenario_scenes.size()
	if _total_scenario == 0:
		printerr("Could not find scenes in directory. Check to make sure scenario scenes are in ", dir)
		_test_passed = false
	_scenario_ready = true

func _reset():
	_test_passed = true
	_scenario_idx = 0
	_scenario_scenes.clear()
	_passed_scenarios = 0

func _process(_delta: float) -> void:
	if _scenario_ready:
		_scenario_ready = false
		if _scenario_idx < _total_scenario:
			_run_scenario(_scenario_scenes[_scenario_idx])
		else:
			finished.emit(_test_passed, String(str(_passed_scenarios) + "/" + str(_total_scenario)))
			_reset()

func _FindScenarioScenes(dir: String):
	var dir_access = DirAccess.open(dir)
	if dir_access == null:
		_test_passed = false
		printerr("Could not find test directory. Check to make sure directory ", dir, " exists")
	else:
		var scenario_files = dir_access.get_files()
		for file in scenario_files:
			if file.get_extension() == "tscn":
				var scenario_scene = load(dir_access.get_current_dir() + "/" + file).instantiate()
				if scenario_scene is IScenario:
					_scenario_scenes.append(scenario_scene)

func _clean_up(scene: IScenario):
	call_deferred("remove_child", scene)
	scene.call_deferred("queue_free")

func _run_scenario(scenario_scene: IScenario) -> void:
	add_child(scenario_scene)
	_run_async(scenario_scene)
	_timeout.start(scenario_scene.scenario_timeout_secs)

func _run_async(scenario_scene: IScenario):
	@warning_ignore("redundant_await")
	var passed : bool = await scenario_scene.run()
	_timeout.stop()
	scenario_finished(scenario_scene, passed)

func scenario_finished(scenario_scene: IScenario, passed : bool):
	if !_scenario_ready:
		var scenario_name = scenario_scene.name
		_clean_up(scenario_scene)
		_scenario_idx += 1
		if !passed:
			print_rich("\t\t", scenario_name, "[color=red] failed[/color]")
			_test_passed = false
		else:
			_passed_scenarios += 1
			print_rich("\t\t", scenario_name,"[color=green] passed[/color]")
		_scenario_ready = true

func _on_scenario_timeout():
	scenario_finished(_scenario_scenes[_scenario_idx], false)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
