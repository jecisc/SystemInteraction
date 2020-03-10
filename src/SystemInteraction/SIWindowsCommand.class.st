"
Description
--------------------

I manage the Windows part of the commands.
"
Class {
	#name : #SIWindowsCommand,
	#superclass : #SICommand,
	#category : #SystemInteraction
}

{ #category : #testing }
SIWindowsCommand class >> isForCurrentPlatform [
	^ OSPlatform current isWindows
]

{ #category : #accessing }
SIWindowsCommand class >> scriptExtension [
	^ '.bat'
]

{ #category : #'services - file operations' }
SIWindowsCommand >> copyAll: inputDirectoryFileReference to: targetDirectoryFileReference [
	"We add a \ character at the end of the target path, so that xcopy does not prompt the user (is it a file or a directory ?)
	The /Y allows to force overwrite"

	^ self
		waitForCommand: 'xcopy'
		arguments: {'/E' . '/Y' . inputDirectoryFileReference asAbsolute escapedPathForSystemCommand . (targetDirectoryFileReference asAbsolute pathString , '\') escapedPathForSystemCommand}
]

{ #category : #'services - file operations' }
SIWindowsCommand >> deleteAll: inputDirectoryFileReference [
	^ self waitForCommand: 'rd' arguments: {'/s' . '/q' . inputDirectoryFileReference asAbsolute escapedPathForSystemCommand}
]

{ #category : #private }
SIWindowsCommand >> privateExecuteCommand: aString arguments: aCollection [
	^ OSWSWinProcess new
		command: aString;
		arguments: aCollection;
		run
]

{ #category : #private }
SIWindowsCommand >> privateExecuteScriptFile: aFileReference [
	^ self waitForCommand: aFileReference asAbsolute escapedPathForSystemCommand
]

{ #category : #private }
SIWindowsCommand >> privateWaitForCommand: aString arguments: aCollection [
	^ LibC resultOfCommand: (self joinCommand: aString withArguments: aCollection)
]
