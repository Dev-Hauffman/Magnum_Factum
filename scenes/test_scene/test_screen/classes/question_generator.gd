extends Node
class_name QuestionGenerator


var Difficulties:Dictionary = {
	"0": "Very easy",
	"1": "Easy",
	"2": "Medium",
	"3": "Hard",
	"4": "Very hard"
}


var level = 1
var possible_question_quantity = [3, 5, 8, 10]
var possible_difficulties = {
	"3": ["medium", "hard", "very hard"],
	"5": ["easy", "medium", "hard", "very hard"],
	"8": ["very easy", "easy", "medium", "hard", "very hard"],
	"10": ["very easy", "easy", "medium", "hard", "very hard"],
	}


func define_questions() -> Array[QuestionInfo]:
	var questions:Array[QuestionInfo] = []
	var question_catalog:QuestionCatalog = QuestionCatalog.new()
	var questions_data:Array = question_catalog.retrieve_questions(level)
	var counter:int = 0
	for data in questions_data:
		var question_info:QuestionInfo = QuestionInfo.new()
		question_info.number = counter + 1
		question_info.difficulty = Difficulties[str(data[0])]
		question_info.score = data[1]
		counter += 1
		questions.append(question_info)
	questions = populate_questions(questions)
	
	
#	var question_quantity:int = choose_number_of_questions()
#	for question_number in question_quantity:		
#		var question_item:QuestionInfo = QuestionInfo.new()
#		questions.append(question_item)
#	questions = choose_question_difficulty(questions)
#	questions = choose_question_score(questions)
	return questions


func populate_questions(questions:Array[QuestionInfo]) -> Array[QuestionInfo]:
	for question in questions:
		match question.difficulty:
			"Very easy":
				question.paragraph.append(QuestionPhrases.choose_phrase())
			"Easy":
				for i in range(2):
					question.paragraph.append(QuestionPhrases.choose_phrase())
			"Medium":
				for i in range(4):
					question.paragraph.append(QuestionPhrases.choose_phrase())
			"Hard":
				for i in range(8):
					question.paragraph.append(QuestionPhrases.choose_phrase())
			"Very hard":
				for i in range(10):
					question.paragraph.append(QuestionPhrases.choose_phrase())
	return questions


func choose_number_of_questions() -> int:
	possible_question_quantity.shuffle()
	return possible_question_quantity[0]


func choose_question_difficulty(questions:Array[QuestionInfo]) -> Array[QuestionInfo]:
	var very_hard_chance:int = 20
	var hard_chance:int = 40
	var medium_chance:int = 60
	var easy_chance:int = 50
	var very_easy_chance:int = 30
	var very_hard_quantity
	var max_very_hard_quantity:int
	var hard_quantity
	var max_hard_quantity:int
	var very_easy_quantity
	var max_very_easy_quantity:int
	match questions.size():
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
	for question in questions:
		var chosen_value = randi_range(1, 100)
		match questions.size():
			3:
				if chosen_value <= very_hard_chance and very_hard_quantity <= max_very_hard_quantity:
					question.difficulty = "very hard"
					very_hard_quantity += 1
				if chosen_value <= hard_chance and hard_quantity <= max_hard_quantity:
					question.difficulty = "hard"
					hard_quantity += 1
				else:
					question.difficulty = "medium"
			5:
				if chosen_value <= very_hard_chance and very_hard_quantity <= max_very_hard_quantity:
					question.difficulty = "very hard"
					very_hard_quantity += 1
				if chosen_value <= hard_chance and hard_quantity <= max_hard_quantity:
					question.difficulty = "hard"
					hard_quantity += 1
				if chosen_value <= easy_chance:
					question.difficulty = "easy"
				else:
					question.difficulty = "medium"				
			_:
				if chosen_value <= very_hard_chance and very_hard_quantity <= max_very_hard_quantity:
					question.difficulty = "very hard"
					very_hard_quantity += 1
				if chosen_value <= very_easy_chance and very_easy_quantity <= max_very_easy_quantity:
					question.difficulty = "very easy"
					very_easy_quantity += 1
				if chosen_value <= hard_chance and hard_quantity <= max_hard_quantity:
					question.difficulty = "hard"
					hard_quantity += 1
				if chosen_value <= easy_chance:
					question.difficulty = "easy"
				else:
					question.difficulty = "medium"
	return questions


func choose_question_score(questions:Array[QuestionInfo]) -> Array[QuestionInfo]:
	var score_left_to_distribute:float
	var very_easy_quantity:int
	var easy_quantity:int
	var medium_quantity:int
	var hard_quantity:int
	var very_hard_quantity:int
	var code:String = ""
	
	var score_distribution:ScoreDistribution = ScoreDistribution.new()
	for question in questions:
		match questions.size():
			3:
				var base_score = 3.33
				var score = score_distribution.get_score(questions.size(), code, question.difficulty)
				if score == -1:
					question.score = base_score
				else:
					question.score = score
			5:
				var base_score = 2.0
				pass
			8:
				var base_score = 1.25
				pass
			10:
				var base_score = 1.0
				pass
			_:
				printerr("Invalid number of questions")
	return questions

