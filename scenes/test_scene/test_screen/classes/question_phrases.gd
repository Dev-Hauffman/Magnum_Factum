extends Node
class_name QuestionPhrases


const PHRASES:Dictionary = {
	"0": "In logica, mathematica, computatrum scientia et linguistica, lingua formalis consistit in verbis, quarum litterae ab alphabeto sumuntur et formantur secundum certas regulas.",
	"1": "Alphabetum linguae formalis constat ex symbolis, litteris, vel signis quae in chordas linguae concatenatae sunt.",
	"2": "Quaelibet chorda a symbolis huius alphabeti concatenata, verbum dicitur, et verba quae ad linguam formalem particularem pertinent, interdum dicuntur verba bene formatae vel formulae bene formatae.",
	"3": "Lingua formalis saepe definitur per grammaticam formalem sicut grammatica regularis seu grammatica contextus libera, quae ex regula formationis consistit.",
	"4": "In scientia computatrali linguae formales inter alios adhibentur ut fundamentum definiendi grammatica programmandi linguarum et formalizata versiones copiarum linguarum naturalium in quibus verba linguae notiones significant quae cum significationibus vel semanticis coniunguntur. ",
	"5": "In multiplicitate computativa theoria, problemata decisionum typice definiuntur linguae formales, et genera multiplicitatis definiuntur ut rationes linguarum formalium quae per machinis cum potentia computativa limitata partiri possunt.",
	"6": "In logicis et mathematicis fundamentis, linguae formales syntaxum systematum axiomaticorum repraesentant, et formalismus mathematica est philosophia quam omnes mathematicae ad syntacticam manipulationem formalium linguarum hoc modo reduci possunt.",
	"7": "Theoriae linguae formalis campus studet imprimis rationes mere syntacticas talium linguarum, id est earum formarum structurarum internam.",
	"8": "Theoria linguae formalis e linguisticis orta est, ut modus cognoscendi syntactica regularitates linguarum naturalium.",
}


static func choose_phrase()-> String:
	var random_number = randi_range(0, PHRASES.size() - 1)
	var chosen_phrase:String = PHRASES[str(random_number)]
	return chosen_phrase
