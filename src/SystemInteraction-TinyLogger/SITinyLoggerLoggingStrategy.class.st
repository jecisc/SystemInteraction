"
Description
--------------------

I am a logger that will delegate the logging to TinyLogger
"
Class {
	#name : #SITinyLoggerLoggingStrategy,
	#superclass : #SIAbstractLoggingStrategy,
	#category : #'SystemInteraction-TinyLogger'
}

{ #category : #logging }
SITinyLoggerLoggingStrategy class >> execute: aBlock loggedAs: aString [
	self execute: aBlock recordedAs: aString
]

{ #category : #'class initialization' }
SITinyLoggerLoggingStrategy class >> initialize [
	SICommand loggingStrategy: self
]

{ #category : #logging }
SITinyLoggerLoggingStrategy class >> log: aString [
	aString record
]
