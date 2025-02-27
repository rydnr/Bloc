"
!Frame layout

I am a layout designed to block out an area on the screen to display a single child. 

I should be mainly used to display a single child, as it can be difficult to display multiple children at different positions on the screen without overlapping each other. 
However, elements with a frame layout can have multiple child elements. The =='weight'== and =='alignment'== atributes can be used to control the position of children. However, weight only works when the child matches the parent; if it fits content or has an exact size, the weight attribute is ignored. I rely on custom layout constraints for setting  attributes (see ${class:BlFrameLayoutConstraints}$, ${class:BlFrameLayoutConstraintsHorizontal}$ and ${class:BlFrameLayoutConstraintsVertical}$).

I position each child element based on the top left of the screen. Child elements are stacked on top of each other, with the most recently added child on top. An important property is that the location of a child is independent from the location of other children. 

I am similar to the frame layout from Android. The main differences are that I:
- provide support for controlling the size of a child element using the =='weight'==  attribute;
- the =='gravity'==  attribute is not present; instead the =='alignment'==  attribute should be used.

!!Alignment
The alignment attribute controls the position of children with a FrameLayout. Children can be aligned both vertically and horizontally as follows:
- horizontally children can be aligned to left, center and right;
- vertically children can be aligned to top, center and bottom.

For example, below we aligh a child with a fixed size horizontally to the right and vertically to the bottom. To set the alignment we need to use a constraint specific to the frame layout, as not all layouts know about alignment. For that we first need to obtain the constraints specific to the frame layout by sending the message ${method:BlLayoutCommonConstraints>>#frame}$ to the current constraint object. This returns an instance of ${class:BlFrameLayoutConstraints}$ that we can use to set the desired alignment. Other constraints like the size of an element are common to all layouts and can be set directly without requesting a specific constraint object.
${example:BlFrameLayoutSingleChildExamples>>#elementDocumentationWithOneExactChildAlignBottomRightInExactParent|previewExpanded|previewHeight=400}$

When using multiple children if we do not specify any alignment they will be placed in the top-left corner in the order in which they were added to the parent.
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithTwoExactChildrenAndNoAlignment|previewExpanded|previewHeight=400}$

With an alignment we can better arrange these children. For example we can place one to the right and center it. This will result in no overlapping.
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithExactChildAlignTopLeftAndExactChildRightCenter|previewExpanded|previewHeight=400}$

We can also use a different alignment that goes not completely remove overapping. 
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithExactChildAlignLeftCenterAndExactChildCenter|previewExpanded|previewHeight=400}$

We can use alignment to place children in more advanced ways. An example is given by ${class:BlFrameLayoutCompositionExamples}$.
${example:BlFrameLayoutCompositionExamples>>#example|previewExpanded|previewHeight=400}$

To end this section below are all the nine ways in wich we can place a child using alignment.
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithNineExactChildrenWithAllAlignments|previewExpanded|previewHeight=400}$

!!Weight
Above we saw that one way to set the size of a child element is by using an exact size. A second option is for a children to match the size of the parent. In this case, children that match parent can also be configured to occupy only a fraction of parent's size using the =='weigh'== attribute.

A child can match parent both horizontally and vertically. If no padding or margin is used, the child will overlap the parent completely.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneChildMatchExactParent|previewExpanded|previewHeight=400}$

We can add padding, for example, to also see that indeed the parent is also rendered.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneChildMatchExactParentWithPadding|previewExpanded|previewHeight=400}$

By indicating a weight value when the child matches parent we can control the actual space occupied by that child. For example, in the code below the child takes 90% of the space horizontally and 50% vertically, starting from the top left corner. 
${example:BlFrameLayoutSingleChildExamples>>#elementForDocumentationWithOneChildMatchExactParentWithWeight|previewExpanded|previewHeight=400}$

We can also have multiple children that match parent and take different proportions of the available space, as in the following example.
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithTwoChildrenMatchingParentWithWeight|previewExpanded|previewHeight=400}$

Setting this attribute only works in case the element matches parent. In case the element has a fixed size and we specify a weight, the weight is going to be ignored.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneChildWithExactSizeParentWithWeight|previewExpanded|previewHeight=400}$

Also if a child element has a fixed side and both weight and alignment, the weight is going to be ignored.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneExactChildAlignBottomCenterAndWithWeightInExactParent|previewExpanded|previewHeight=400}$

!!Fit content in parent 
The previous examples assumened that the parent had a fixed size. That, or having the parent use a match parent strategy are the common ways to use a frame layout. It is however also possible to have the parent fit content, if the child has a fixed size. In that case the parent will have the size of the child, if no padding or margin is used.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneExactChildAndFitContentParent|previewExpanded|previewHeight=400}$
 
This also works in case multiple children are present having different sizes.
${example:BlFrameLayoutMulipleChildrenExamples>>#elementWithTwoExactChildrenAndFitContentParent|previewExpanded|previewHeight=400}$

However, this will not work in case the parent uses fit content and the child uses match parent, as there is no way to determine the size. In such cases the size of both the parent and the child will be ==0@0==.
${example:BlFrameLayoutSingleChildExamples>>#elementWithOneMatchParentChildAndFitContentParent|previewExpanded|previewHeight=400}$

!!More examples
For more example on how to use the frame layout you can view the classes providig examples for this layout:
- ${class:BlFrameLayoutSingleChildExamples}$
- ${class:BlFrameLayoutMulipleChildrenExamples}$
- ${class:BlFrameLayoutCompositionExamples}$


"
Class {
	#name : #BlFrameLayout,
	#superclass : #BlLayout,
	#category : #'Bloc-Layout-Frame'
}

{ #category : #constraints }
BlFrameLayout class >> constraints [
	^ BlFrameLayoutConstraints new
]

{ #category : #'api - alignment' }
BlFrameLayout >> align: aChildElement horizontal: aBlAlignment [
	aChildElement constraintsDo: [ :c | (c at: self class) horizontal alignment: aBlAlignment ]
]

{ #category : #'api - alignment' }
BlFrameLayout >> align: aChildElement vertical: aBlAlignment [
	aChildElement constraintsDo: [ :c | (c at: self class) vertical alignment: aBlAlignment ]
]

{ #category : #measure }
BlFrameLayout >> canMeasureChildFirstPass: aChild parentSpec: anExtentSpec [
	"Return true if we can measure a given child during the first measurement pass given that we received the provided parent extent spec, false otherwise"
	<return: #Boolean>
	| canMeasureWidth canMeasureHeight |
	
	"if parent spec is exact, we can definitely measure"
	anExtentSpec isExact
		ifTrue: [ ^ true ].

	canMeasureWidth := anExtentSpec widthSpec isExact or: [ aChild constraints horizontal resizer isMatchParent not ].
	canMeasureHeight := anExtentSpec heightSpec isExact or: [ aChild constraints vertical resizer isMatchParent not ].

	^ canMeasureWidth and: [ canMeasureHeight ]
]

{ #category : #layout }
BlFrameLayout >> layout: anElement in: aRectangle [
	| parentBounds |
	
	self layoutIgnored: anElement.
	
	"first store parent's local bounds"
	parentBounds := anElement padding inset: (0@0 extent: aRectangle extent).

	self
		layeredChildren: anElement
		do: [ :aChild |
			| childBounds alloowedBounds |
			"ask child for its measured bounds"
			childBounds := aChild measuredBounds bounds copy.
			alloowedBounds := aChild margin inset: parentBounds copy.
		
			"frame layout supports alignment, so we need to translate child's bounds accordingly to alignment"
			childBounds := childBounds := self
				align: aChild
				bounds: childBounds
				in: alloowedBounds
				with: aChild constraints frame alignment.
			"and finally set new bounds"
			aChild applyLayoutIn: childBounds ].
]

{ #category : #measure }
BlFrameLayout >> measure: anElement with: anExtentSpec [
	| matchParentChildren |

	"First measure children that know their size (exact and fit content),
	collecting those that needs to be measured later after we know parent's size"
	matchParentChildren := self measureChildren: anElement with: anExtentSpec.
	"Second pass to measure children that match parent"
	self measureMatching: matchParentChildren of: anElement with: anExtentSpec
]

{ #category : #measure }
BlFrameLayout >> measureChild: aChildElement of: anElement with: anExtentSpec [
	| aParentHeight aParentWidth |

	aParentWidth := anExtentSpec widthSpec isUnspecified
		ifTrue: [ 0 ]
		ifFalse: [ anExtentSpec widthSpec size ].
	aParentHeight := anExtentSpec heightSpec isUnspecified
		ifTrue: [ 0 ]
		ifFalse: [ anExtentSpec heightSpec size ].

	self
		measureChild: aChildElement
		of: anElement
		with: anExtentSpec
		width: aParentWidth
		height: aParentHeight
]

{ #category : #measure }
BlFrameLayout >> measureChild: aChildElement of: anElement with: anExtentSpec width: aParentWidth height: aParentHeight [
	| childWidthMeasureSpec childHeightMeasureSpec |

	aChildElement constraints horizontal resizer isMatchParent
		ifTrue: [ 
			| weight width |
			weight := (aChildElement constraints frame horizontal weight max: 0).
			width := ((aParentWidth - anElement insets width - aChildElement outsets width) * weight) max: 0.
			childWidthMeasureSpec := BlMeasurementSpec exact: width ]
		ifFalse: [ 
			childWidthMeasureSpec := self
				measurementSpecFor: anExtentSpec widthSpec
				usedSize: anElement insets width + aChildElement outsets width
				resizer: aChildElement constraints horizontal resizer ].

	aChildElement constraints vertical resizer isMatchParent
		ifTrue: [ 
			| weight height |
			weight := (aChildElement constraints frame vertical weight max: 0).
			height := ((aParentHeight - anElement insets height - aChildElement outsets height) * weight) max: 0.
			childHeightMeasureSpec := BlMeasurementSpec exact: height ]
		ifFalse: [ 
			childHeightMeasureSpec := self
				measurementSpecFor: anExtentSpec heightSpec
				usedSize: anElement insets height + aChildElement outsets height
				resizer: aChildElement constraints vertical resizer ].

	aChildElement measure: childWidthMeasureSpec @ childHeightMeasureSpec
]

{ #category : #measure }
BlFrameLayout >> measureChildren: anElement with: anExtentSpec [
	"Perform a first measurement pass and measure those children for which we can
	determine an extent, otherwise add children to a collection that should be
	measured during second pass and return it"
	<return: #LinkedList of: #BlElement>
	| matchParentChildren aConstrainedExtentSpec maxHeight maxWidth aMeasuredExtent aMeasuredWidth aMeasuredHeight |
	
	matchParentChildren := LinkedList new.

	maxWidth := 0.
	maxHeight := 0.
	
	aConstrainedExtentSpec := anExtentSpec
		min: (anElement constraints minWidth @ anElement constraints minHeight)
		max: (anElement constraints maxWidth @ anElement constraints maxHeight).

	self measureIgnored: anElement with: anExtentSpec.
	
	self
		measuredChildren: anElement
		do: [ :aChild |
			| shouldMeasureChild |
			
			"true if aChild should be measured NOW or false if it should happen during second measurement pass.
			we measure children if parent is exact or if child does not match parent"
			shouldMeasureChild := self canMeasureChildFirstPass: aChild parentSpec: aConstrainedExtentSpec.
			shouldMeasureChild
				"measure now"
				ifTrue: [
					self measureChild: aChild of: anElement with: aConstrainedExtentSpec.
					maxWidth := maxWidth max: (aChild measuredWidth + aChild outsets width).
					maxHeight := maxHeight max: (aChild measuredHeight + aChild outsets height) ]
				"or during second pass"
				ifFalse: [ matchParentChildren add: aChild ] ].
	
	maxWidth := maxWidth + anElement insets width.
	maxHeight := maxHeight + anElement insets height.

	maxWidth := maxWidth min: anElement constraints maxWidth max: anElement constraints minWidth.
	maxHeight := maxHeight min: anElement constraints maxHeight max: anElement constraints minHeight.
	
	aMeasuredExtent := anExtentSpec sizeFor: maxWidth @ maxHeight.

	aMeasuredWidth := aMeasuredExtent x min: anElement constraints maxWidth max: anElement constraints minWidth.
	aMeasuredHeight := aMeasuredExtent y min: anElement constraints maxHeight max: anElement constraints minHeight.
	anElement measuredExtent: aMeasuredWidth @ aMeasuredHeight.
	
	^ matchParentChildren
]

{ #category : #measure }
BlFrameLayout >> measureMatching: theChildren of: anElement with: anExtentSpec [
	theChildren
		ifEmpty: [ ^ self ].

	theChildren do: [ :aChildElement |
		self measureMatchingChild: aChildElement of: anElement with: anExtentSpec ]
]

{ #category : #measure }
BlFrameLayout >> measureMatchingChild: aChildElement of: anElement with: anExtentSpec [

	self
		measureChild: aChildElement
		of: anElement
		with: anExtentSpec
		width: anElement measuredWidth
		height: anElement measuredHeight
]
