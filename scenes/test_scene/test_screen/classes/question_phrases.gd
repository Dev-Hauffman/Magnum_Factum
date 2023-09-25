extends Node
class_name QuestionPhrases


const PHRASES:Dictionary = {
	"14": {"phrase": "Theoria automata theoria linguae formali propinqua est.", "size": 1}, #too short
	"12": {"phrase": "Automaton cum finitis civitatibus dicitur Automaton seu Machina finitus.", "size": 1}, #too short #remove size 1?
	"17": {"phrase": "Theoria est in scientia computatrum theoretica cum propinquis nexibus ad logicam mathematicam.", "size": 1},
	"15": {"phrase": "Hoc in contextu automata finita repraesentationum formalium linguarum quae infinitae sint adhibentur.", "size": 1}, # Size ok, almost at the end
	"1": {"phrase": "Alphabetum linguae formalis constat ex symbolis, litteris, vel signis quae in chordas linguae concatenatae sunt.", "size": 1},
	"2": {"phrase": "Theoria linguae formalis e linguisticis orta est, ut modus cognoscendi syntactica regularitates linguarum naturalium.", "size": 1},
	"10": {"phrase": "Automata theoria meditatio est machinarum abstractarum et automata, necnon problematum computationum quae his utentes solvi possunt.", "size": 2},
	"9": {"phrase": "Theoriae linguae formalis campus studet imprimis rationes mere syntacticas talium linguarum, id est earum formarum structurarum internam.", "size": 2},
	"0": {"phrase": "Automata munere funguntur in theoria computationis, constructionis compilatoris, intelligentiae artificialis, verificationis parsis et formalis.", "size": 2},
	"11": {"phrase": "Automata (in plurali automata) est machina computandi sui ipsius propellendi abstracta quae consequentiam praefinitam operationum automatice sequitur.", "size": 2},
	"4": {"phrase": "Lingua formalis saepe definitur per grammaticam formalem sicut grammatica regularis seu grammatica contextus libera, quae ex regula formationis consistit.", "size": 2},
	"5": {"phrase": "In logica, mathematica, computatrum scientia et linguistica, lingua formalis consistit in verbis, quarum litterae ab alphabeto sumuntur et formantur secundum certas regulas.", "size": 2},
	"16": {"phrase": "Automata saepe ex genere linguarum formalium designantur quae agnoscere possunt, sicut in Hierarchia Chomsky, quae nidificationem inter maiores classes automatarias describit.", "size": 2},
	"13": {"phrase": "Cum automaton symbolum initus viderit, transitum facit ad alium statum, secundum suum munus transitus, qui priorem statum et currentem input symbolum accipit ut argumenta sua.", "size": 2},
	"3": {"phrase": "Quaelibet chorda a symbolis huius alphabeti concatenata, verbum dicitur, et verba quae ad linguam formalem particularem pertinent, interdum dicuntur verba bene formatae vel formulae bene formatae.", "size": 2},
	"7": {"phrase": "In multiplicitate computativa theoria, problemata decisionum typice definiuntur linguae formales, et genera multiplicitatis definiuntur ut rationes linguarum formalium quae per machinis cum potentia computativa limitata partiri possunt.", "size": 3},
	"8": {"phrase": "In logicis et mathematicis fundamentis, linguae formales syntaxum systematum axiomaticorum repraesentant, et formalismus mathematica est philosophia quam omnes mathematicae ad syntacticam manipulationem formalium linguarum hoc modo reduci possunt.", "size": 3},
	"6": {"phrase": "In scientia computatrali linguae formales inter alios adhibentur ut fundamentum definiendi grammatica programmandi linguarum et formalizata versiones copiarum linguarum naturalium in quibus verba linguae notiones significant quae cum significationibus vel semanticis coniunguntur.", "size": 3},
}


static func choose_phrase()-> Dictionary:
	var random_number = randi_range(0, PHRASES.size() - 1)
	var chosen_phrase:Dictionary = PHRASES[str(random_number)]
	return chosen_phrase


static func choose_phrase_by_size(target_size:int) -> String:
	var candidates:Array[String] = []
	for phrase in PHRASES:
		var phrase_info:Dictionary = PHRASES[phrase]
		if phrase_info["size"] == target_size:
			candidates.append(phrase_info["phrase"])
	candidates.shuffle()
	return candidates.front()
