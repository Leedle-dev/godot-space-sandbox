class_name SizeClass
extends Resource

# A simple resource to keep track of the size class for a given ship.
# Since we know our ships classes and nothing will be randomly created, this can safely be established as resources and just pulled from in ship design.
# EG. size = "Medium" sizeAbbreviation = "M"
enum sizes {EXTRA_SMALL, SMALL, MEDIUM, LARGE, EXTRA_LARGE, EXTREMELY_LARGE}
enum sizeAbbreviations {XS, S, M, L, XL, XXL}


@export var size : sizes
@export var sizeAbbreviation : sizeAbbreviations
