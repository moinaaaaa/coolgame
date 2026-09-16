@tool
extends Node

@export_dir var _test_directories : Array[String]

@export var _run_single_test := false :
	set(value):
		_run_single_test = value
		notify_property_list_changed()
@export_dir var _test_directory : String

@onready var _test_scenarios : Node = $RunScenarios

var _tests : Array[String]
var _test_idx : int = 0
var _total_passed : int = 0
var _total_failed : int = 0
var _test_ready := true

func _ready():
	if _run_single_test:
		_tests = [_test_directory]
	else:
		_tests = _test_directories
	print("Found ", _tests.size(), " tests\n")
	_test_scenarios.finished.connect(_on_test_scene_finished)

func _process(_delta):
	if _test_ready:
		_test_ready = false
		_run()

func _validate_property(property: Dictionary) -> void:
	if property.name in ["_test_directory"] && !_run_single_test:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _run():	
	if _test_idx < _tests.size():
		var test = _tests[_test_idx]
		print("\tTest: ", test.get_slice("/", test.get_slice_count("/") - 2))
		_test_scenarios.run_scenarios(test)
		_test_idx += 1
	else:
		print("Ran ", _test_idx, " of ", _tests.size(), " tests")
		print("Passing tests: ", _total_passed)
		print("Failing tests: ", _total_failed)
		# wait for print statements before closing
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()

func _on_test_scene_finished(passed: bool, msg: String):
	var output : String = ""
	if passed:
		output = "[color=green]\tTest passed. All "
		_total_passed += 1
	else:
		output = "[color=red]\tTest failed. "
		_total_failed += 1
	output += msg + " scenarios passed[/color]\n"
	print_rich(output)
	_test_ready = true
