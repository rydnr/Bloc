"
BlTaskItStatus provides a very low level overview of TaskIt pools used by Bloc.

Since this is typically required when the UI is failing to update the output is a simple string that can easily be printed or written to file.

To view the current status:

[[[
BlTaskItStatus new
]]]

"
Class {
	#name : #BlTaskItStatus,
	#superclass : #Object,
	#instVars : [
		'statusString'
	],
	#classVars : [
		'SamplePeriod',
		'SampleProcess'
	],
	#category : #'Bloc-TaskIt-Status'
}

{ #category : #private }
BlTaskItStatus class >> sampleLoop [

	[ self new asBeaconSignal emit.
	self samplePeriod wait ] repeat.
]

{ #category : #accessing }
BlTaskItStatus class >> samplePeriod [

	^SamplePeriod ifNil: [ SamplePeriod := 10 second ]
]

{ #category : #accessing }
BlTaskItStatus class >> samplePeriod: aDuration [

	SamplePeriod := aDuration
]

{ #category : #sampling }
BlTaskItStatus class >> startSampling [

	SampleProcess ifNotNil: [ self error: 'Sample process already running' ].

	SampleProcess := [ self sampleLoop ] 
			forkAt: Processor userInterruptPriority 
			named: 'CurrentProcessSignal sampler'.
]

{ #category : #sampling }
BlTaskItStatus class >> stopSampling [

	SampleProcess ifNil: [ ^self ].
	SampleProcess terminate.
	100 milliSeconds wait.
	SampleProcess isTerminated ifFalse: [ self error: 'Unable to terminate sample process' ].
	SampleProcess := nil.
]

{ #category : #writing }
BlTaskItStatus class >> write [
	"Write the current status to a timestamped file"

	self writeTo: 'TaskIt Status ', DateAndTime now printString, '.txt'.
]

{ #category : #writing }
BlTaskItStatus class >> writeTo: aFileReference [
	"Write the current status to the supplied file name"

	aFileReference asFileReference writeStreamDo:
		[ :stream | self new statusOn: stream ]
]

{ #category : #printing }
BlTaskItStatus >> gtStatusFor: aView [
	<gtView>

	^aView textEditor 
		title: 'Status' translated;
		priority: 1;
		look: BrGlamorousCodeEditorLook new;
		text: [ self statusString asRopedText ]
]

{ #category : #initialization }
BlTaskItStatus >> initialize [

	super initialize.
	self statusString
]

{ #category : #printing }
BlTaskItStatus >> instanceCountsOn: aStream [

	aStream
		<< 'Instance Counts:';
		cr; cr.

	#(TKTNewProcessTaskRunner 
	TKTLocalProcessTaskRunner
	TKTWorkerPool
	TKTCommonQueueWorkerPool
	BlTktCommonQueueWorkerPool
	BlTktCommonPriorityQueueWorkerPool) do: [ :class |
		aStream
			print: class;
			<< ': ';
			print: class asClass instanceCount;
			cr ]
]

{ #category : #printing }
BlTaskItStatus >> printQueueFor: pool on: aStream [

	pool taskQueue contents do: [ :each |
			aStream
				<< '  ';
				<< each name;
				cr ]
]

{ #category : #printing }
BlTaskItStatus >> printWorkersFor: pool on: aStream [

	pool workers 
		select: [ :worker | worker isFree not ]
		thenDo: [ :worker |
			aStream
				<< '  name: ';
				print: worker name;
				<< ', task: ';
				<< worker taskName;
				cr ]
]

{ #category : #printing }
BlTaskItStatus >> statusOn: aStream [
	"Print a summary of the system status on aStream"

	TKTConfiguration serviceManager services do: [ :eachService | 
		eachService class = TKTWatchDog ifTrue: [ 
			eachService pool ifNotNil: [ :aPool |
				self workerPool: eachService pool on: aStream ] ] ].
	self instanceCountsOn: aStream
]

{ #category : #accessing }
BlTaskItStatus >> statusString [

	^statusString ifNil: [ statusString := String streamContents: [ :stream | self statusOn: stream ] ]
]

{ #category : #printing }
BlTaskItStatus >> workerPool: pool on: aStream [

	| freeWorkers |
	
	freeWorkers := pool workers select: #isFree.
	aStream 
		<< 'Name: '
		<< pool name; cr;
		<< 'Queue Size: ';
		print: pool taskQueue size; cr.
	self printQueueFor: pool on: aStream.
	aStream
		<< 'Busy Workers: ';
		print: pool workers size - freeWorkers size; cr.
	self printWorkersFor: pool on: aStream.
	aStream
		<< 'Free Workers: ';
		print: freeWorkers size; cr;
		<< 'Failed Tasks: ';
		print: pool failedTasks size; cr;
		<< 'Pool Max Size: ';
		print: pool poolMaxSize; cr;
		cr; cr.

]
