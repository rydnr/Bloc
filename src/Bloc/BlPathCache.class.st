"
I am responsible for caching backend specific geometry path of the element.
Geometry path is created with the help of backend-specific path builder by BlGeometry
"
Class {
	#name : #BlPathCache,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'session',
		'canvasIdentity',
		'geometry',
		'geometryPath'
	],
	#category : #'Bloc-Basic-Support'
}

{ #category : #'instance creation' }
BlPathCache class >> on: aGeometry [
	^ self new geometry: aGeometry
]

{ #category : #'session management' }
BlPathCache >> checkIdentity: aCanvas [
	canvasIdentity = aCanvas identity
		ifFalse: [ self releaseCache ]
]

{ #category : #'session management' }
BlPathCache >> checkSession [
	session == Smalltalk session
		ifFalse: [
			session := Smalltalk session.
			self releaseCache ]
]

{ #category : #accessing }
BlPathCache >> geometry [
	"Return a geometry whose path I cache"
	<return: #BlGeometry>

	^ geometry
]

{ #category : #accessing }
BlPathCache >> geometry: aBlGeometry [
	"Attach a geometry which path I should cache"

	self
		assert: [ aBlGeometry isNotNil ]
		description: [ 'Geometry must not be nil' ].

	geometry := aBlGeometry
]

{ #category : #accessing }
BlPathCache >> releaseCache [
	"Release path caches requiring their fresh creation"

	geometryPath ifNotNil: #release.
	geometryPath := nil
]
