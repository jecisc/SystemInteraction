Extension { #name : #AbstractFileReference }

{ #category : #'*SystemInteraction' }
AbstractFileReference >> escapedPathForSystemCommand [
	"System commands need escaped path in case they contains some characters such as spaces or parenthesis. I am here to escape them if needed."

	^ self pathString escapedPathForSystemCommand
]
