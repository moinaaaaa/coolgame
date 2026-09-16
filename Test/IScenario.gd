@abstract
class_name IScenario

extends Node

@export_range(0.1, 360.0, 0.01, "or_greater", "suffix:s") var scenario_timeout_secs : float = 2.0

@abstract func run() -> bool
