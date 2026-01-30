@tool
extends EditorScript

const CSVPATH : String = "res://RawText/StarNames.csv.txt"
const RESPATH : String = "res://Resources/Map/Galaxy/galaxyNameDB.tres"

const DEFAULTWEIGHT : int = 50
const DEFAULTFACTION : String = "generic"
const DEFAULTTAG : String = "generic"

func _run() -> void:
    var csv := FileAccess.get_file_as_string(CSVPATH)
    if csv.is_empty():
        push_error("Galaxy Name CSV missing: %s" %CSVPATH)
        return
    var lines := csv.strip_edges(true, true).split("\n", false)

    var galaxyDB := GalaxyContentDB.new()

    for lineIndex in range(1, lines.size()):
        var line := lines[lineIndex]
        if line == "" or line.begins_with("#"):
            continue
        var splitLine = splitLine(line)

        var id : String = splitLine[0]
        var text : String = splitLine[1]
        var category : String = splitLine[2]
        var factionRaw : String = splitLine[3]
        var tagsRaw : String = splitLine[4]
        var weight : String = splitLine[5]

        var weightInt := int(weight) if weight.is_valid_int() else DEFAULTWEIGHT
        var tags : PackedStringArray = delimitString(tagsRaw, GalaxyContentDB.TAGKEY)
        var factions : PackedStringArray = delimitString(factionRaw)

        ## Factions can duplicate texts. 
        ## Should be fine since / if a faction is used, they will still technically share a portion of the list
        if not galaxyDB.tokens.has(category):
            galaxyDB.tokens[category] = {}
        for faction in factions:
            if not galaxyDB.tokens[category].has(faction):
                galaxyDB.tokens[category][faction] = []
            galaxyDB.tokens[category][faction].append({
                GalaxyContentDB.IDKEY : id,
                GalaxyContentDB.TEXTKEY : text,
                GalaxyContentDB.TAGKEY: tags,
                GalaxyContentDB.WEIGHTKEY: weightInt
            })

    var err := ResourceSaver.save(galaxyDB, RESPATH)
    if err != OK:
        push_error("Failed saving %s (err=%s)" % [RESPATH, str(err)])
    else:
        print("Imported GalaxyNameDB -> " , RESPATH)



        

# Helper function
# Splits each line into an PackedStringArray where each index is id,text,category,faction,tags,weight
func splitLine(line: String) -> PackedStringArray:
    var splitLine := PackedStringArray()
    var currentString := ""
    var i = 0
    while i < line.length():
        var char := line[i]
        if char == ",":
            splitLine.append(currentString)
            currentString = ""
        else:
            currentString += char
        i += 1
    splitLine.append(currentString)
    return splitLine

# Helper function
# Splits values that have | seperators into PackedStringArrays
func delimitString(line : String, type : String = "") -> PackedStringArray:
    var splitStrings := PackedStringArray()
    if line != "":
        for tag in line.split("|", false):
            splitStrings.append(tag)
    elif (type == GalaxyContentDB.TAGKEY):
        splitStrings.append(DEFAULTTAG)
    else:
        splitStrings.append(DEFAULTFACTION)
    return splitStrings
