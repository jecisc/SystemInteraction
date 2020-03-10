"
Description
--------------------

I am a logger that will record everything on a Transcript
"
Class {
	#name : #SITranscriptsLoggingStrategy,
	#superclass : #SIAbstractLoggingStrategy,
	#category : #SystemInteraction
}

{ #category : #logging }
SITranscriptsLoggingStrategy class >> execute: aBlock loggedAs: aString [
	self log: 'Begin: ' , aString.
	aBlock cull: aString.
	self log: 'End: ' , aString
]

{ #category : #logging }
SITranscriptsLoggingStrategy class >> log: aString [
	aString traceCr
]
