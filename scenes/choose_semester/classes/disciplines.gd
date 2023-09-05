extends Node
class_name Disciplines


const existing_disciplines:Array = [
	["Programming Foundations", "1"],
	["Introduction to Computing", "1"],
	["Algorithms and Data Structure", "2"],
	["Object Oriented Computing", "2"],
	["Low Level Programming", "3"],
	["Languages, automata and Computing", "3"],
	["Computer Graphics", "4"],
	["Functional Programming", "4"],
	["Operational Systems", "5"],
	["Computability and Complexity Theory", "5"],
	["Artificial Intelligence", "6"],
	["Formal Methods for computing", "6"]
]


static func get_existing_disciplines() -> Array:
	return existing_disciplines
