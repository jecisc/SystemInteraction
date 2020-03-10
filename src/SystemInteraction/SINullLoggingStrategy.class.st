"
Description
--------------------

I am a logger that will not log anything.
"
Class {
	#name : #SINullLoggingStrategy,
	#superclass : #SIAbstractLoggingStrategy,
	#category : #SystemInteraction
}

{ #category : #logging }
SINullLoggingStrategy class >> execute: aBlock loggedAs: aString [
	aBlock value
]

{ #category : #logging }
SINullLoggingStrategy class >> log: aString [
	"Do nothing"
]
