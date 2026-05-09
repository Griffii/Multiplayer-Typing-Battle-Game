# res://scripts/data/dialogue/dialogue_sequence_data.gd
class_name DialogueSequenceData
extends Resource

@export var id: String = ""
@export var speakers: Array[DialogueSpeakerData] = []
@export var lines: Array[DialogueLineData] = []

func get_speaker(speaker_id: String) -> DialogueSpeakerData:
	for speaker in speakers:
		if speaker.speaker_id == speaker_id:
			return speaker
	
	push_warning("Dialogue speaker not found: " + speaker_id)
	return null
