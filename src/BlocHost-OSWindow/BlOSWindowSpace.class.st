"
I am a concrete implementation of a BlHostSpace.
My responsibility is to control OSWindow window using unified host space api.
"
Class {
	#name : #BlOSWindowSpace,
	#superclass : #Object,
	#traits : 'TBlHostSpace',
	#classTraits : 'TBlHostSpace classTrait',
	#instVars : [
		'window',
		'renderer',
		'eventFetcher',
		'osWindowRenderer',
		'keyboardKeyTable'
	],
	#category : #'BlocHost-OSWindow-Host'
}

{ #category : #'host space - accessing' }
BlOSWindowSpace >> borderless [
	^ self windowDo: [ :aWindow | aWindow borderless ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> borderless: aBoolean [
	self windowDo: [ :aWindow | aWindow borderless: aBoolean ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> canvasExtent [
	"Return a window canvas size in user coordinates.
	This size may differ from the window size on high dpi (retina) screens.
	In most cases canvas is x2 larger than window in pixel on retina screens."
	<return: #Point>
	
	^ self windowDo: [ :aWindow | aWindow canvasExtent ]
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> close [
	
	self isValid
		ifTrue: [ self windowDo: [ :aWindow | aWindow destroy ] ].
	window := nil
]

{ #category : #'host space - cursor' }
BlOSWindowSpace >> cursor: aCursor [
	self windowDo: [ :aWindow | aWindow setMouseCursor: aCursor ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> densityDpi [
	"Return the screen density expressed as dots-per-inch"
	<return: #Number>
	
	^ 96.0
]

{ #category : #private }
BlOSWindowSpace >> ensureWindowIsValid [
	"Native windows are external objects and they are destroyed when pharo is closed.
	This may happen when a user saves and quits an image while there are open Bloc spaces.
	We want those window to re-open when user open a saved Pharo image"
	
	self isValid
		ifTrue: [ ^ self ].
		
	renderer initializeHostSpace: self
]

{ #category : #'host space - events' }
BlOSWindowSpace >> fetchedEventsDo: aBlock [
	"Flush event queue and evaluate a given block with every queued event as argument"
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> fullscreen [
	"Return true if an underlying window is in fullscreen mode,
	false otherwise"
	<return: #Boolean>

	^ self windowDo: [ :aWindow | aWindow fullscreen ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> fullscreen: aBoolean [
	"Switch underlying window to fullscreen if true is given
	and exit fullscreen mode if false is given"

	self windowDo: [ :aWindow | aWindow fullscreen: aBoolean ]
]

{ #category : #'host space - events' }
BlOSWindowSpace >> generateEvents [
	"Generate more complex state change events such as window scale event when resolution of the screen changes"
	
	self hasScaled
		ifTrue: [ self enqueueEvent: (BlSpaceScaledEvent new timestamp: self space time now) ]
]

{ #category : #'as yet unclassified' }
BlOSWindowSpace >> hide [
	self windowDo: [ :aWindow | aWindow hide ]
]

{ #category : #initialization }
BlOSWindowSpace >> initialize [
	super initialize.
	
	eventFetcher := BlHostEventFetcher new
]

{ #category : #initialization }
BlOSWindowSpace >> initializeForBuffer: aBufferSurface [
	"Asks host space to initialize itself to be used together with a pixel buffer surface.
	Default implementation simply connects renderer, host space and surface together"

	self initializeWithAttributes: (self host createAttributesFor: self space).

	aBufferSurface hostSpace: self.
	aBufferSurface hostRenderer: self renderer.

	self renderer surface: aBufferSurface.
	window newBlocRenderer surface: aBufferSurface
]

{ #category : #initialization }
BlOSWindowSpace >> initializeForForm: anFormSurface [
	"Asks host space to initialize itself to be used together with a Form surface.
	Default implementation simply connects renderer, host space and surface together"
	
	self initializeWithAttributes: (self host createAttributesFor: self space).
	
	anFormSurface hostSpace: self.
	anFormSurface hostRenderer: self renderer.

	self renderer surface: anFormSurface.
	window newBlocRenderer surface: anFormSurface
]

{ #category : #initialization }
BlOSWindowSpace >> initializeForOpenGL: anOpenGLSurface [
	"Asks host space to initialize itself to be used together with an OpenGL surface.
	Default implementation simply connects renderer, host space and surface together"
	| glAttributes |
	
	glAttributes := OSWindowGLAttributes new.
	glAttributes redSize: 8.
	glAttributes greenSize: 8.
	glAttributes blueSize: 8.
	glAttributes stencilSize: 8.
	
	self initializeWithAttributes: ((self host createAttributesFor: self space) glAttributes: glAttributes).

	anOpenGLSurface hostSpace: self.
	anOpenGLSurface hostRenderer: self renderer.

	self renderer surface: anOpenGLSurface.
	window newBlocRenderer surface: anOpenGLSurface
]

{ #category : #initialization }
BlOSWindowSpace >> initializeWithAttributes: initialAttributes [
	window := OSWindow createWithAttributes: initialAttributes.
	window eventHandler: ((BlOSWindowEventHandler window: self) keyboardKeyTable: keyboardKeyTable).
	window startTextInput
]

{ #category : #testing }
BlOSWindowSpace >> isValid [
	^ window isNotNil and: [ window isValid ]
]

{ #category : #'host space - testing' }
BlOSWindowSpace >> isVisible [
	"Return true if underlying window is shown, false otherwise.
	Note: If window was shown and then minimized it is still considered to be visible.
	Window can become invisible by asking it to hide"
	<return: #Boolean>

	^ self windowDo: [ :aWindow | aWindow isVisible ]
]

{ #category : #private }
BlOSWindowSpace >> keyboardKeyTable: aKeyboardKeyTable [
	keyboardKeyTable := aKeyboardKeyTable
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> maximize [
	self windowDo: [ :aWindow | aWindow maximize ]
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> maximized [
	^ self windowDo: [ :aWindow | aWindow maximized ]
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> minimize [
	self windowDo: [ :aWindow | aWindow minimize ]
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> minimized [
	^ self windowDo: [ :aWindow | aWindow minimized ]
]

{ #category : #'host space - testing' }
BlOSWindowSpace >> needsRebuild [
	"Return true if window should be recreated after user saved and quit pharo"
	<return: #Boolean>
	
	^ self isValid not
]

{ #category : #'as yet unclassified' }
BlOSWindowSpace >> open [
	self windowDo: [ :aWindow | aWindow show ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> position [
	^ self windowDo: [ :aWindow | aWindow position ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> position: aPoint [
	self windowDo: [ :aWindow | aWindow position: aPoint ]
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> prepareToRender: aBlSpace onBufferSurface: aBlHostRendererBufferSurface [
	"Prepare host space to a given space on a buffer surface.
	By default dispatch directly to the renderer"
	
	self hasScaled
		ifTrue: [ self windowDo: [ :aWindow | aWindow validHandle renderer resetResources ] ].
	
	self renderer prepareToRender: aBlSpace
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> prepareToRender: aBlSpace onFormSurface: aBlHostRendererFormSurface [
	"Prepare host space to a given space on a Form surface.
	By default dispatch directly to the renderer"
	
	self hasScaled
		ifTrue: [ window validHandle renderer resetResources ].

	self renderer prepareToRender: aBlSpace
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> prepareToRender: aBlSpace onOpenGLSurface: aBlHostRendererOpenGLSurface [
	"Prepare host space to a given space on an OpenGL surface.
	By default dispatch directly to the renderer"
	
	self hasScaled
		ifTrue: [ aBlHostRendererOpenGLSurface extent: self canvasExtent ].
	
	window validHandle renderer asCurrentDo: [ self renderer prepareToRender: aBlSpace ]
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> presentBufferSurface: aBlHostRendererBufferSurface areas: aCollectionOfAreas [
	window validHandle renderer
		presentBufferSurface: aBlHostRendererBufferSurface areas: aCollectionOfAreas
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> presentFormSurface: aBlHostRendererFormSurface areas: aCollectionOfAreas [
	window validHandle renderer
		presentFormSurface: aBlHostRendererFormSurface areas: aCollectionOfAreas
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> presentOpenGLSurface: aBlHostRendererOpenGLSurface areas: aCollectionOfAreas [
	window validHandle renderer
		presentOpenGLSurface: aBlHostRendererOpenGLSurface areas: aCollectionOfAreas
]

{ #category : #'host space - rendering' }
BlOSWindowSpace >> render: aBlSpace onOpenGLSurface: aBlHostRendererOpenGLSurface [
	"Render a given space on an OpenGL surface.
	By default dispatch directly to the renderer"

	self renderer doRender: aBlSpace dirtyAreas: { 0 @ 0 extent: aBlSpace extent }
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> renderer [
	"Return host renderer used to render spaces"
	<return: #TBlHostRenderer>

	^ renderer
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> resizable [
	^ self windowDo: [ :aWindow | aWindow resizable ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> resizable: aBoolean [
	self windowDo: [ :aWindow | aWindow resizable: aBoolean ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> scaleFactor [
	"Return a scaling factor from space to window coordinates.
	On high dpi (retina) displays scaling factor is > 1"
	<return: #Point>
	
	^ (self canvasExtent / self windowExtent) asFloatPoint
]

{ #category : #'host space - displaying' }
BlOSWindowSpace >> show [
	self windowDo: [ :aWindow | aWindow show ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> title [
	^ self windowDo: [ :aWindow | aWindow title ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> title: aString [
	self windowDo: [ :aWindow | aWindow title: aString ]
]

{ #category : #private }
BlOSWindowSpace >> window: anOSWindow [
	window := anOSWindow
]

{ #category : #private }
BlOSWindowSpace >> windowDo: aBlock [
	"All direct references to a window must be replaced with windowDo:
	I make sure that window is valid and re-create it if needed"
	self ensureWindowIsValid.
	
	^ aBlock value: window
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> windowExtent [
	"Return the window size in screen coordinates.
	This size may differ from the size in pixels of underlying surface 
	on high dpi (retina) screens"
	<return: #Point>

	^ self windowDo: [ :aWindow | aWindow extent ]
]

{ #category : #'host space - accessing' }
BlOSWindowSpace >> windowExtent: newExtent [
	"Change window size to a newExtent"

	self windowExtent ~= newExtent
		ifTrue: [ self windowDo: [ :aWindow | aWindow extent: newExtent ] ]
]

{ #category : #initialization }
BlOSWindowSpace >> withSpartaRenderer [

	renderer := BlSpartaRenderer new.
	renderer initializeHostSpace: self
]
