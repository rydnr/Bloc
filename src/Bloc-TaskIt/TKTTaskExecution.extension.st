Extension { #name : #TKTTaskExecution }

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> entryPriority [
	"Answer the priority of the receiver when submitted as a task to TaskIt. 0 is highest priority"

	^ task entryPriority
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> executionProcess: aProcess [
	"For testing purpose only"
	executionProcess := aProcess
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> name [ 
	<return: #String>
	^ task name
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> setExplicitlyTerminatedStateWithReason: aReason [
	state := BlTktExplicitlyTerminatedTaskState new reason: aReason
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> state [
	"For testing purpose only."
	<return: #TKTTaskState>
	^ state
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> task [ 
	<return: #TKTTask>
	^ task
]

{ #category : #'*Bloc-TaskIt' }
TKTTaskExecution >> terminateWithReason: aReason [
	state terminateTaskExecution: self reason: aReason
]
