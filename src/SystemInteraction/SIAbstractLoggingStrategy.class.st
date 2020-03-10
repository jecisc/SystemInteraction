"
Description
--------------------

I am a strategy (from the Strategy Design Pattern) to handle the logging of SystemInteraction actions.
"
Class {
	#name : #SIAbstractLoggingStrategy,
	#superclass : #Object,
	#category : #SystemInteraction
}

{ #category : #logging }
SIAbstractLoggingStrategy class >> execute: aBlock loggedAs: aString [
	self subclassResponsibility
]

{ #category : #logging }
SIAbstractLoggingStrategy class >> log: aString [
	self subclassResponsibility
]
