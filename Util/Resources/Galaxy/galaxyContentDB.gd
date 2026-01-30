## Resources for naming of star systems and sectors within the galaxy

extends Resource
class_name GalaxyContentDB

const romanNumerals : Array[String] = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIV", "XV"]

const IDKEY : String = "id"
const TEXTKEY : String = "text"
const TAGKEY : String = "tags"
const WEIGHTKEY : String = "weight"
# tokens[category][faction] is an array of dictionaries
# { "id": String, "text": String, "tags": PackedStringArray, "weight": int }
@export var tokens : Dictionary = {}

