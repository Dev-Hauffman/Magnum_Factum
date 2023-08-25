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


func define_questions() -> Array[QuestionInfo]:
	var questions:Array[QuestionInfo] = []
	var question_catalog:QuestionCatalog = QuestionCatalog.new()
	var retrieved_data:Array = question_catalog.retrieve_questions(level)
	var questions_data = retrieved_data.duplicate()
	questions_data.shuffle()
	var counter:int = 0
	for data in questions_data:
		var question_info:QuestionInfo = QuestionInfo.new()
		question_info.number = counter + 1
		question_info.difficulty = Difficulties[str(data[0])]
		question_info.score = data[1]
		counter += 1
		questions.append(question_info)
	questions = populate_questions(questions)
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