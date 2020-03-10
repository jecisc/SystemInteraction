"
Description
--------------------

I manage the OSX part of the commands.
"
Class {
	#name : #SIMacOsCommand,
	#superclass : #SIUnixCommand,
	#category : #SystemInteraction
}

{ #category : #testing }
SIMacOsCommand class >> isForCurrentPlatform [
	^ OSPlatform current isMacOSX
]
