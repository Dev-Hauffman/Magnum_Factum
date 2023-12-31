extends Node
class_name QuestionCatalog


const QUESTIONS:Dictionary = {
	"0": [[1, 1.5], [1, 1.0], [3, 2.5], [2, 2.0], [3, 3.0]], #212
	"1": [[1, 1.0], [1, 1.0], [3, 2.5], [2, 2.0], [3, 3.5]], #212
	"2": [[1, 1.0], [1, 1.0], [3, 3.0], [2, 2.0], [3, 3.0]], #212
	"3": [[1, 0.5], [1, 0.5], [3, 1.5], [3, 2.5], [3, 1.5], [2, 1.0], [3, 1.5], [2, 1.0]], #224
	"4": [[1, 0.5], [1, 0.5], [3, 1.5], [3, 3.0], [1, 1.0], [2, 1.0], [3, 1.5], [2, 1.0]], #323
	"5": [[1, 0.5], [1, 1.0], [3, 1.5], [3, 2.0], [3, 1.5], [2, 1.0], [3, 1.5], [2, 1.0]], #224
	"6": [[3, 3.3], [3, 3.3], [3, 3.4]], #333
	"7": [[3, 4.0], [3, 3.0], [3, 3.0]], #333
	"8": [[3, 3.5], [3, 3.5], [3, 3.0]], #333
}


static func retrieve_questions(level:int = 1)-> Array:
	var random_number = randi_range(0,QUESTIONS.size() - 1)
	var chosen_questions = QUESTIONS[str(random_number)]
	return chosen_questions
