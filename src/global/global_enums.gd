# Class for all global
extends Node
class_name GlobalEnums

enum Stat {
	# Max_Health,
	Walk_Speed,
	Growth_Speed,
	Charisma,
	Luck,
	Money,
}

enum StatModifierType {
	Additive,
	Subtractive,
	Multiplicative,
	Divisive,
	Unknown
}
