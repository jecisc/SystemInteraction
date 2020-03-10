Extension { #name : #String }

{ #category : #'*SystemInteraction' }
String >> escapedPathForSystemCommand [
	"System commands need escaped path in case they contains some characters such as spaces or parenthesis. I am here to escape them if needed.

	'C:\path with space\file' ==> '""C:\path with space\file""'
	'C:\pathWithoutSpace\file' ==> 'C:\pathWithoutSpace\file'
	"

	^ (self includesAny: {Character space . $( . $)})
		ifTrue: [ self surroundedByDoubleQuotes ]
		ifFalse: [ self ]
]
