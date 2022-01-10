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
	^ self waitForCommand: 'cp' arguments: {'-R' . inputDirectoryFileReference asAbsolute escapedPathForSystemCommand . targetDirectoryFileReference asAbsolute escapedPathForSystemCommand}
]

{ #category : #'services - file operations' }
SIUnixCommand >> deleteAll: inputDirectoryFileReference [
	^ self waitForCommand: 'rm' arguments: {'-rf' . inputDirectoryFileReference escapedPathForSystemCommand}
]

{ #category : #private }
SIUnixCommand >> privateExecuteCommand: aString arguments: aCollection [
	OSSUnixSubprocess new
		shellCommand: (self joinCommand: aString withArguments: aCollection);
		addAllEnvVariablesFromParentWithoutOverride;
		run
]

{ #category : #private }
SIUnixCommand >> privateExecuteScriptFile: aFileReference [
	^ self waitForCommand: 'sh' arguments: {aFileReference asAbsolute escapedPathForSystemCommand}
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
		addAllEnvVariablesFromParentWithoutOverride;
		runAndWaitPollingEvery: (Delay forMilliseconds: 50) retrievingStreams: true onExitDo: [ :process :out :err | ^ out ]
]

{ #category : #'services - file operations' }
SIUnixCommand >> unzip: anArchive to: targetDirectory [
	^ self waitForCommand: 'unzip' arguments: { '--quiet'. '-o' . anArchive escapedPathForSystemCommand . '-d' . targetDirectory escapedPathForSystemCommand}
]

{ #category : #'services - file operations' }
SIUnixCommand >> zip: aCollectionOfFilesOrPath to: aZipArchiveName [
	| arguments |
	arguments := OrderedCollection with: '-roq' with: aZipArchiveName.
	arguments addAll: (aCollectionOfFilesOrPath collect: #escapedPathForSystemCommand).

	self waitForCommand: 'zip' arguments: arguments asArray silently: true
]
