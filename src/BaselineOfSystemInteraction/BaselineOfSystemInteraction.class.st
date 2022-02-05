"
I am a baseline to define the structure and dependencies of the SystemInteraction project.
"
Class {
	#name : #BaselineOfSystemInteraction,
	#superclass : #BaselineOf,
	#category : #BaselineOfSystemInteraction
}

{ #category : #baseline }
BaselineOfSystemInteraction >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Dependencies"
			self
				osSubProcess: spec;
				osWinSubProcess: spec;
				tinyLogger: spec.

			"Packages"
			spec
				package: 'SystemInteraction' with: [ spec requires: #('OSSubprocess' 'OSWinSubprocess') ];
				package: 'SystemInteraction-TinyLogger' with: [ spec requires: #('SystemInteraction' 'TinyLogger') ].

			"Groups"
			spec
				group: 'default' with: #('Core');
				group: 'Core' with: #('SystemInteraction');
				group: 'TinyLoggerIntegration' with: #('SystemInteraction-TinyLogger') ]
]

{ #category : #dependencies }
BaselineOfSystemInteraction >> osSubProcess: spec [
	spec
		baseline: 'OSSubprocess'
		with: [ spec
				loads: 'Core';
				repository: 'github://pharo-contributions/OSSubprocess:master/repository' ]
]

{ #category : #dependencies }
BaselineOfSystemInteraction >> osWinSubProcess: spec [
	spec
		baseline: 'OSWinSubprocess' with: [
			spec repository: 'github://pharo-contributions/OSWinSubprocess:v1/repository' ]
]

{ #category : #accessing }
BaselineOfSystemInteraction >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfSystemInteraction >> tinyLogger: spec [
	spec
		baseline: 'TinyLogger'
		with: [ spec
				loads: #('Core');
				repository: 'github://jecisc/TinyLogger:v1.x.x/src' ]
]
