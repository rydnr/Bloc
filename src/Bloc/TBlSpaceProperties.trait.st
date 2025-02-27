"
I define interface for accessing space properties such as title, extent, borderless, fullscreen, position.
I must be implemented by all host spaces for window specific implementation.

By using this Trait in both Space and HostSpace we make sure that they have the same uniform API
"
Trait {
	#name : #TBlSpaceProperties,
	#category : #'Bloc-Space'
}

{ #category : #'window - properties' }
TBlSpaceProperties >> borderless [
	"Return true if underlying window is now borderless, false otherwise"
	<return: #Boolean>
	
	^ self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> borderless: aBoolean [
	"Make host window borderless if true is given"

	self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> fullscreen [
	"Return true if an underlying window is in fullscreen mode,
	false otherwise"
	<return: #Boolean>

	^ self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> fullscreen: aBoolean [
	"Switch underlying window to fullscreen if true is given
	and exit fullscreen mode if false is given"

	self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> icon: aForm [
	"Change window's icon to the given one"
	
	self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> position [
	"Return window's position in screen coordinates"
	<return: #Point>
	
	^ self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> position: aPoint [
	"Change window's position to a given point in screen coordinates"
	
	self explicitRequirement

]

{ #category : #'window - properties' }
TBlSpaceProperties >> resizable [
	"Return true if underlying window is resizable, false otherwise"
	<return: #Boolean>

	^ self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> resizable: aBoolean [
	"Make underlying window resizable if true is given"
	
	self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> title [
	"Return window's title as a string"
	<return: #String>

	^ self explicitRequirement
]

{ #category : #'window - properties' }
TBlSpaceProperties >> title: aString [
	"Change window's title"

	self explicitRequirement
]
