"
I am an abstract class that defined a common interface for styling strategies.

My subclasses are used by ${class:BlTextStyler}$.
"
Class {
	#name : #BlTextStylerTask,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'styler'
	],
	#category : #'Bloc-Text-Text-Styler'
}

{ #category : #styling }
BlTextStylerTask >> style: aBrText [
	^ self style: aBrText afterDo: [ "do nothing" ]
]

{ #category : #styling }
BlTextStylerTask >> style: aBrText afterDo: aBlock [
	self subclassResponsibility
]

{ #category : #accessing }
BlTextStylerTask >> styler [
	^ styler
]

{ #category : #accessing }
BlTextStylerTask >> styler: anObject [
	styler := anObject
]
