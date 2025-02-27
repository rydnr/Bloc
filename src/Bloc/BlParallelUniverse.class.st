"
I am a parallel Universe. There can exist multiple parallel universes
"
Class {
	#name : #BlParallelUniverse,
	#superclass : #Object,
	#traits : 'TBlEventTarget',
	#classTraits : 'TBlEventTarget classTrait',
	#instVars : [
		'deferredActions',
		'eventDispatcher',
		'hostClass',
		'spaceManager',
		'pulsingStateMutex',
		'isPulsing'
	],
	#classVars : [
		'Universes'
	],
	#category : #'Bloc-Universe - Parallel'
}

{ #category : #accessing }
BlParallelUniverse class >> all [
	"Return a collection of all parallel universes"
	
	^ Universes
]

{ #category : #'instance creation' }
BlParallelUniverse class >> existsForHost: aHostClass [
	^ Universes
		detect: [ :eachUniverse | eachUniverse hostClass = aHostClass ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #'instance creation' }
BlParallelUniverse class >> forHost: aHostClass [
	^ Universes
		detect: [ :eachUniverse | eachUniverse hostClass = aHostClass ]
		ifFound: #yourself
		ifNone: [
			| aUniverse |
			aUniverse := self new hostClass: aHostClass.
			Universes := Universes copyWith: aUniverse.
			aUniverse ]
]

{ #category : #'instance creation' }
BlParallelUniverse class >> glutin [
	<blocHost>

	^ self forHost: BlGlutinHost
]

{ #category : #'class initialization' }
BlParallelUniverse class >> initialize [
	Universes := #()
]

{ #category : #'instance creation' }
BlParallelUniverse class >> morphic [
	<blocHost>

	^ self forHost: BlMorphicHost
]

{ #category : #'api - spaces' }
BlParallelUniverse >> closeSpace: aSpace [
	"It should be possible to close a space from the other thread"

	self
		assert: [ aSpace isNotNil ]
		description: [ 'Space must not be nil' ].

	"If space is not event opened we should do nothing"
	aSpace isOpened
		ifFalse: [ ^ self ].
	
	"first remove space itself from space manager, to break any recursions"
	spaceManager removeSpace: aSpace.

	"then destroy host space"
	aSpace hasHostSpace
		ifTrue: [ aSpace host destroyHostSpaceFor: aSpace ].
	
	
	"Notify root element that it is no longer in scene graph"
	aSpace root dispatchRemovedFromSceneGraph.
	"Send space closed event.
	Note: a new space may be spawned as a reaction to the event, that is why
	we send it before stopping host and universe"
	aSpace dispatchEvent: (BlSpaceClosedEvent new space: aSpace).

	self
		assert: [ aSpace hasHostSpace not ]
		description: [ 'Host space must not have a host!' ].

	"as the last step we may want to stop the host. It may terminate
	the current process, so we should do it at last"
	(spaceManager hasSpaces not and: [ aSpace host isRunning ])
		ifTrue: [ aSpace host stop ].
]

{ #category : #'api - spaces' }
BlParallelUniverse >> closeSpaces [
	self spaces copy do: [ :aSpace | self closeSpace: aSpace ]
]

{ #category : #initialization }
BlParallelUniverse >> defaultEventDispatcher [
	^ BlDirectEventDispatcher on: self
]

{ #category : #initialization }
BlParallelUniverse >> defaultEventListener [
	^ BlUniverseEventListener new
]

{ #category : #'api - ui process' }
BlParallelUniverse >> defer: aValuable [
	"#defer: can be used from any thread to execute a valuable in the GUI thread
	You can use it to update the GUI states from any other thread.
	The valuable will be evaluated as soon as possible."

	deferredActions nextPut: aValuable
]

{ #category : #'event management accessing' }
BlParallelUniverse >> eventDispatcher [
	"Return an object responsible for event dispatching"
	<return: #BlDirectEventDispatcher>

	^ eventDispatcher
]

{ #category : #'api - spaces' }
BlParallelUniverse >> hasSpace: aSpace [
	"Return true if a given space is registered, false otherwise"
	<return: #Boolean>
	
	^ spaceManager hasSpace: aSpace
]

{ #category : #'api - spaces' }
BlParallelUniverse >> hasSpaces [
	"Return true if there are registered spaces, false otherwise"
	<return: #Boolean>

	^ spaceManager hasSpaces
]

{ #category : #'api - ui process' }
BlParallelUniverse >> hasUIProcess [
	self uiProcessDo: [ :aUIProcess | ^ true ].
	^ false
]

{ #category : #accessing }
BlParallelUniverse >> hostClass [
	^ hostClass
]

{ #category : #accessing }
BlParallelUniverse >> hostClass: aHostClass [
	hostClass := aHostClass
]

{ #category : #initialization }
BlParallelUniverse >> initialize [
	super initialize.

	spaceManager := BlSpaceManager new.
	hostClass := BlHeadlessHost.
	deferredActions := WaitfreeQueue new.
	pulsingStateMutex := Mutex new.
	isPulsing := false.

	eventDispatcher := self defaultEventDispatcher.
	self addEventHandler: self defaultEventListener
]

{ #category : #accessing }
BlParallelUniverse >> isPulsing [
	<return: #Boolean>
	| areWePulsing |
	
	areWePulsing := false.
	pulsingStateMutex critical: [ areWePulsing := isPulsing ].
	^ areWePulsing
]

{ #category : #'api - spaces' }
BlParallelUniverse >> openSpace: aSpace [
	"It should be possible to add a space from the other thread"
		
	self defer: [ self openSpaceSynchronously: aSpace ].
	
	aSpace host isRunning
		ifFalse: [ aSpace host start ]
]

{ #category : #'private - spaces' }
BlParallelUniverse >> openSpaceSynchronously: aSpace [

	self
		assert: [ aSpace isNotNil ]
		description: [ 'Space must not be nil' ].

	aSpace isOpened
		ifTrue: [ ^ self ].

	self
		assert: [ aSpace hasHostSpace not ]
		description: [ 'Space must not have a host space!' ].

	self
		assert: [ aSpace host isNotNil ]
		description: [ 'Space must have a host' ].
		
	"First of all we need to add space to the space manager"
	spaceManager addSpace: aSpace.

	"then create and show it in a host space"
	aSpace host createHostSpaceFor: aSpace.
	aSpace hostSpace show.

	self
		assert: [ aSpace hasHostSpace ]
		description: [ 'Space must have a host!' ].
		
	"Note: we should send shown event after everything else is done, because
	theoretically, that only space could be closed as a reaction to the event"
	aSpace dispatchEvent: (BlSpaceShownEvent new space: self).
	
	"Notify root element that it is now visible to the user"
	aSpace root space: aSpace.
	aSpace root dispatchAddedToSceneGraph
]

{ #category : #pulse }
BlParallelUniverse >> pulse [
	self isPulsing
		ifTrue: [ ^ self ].

	pulsingStateMutex critical: [ isPulsing := true ].

	[
		self pulseSynchronously
	] ensure: [ pulsingStateMutex critical: [ isPulsing := false ] ]
]

{ #category : #'private - spaces' }
BlParallelUniverse >> pulseSynchronously [

	"deferred actions must be run before spaces"
	self tryToRunDeferredActions.

	spaceManager do: [ :eachSpace | eachSpace pulse ]
]

{ #category : #'api - spaces' }
BlParallelUniverse >> spaces [
	<return: #Collection of: #BlSpace>

	^ spaceManager spaces
]

{ #category : #'private - spaces' }
BlParallelUniverse >> stopPulsation [
	pulsingStateMutex critical: [ isPulsing := false ]
]

{ #category : #'deferred message' }
BlParallelUniverse >> tryToRunDeferredActions [
	| nextInQueue |
	
	[ (nextInQueue := deferredActions nextOrNil) isNotNil ]
		whileTrue: [ nextInQueue value ]
]

{ #category : #'api - ui process' }
BlParallelUniverse >> uiProcessDo: aBlock [
	self hostClass uiProcessDo: aBlock
]
