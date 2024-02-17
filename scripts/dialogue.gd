extends Resource

class_name Dialogue

@export var dialogues = []
@export var required_monsters = []
@export var forced_start : Monster = null
#The dialogue is a list of sentences that monsters say to each other, they alternate saying each sentence.
#All required monsters are needed be in a diologue for it to be chosen. (2 max)
#Forced start only has effects if there is a required monster.
#The specified monster will be forced to start the dialogue.
#If there is no preference for who starts the dialogue leave as null
# A dialogue resource must be added to the dialouge array on talkshop object in the shop scene.
