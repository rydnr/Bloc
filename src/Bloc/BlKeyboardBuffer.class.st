"
I log all key press events and allow users to detect what keys are pressed at any time.

I allow ===BlKeyboardProcessor=== to sent key still pressed event every frame if there is at least one pressed key
"
Class {
	#name : #BlKeyboardBuffer,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'events'
	],
	#category : #'Bloc-Space-Support'
}

{ #category : #'adding / removing' }
BlKeyboardBuffer >> add: anEvent [
	events at: anEvent key put: anEvent
]

{ #category : #accessing }
BlKeyboardBuffer >> eventAt: aKey [
	<return: #BlKeyDownEvent>
	
	^ events at: aKey
]

{ #category : #accessing }
BlKeyboardBuffer >> events [
	<return: #Collection of: #BlKeyDownEvent>

	^ events values
]

{ #category : #testing }
BlKeyboardBuffer >> hasEvent: aKey [
	"Return true if there is a buffered event for a given key"
	<return: #Boolean>
	
	^ events includesKey: aKey
]

{ #category : #testing }
BlKeyboardBuffer >> hasExactlyAll: aCollectionOfKeys [
	"Return true if the buffer has exactly a collection of given keys"
	<return: #Boolean>
	
	^ events keys asSet = aCollectionOfKeys asSet
]

{ #category : #initialization }
BlKeyboardBuffer >> initialize [
	super initialize.
	
	events := Dictionary new
]

{ #category : #testing }
BlKeyboardBuffer >> isEmpty [
	^ events isEmpty
]

{ #category : #testing }
BlKeyboardBuffer >> isNotEmpty [
	^ events isNotEmpty
]

{ #category : #testing }
BlKeyboardBuffer >> isPressed: aKey [
	"Return true if a given key is pressed, false otherwise"
	<return: #Boolean>

	^ self hasEvent: aKey
]

{ #category : #printing }
BlKeyboardBuffer >> printOn: aStream [

	aStream nextPut: $(.
	events values
		do: [ :anEvent | aStream nextPutAll: anEvent key name asString ]
		separatedBy: [ aStream nextPutAll: ' ' ].
	aStream nextPut: $)
]

{ #category : #'adding / removing' }
BlKeyboardBuffer >> remove: anEvent [
	events removeKey: anEvent key
]
