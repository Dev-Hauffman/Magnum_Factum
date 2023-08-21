extends Node
class_name QuestionGenerator


var possible_question_quantity = [3, 5, 8, 10]
var possible_difficulties = {
	"3": ["medium", "hard", "very hard"],
	"5": ["easy", "medium", "hard", "very hard"],
	"8": ["very easy", "easy", "medium", "hard", "very hard"],
	"10": ["very easy", "easy", "medium", "hard", "very hard"],
	}


func define_questions() -> Array[QuestionInfo]:
	var questions:Array[QuestionInfo] = []
	var question_quantity:int = choose_number_of_questions()
	for value in question_quantity:
		var question:QuestionInfo = QuestionInfo.new()
		question.difficulty = choose_question_difficulty(question_quantity)
	choose_question_score()
	return questions


func choose_number_of_questions() -> int:
	possible_question_quantity.shuffle()
	return possible_question_quantity[0]


func choose_question_difficulty(question_quantity:int):
	var very_hard_chance:int = 20
	var hard_chance:int = 40
	var medium_chance:int = 60
	var easy_chance:int = 50
	var very_easy_chance:int = 30
	var max_very_hard_quantity:int
	var max_hard_quantity:int
	var max_very_easy_quantity:int
	match question_quantity:
		3:
			max_very_hard_quantity = 2
		5:
			max_very_hard_quantity = 2
			max_hard_quantity = 3
		8:
			max_very_hard_quantity = 3
			max_hard_quantity = 5
			max_very_easy_quantity = 2
		10:
			max_very_hard_quantity = 3
			max_hard_quantity = 5
			max_very_easy_quantity = 3
		_:
			printerr("Invalid number of questions")


func choose_question_score():
	pass

