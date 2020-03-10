"
Description
--------------------

I manage the Unix part of the commands.
"
Class {
	#name : #SIUnixCommand,
	#superclass : #SICommand,
	#category : #SystemInteraction
}

{ #category : #testing }
SIUnixCommand class >> isForCurrentPlatform [
	^ OSPlatform current isMacOS not and: [ OSPlatform current isUnix ]
]

{ #category : #accessing }
SIUnixCommand class >> scriptExtension [
	^ '.sh'
]

{ #category : #'services - file operations' }
SIUnixCommand >> copyAll: inputDirectoryFileReference to: targetDirectoryFileReference [
	^ self waitForCommand: 'cp' arguments: {'-R' . inputDirectoryFileReference asAbsolute escapePathForSystemCommand . targetDirectoryFileReference asAbsolute escapePathForSystemCommand}
]

{ #category : #'services - file operations' }
SIUnixCommand >> deleteAll: inputDirectoryFileReference [
	^ self waitForCommand: 'rm' arguments: {'-rf' . inputDirectoryFileReference asAbsolute escapePathForSystemCommand}
]

{ #category : #private }
SIUnixCommand >> privateExecuteCommand: aString arguments: aCollection [
	OSSUnixSubprocess new
		shellCommand: (self joinCommand: aString withArguments: aCollection);
		run
]

{ #category : #private }
SIUnixCommand >> privateExecuteScriptFile: aFileReference [
	^ self waitForCommand: 'sh' arguments: {aFileReference asAbsolute escapePathForSystemCommand}
]

{ #category : #private }
SIUnixCommand >> privateSilentWaitForCommand: aString arguments: aCollection [
	"Just call the method returning the output and ignore it."

	self privateWaitForCommand: aString arguments: aCollection
]

{ #category : #private }
SIUnixCommand >> privateWaitForCommand: aString arguments: aCollection [
	OSSUnixSubprocess new
		shellCommand: (self joinCommand: aString withArguments: aCollection);
		redirectStdout;
		redirectStderr;
		runAndWaitPollingEvery: (Delay forMilliseconds: 50) retrievingStreams: true onExitDo: [ :process :out :err | ^ out ]
]