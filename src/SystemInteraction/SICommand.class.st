"
Description
--------------------

I provide a homogeneous api to execute OS commands or scripts. The api is the same for any of Windows, Linux, Mac operating systems.

I provides a hook if the user wish to log the executed command by letting one configure a LoggingStrategy. This strategy should be a subclass of SIAbstractLoggingStrategy.

Public API and Key Messages
--------------------

- #executeCommand: 		Execute a command in a non blocking way
- #waitForCommand: 		Execute a blocking command and return the result
- #executeScript: 			Execute a script

Examples
--------------------
	
	SICommand default
		executeCommand: 'sass'
		arguments:
			{(self sassFolderName , '/' , self cssName , '.sass').
			(self sassFolderName , '/' , self cssName , '.css').
			'--style=compressed'}
 
"
Class {
	#name : #SICommand,
	#superclass : #Object,
	#classVars : [
		'LoggingStrategy'
	],
	#classInstVars : [
		'default'
	],
	#category : #SystemInteraction
}

{ #category : #'instance creation' }
SICommand class >> default [
	^ default ifNil: [ default := self defaultClass new ]
]

{ #category : #'instance creation' }
SICommand class >> defaultClass [
	^ self allSubclasses detect: #isForCurrentPlatform
]

{ #category : #services }
SICommand class >> executeCommand: aString [
	"Execute a single command without argument passed as parameter"

	^ self default executeCommand: aString
]

{ #category : #services }
SICommand class >> executeCommand: aString arguments: aCollection [
	"Execute a single command with argument passed as parameter"

	^ self default executeCommand: aString arguments: aCollection
]

{ #category : #services }
SICommand class >> executeScript: aString [
	"The parameter is expected to represent the contents of a script file for the current operating system (.sh files for unix, .cmd files for windows).
A script file will be writen with this contents,
and will be call through a command line."

	^ self default executeScript: aString
]

{ #category : #services }
SICommand class >> executeScript: aString silently: aBoolean [
	"The parameter is expected to represent the contents of a script file for the current operating system (.sh files for unix, .cmd files for windows).
A script file will be writen with this contents,
and will be call through a command line."
	^ self  default executeScript: aString silently: aBoolean
]

{ #category : #services }
SICommand class >> executeScriptFile: aFilReference silently: aBoolean [
	"The parameter is expected to represent  a script file for the current operating system (.sh files for unix, .cmd files for windows)."
	
	^ self default executeScriptFile: aFilReference silently: aBoolean
]

{ #category : #'class initialization' }
SICommand class >> initialize [
	Smalltalk addToStartUpList: self.
	self loggingStrategy: SINullLoggingStrategy
]

{ #category : #testing }
SICommand class >> isForCurrentPlatform [
	^ self subclassResponsibility
]

{ #category : #accessing }
SICommand class >> loggingStrategy [
	^ LoggingStrategy
]

{ #category : #accessing }
SICommand class >> loggingStrategy: anObject [
	LoggingStrategy := anObject
]

{ #category : #'instance creation' }
SICommand class >> resetDefault [

	default := nil
]

{ #category : #accessing }
SICommand class >> scriptExtension [
	^ self subclassResponsibility
]

{ #category : #'kill signal' }
SICommand class >> startUp: booting [
	booting ifFalse: [ ^ self ].

	"we reinitialize the default instance each time we restart the image in case the OS has changed"
	self resetDefault
]

{ #category : #'as yet unclassified' }
SICommand class >> systemInteractionResourcesFolder [
	^ 'SystemInteractionResources' asFileReference ensureCreateDirectory
]

{ #category : #services }
SICommand class >> waitForCommand: aString [
	"Execute a single command without argument and wait for execution to finish"

	^ self default waitForCommand: aString
]

{ #category : #services }
SICommand class >> waitForCommand: aString arguments: aCollection [
	"Execute a single command with arguments and wait for execution to finish"
	
	^ self default waitForCommand: aString arguments: aCollection
]

{ #category : #services }
SICommand class >> waitForCommand: aString arguments: aCollection silently: aBoolean [
	"Execute a single command with arguments passed as parameter and wait for the exit."

	^ self default waitForCommand: aString arguments: aCollection silently: aBoolean
]

{ #category : #services }
SICommand class >> waitForCommand: aString silently: aBoolean [
	"Execute a single command without argument passed as parameter and wait for the exit."

	^ self default waitForCommand: aString silently: aBoolean
]

{ #category : #'services - file operations' }
SICommand >> copyAll: inputDirectoryFileReference to: targetDirectoryFileReference [
	^ self subclassResponsibility
]

{ #category : #'services - file operations' }
SICommand >> deleteAll: inputDirectoryFileReference [
	^ self subclassResponsibility
]

{ #category : #services }
SICommand >> executeCommand: aString [
	"Execute a single command without argument passed as parameter"

	self executeCommand: aString arguments: #()
]

{ #category : #services }
SICommand >> executeCommand: aString arguments: aCollection [
	"Execute a single command with arguments passed as parameter"

	self loggingStrategy
		execute: [ self privateExecuteCommand: aString arguments: aCollection ]
		recordedAs: 'Execute command: ' , (self joinCommand: aString withArguments: aCollection)
]

{ #category : #services }
SICommand >> executeScript: aString [
	"The parameter is expected to represent the contents of a script file for the current operating system (.sh files for unix, .cmd files for windows).
A script file will be writen with this contents, and will be call through a command line."

	^ self executeScript: aString silently: false
]

{ #category : #services }
SICommand >> executeScript: aString silently: aBoolean [
	"The parameter is expected to represent the contents of a script file for the current operating system (.sh files for unix, .cmd files for windows).
A script file will be writen with this contents,
and will be call through a command line."

	| result |
	self loggingStrategy log: 'Execute script: ' , aString.
	result := self privateExecuteScript: aString.
	self loggingStrategy
		log: (aBoolean ifTrue: [ 'Script execution complete.' ] ifFalse: [ 'Script executed with result: ' , result asString ifEmpty: [ 'No result' ] ]).
	^ result
]

{ #category : #services }
SICommand >> executeScriptFile: aFilReference silently: aBoolean [
	"The parameter is expected to represent  a script file for the current operating system (.sh files for unix, .cmd files for windows)."

	| result |
	self loggingStrategy execute: [ result := self privateExecuteScriptFile: aFilReference ] loggedAs: 'Execute file: ' , aFilReference pathString.

	aBoolean ifFalse: [ self loggingStrategy log: ('Result: ' , result asString ifEmpty: [ 'No result' ]) ].
	^ result
]

{ #category : #private }
SICommand >> joinCommand: aString withArguments: aCollection [
	^ String
		streamContents: [ :s | 
			s nextPutAll: aString.
			aCollection
				do: [ :arg | 
					s
						space;
						nextPutAll: arg ] ]
]

{ #category : #accessing }
SICommand >> loggingStrategy [
	^ self class loggingStrategy
]

{ #category : #private }
SICommand >> privateExecuteCommand: aString arguments: aCollection [
	"Execute a command, do not wait for the execution and return the result"

	^ self subclassResponsibility
]

{ #category : #private }
SICommand >> privateExecuteScript: aString [
	"The parameter is a script that should be executable on the current OS (bach on unix, batch on windows).
	A script file will be writen with this contents, and will be call through a command line."

	| scriptFile result |
	scriptFile := (FileLocator temp asFileReference / (UUID new printString , self scriptExtension))
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: aString ];
		yourself.
	result := self privateExecuteScriptFile: scriptFile.
	scriptFile delete.
	^ result
]

{ #category : #private }
SICommand >> privateExecuteScriptFile: aFileReference [
	"The parameter should be a file script executable for the current OS (bach on unix, batch on windows). I will execute this file."

	^ self subclassResponsibility
]

{ #category : #private }
SICommand >> privateSilentWaitForCommand: aString arguments: aCollection [
	"Execute a command and wait for the execution."

	^ self privateWaitForCommand: aString arguments: aCollection
]

{ #category : #private }
SICommand >> privateWaitForCommand: aString arguments: aCollection [
	"Execute a command, wait for the execution and return the result"

	^ self subclassResponsibility
]

{ #category : #accessing }
SICommand >> scriptExtension [
	^ self class scriptExtension
]

{ #category : #accessing }
SICommand >> systemInteractionResourcesFolder [
	^ self class systemInteractionResourcesFolder
]

{ #category : #'services - file operations' }
SICommand >> unzip: anArchive to: targetDirectory [
	^ self subclassResponsibility
]

{ #category : #services }
SICommand >> waitForCommand: aString [
	"Execute a single command and wait for execution to finish"

	^ self waitForCommand: aString silently: false
]

{ #category : #services }
SICommand >> waitForCommand: aString arguments: aCollection [
	"Execute a single command and wait for execution to finish"

	^ self waitForCommand: aString arguments: aCollection silently: false
]

{ #category : #services }
SICommand >> waitForCommand: aString arguments: aCollection silently: aBoolean [
	"Execute a single command passed as parameter and wait for the exit."

	| result |
	self loggingStrategy
		execute: [ aBoolean
				ifTrue: [ self privateSilentWaitForCommand: aString arguments: aCollection ]
				ifFalse: [ result := self privateWaitForCommand: aString arguments: aCollection ] ]
		loggedAs: 'Execute command: ' , (self joinCommand: aString withArguments: aCollection).

	aBoolean ifFalse: [ self loggingStrategy trace: ('Result: ' , result asString ifEmpty: [ 'No result' ]) ].
	^ result
]

{ #category : #services }
SICommand >> waitForCommand: aString silently: aBoolean [
	"Execute a single command passed as parameter and wait for the exit."

	^ self waitForCommand: aString arguments: #() silently: aBoolean
]

{ #category : #'services - file operations' }
SICommand >> zip: aCollectionOfFilesOrPath to: aZipArchiveName [
	^ self subclassResponsibility
]
