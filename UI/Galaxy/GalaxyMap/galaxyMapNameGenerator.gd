## Uses GalaxyNameDB resource file from imported tool to generate names for star systems
extends Node
class_name GalaxyMapNameGenerator

# --- Patterns ---
# Token keys:
# N=proper_name, A=abstract, P=place_noun, E=event_noun, S=structure, D=descriptor, ADJ=adjective, NUM=generated designation, ROM=roman numeral
const PATTERNS := [
{"format" : "{A} {P}", "weight" : 45},
{"format" : "{ADJ} {P}", "weight" : 25},
{"format" : "{N} {P}", "weight" : 18},
{"format" : "{A} {S}", "weight" : 10},
{"format" : "{P} of {A}", "weight" : 8},
{"format" : "{P} of {N}", "weight" : 6},
{"format" : "{E} of {N}", "weight" : 5},
{"format" : "{N:poss} {E}", "weight" : 4},
{"format" : "{N:poss} {P}", "weight" : 3},
{"format" : "{A} {P} {NUM}", "weight" : 6},
{"format" : "{S} {NUM}", "weight" : 4}
]

var nameDB : GalaxyContentDB = preload("res://Resources/Map/Galaxy/galaxyNameDB.tres")

var rng := RandomNumberGenerator.new()

func setSeed(seed : int) -> void:
    rng.seed = seed

func generateStarName() -> String:
    var format : String = pickPattern()
   # var result : String = resolvePattern()
    
    return "Unnamed"

func resolvePattern(format : String) -> String:

    while format.find("{") != -1:
        var start := format.find("{")
        var end := format.find("}")

        var pattern := format.substr(start + 1, end - start - 1) ## Returns the pattern without the brackets
        var replacement := replacePattern(pattern)
    var firstPatternStart = format.find("{")
    var firstPatternEnd = format.find("}")

    format = format.remove_char("{".unicode_at(0))
    format = format.remove_char("}".unicode_at(0))

    return ""

func pickPattern() -> String:
    var totalWeight : int = 0
    for pattern in PATTERNS:
        totalWeight += int(pattern.get("weight"))
    var roll := rng.randi_range(1, totalWeight)
    var cumulativeWeight : int = 0
    for pattern in PATTERNS:
        cumulativeWeight += pattern.get("weight")
        if roll <= cumulativeWeight:
            return pattern.get("format")
    return PATTERNS[0].get("format")

func replacePattern(pattern : String) -> String:
    var patternSplit := pattern.split(":", false) ## For modifiers like N:poss
    var mainToken := patternSplit[0]
    var modToken := patternSplit[1] if patternSplit.size() > 1 else ""

    match mainToken:
        "N":
            var name := pickName("proper_name")
            return applyModifier(name, modToken)
        "A":
            return pickName("abstract")
        "P":
            return pickName("place_noun")
        "E":
            return pickName("event_noun")
        "S":
            return pickName("structure")
        "D":
            return pickName("descriptor")
        "ADJ":
            return pickName("adjective")
        "NUM":
            return "1"
    return ""



func pickName(tokenCategory : String) -> String:
    return ""

func applyModifier(token : String, modifier : String) -> String:
    return ""