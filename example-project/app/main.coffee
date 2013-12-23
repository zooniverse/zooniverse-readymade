Project = require '../../src/project'
# IdentificationClassifier = require 'zooniverse-readymade/identification-classifier'
# MarkingClassifier = require 'zooniverse-readymade/marking-classifier'
# DecisionTreeClassifier = require 'zooniverse-readymade/decision-tree-classifier'

new Project
  id: 'lpz_wildlife'

  producer: 'Lincoln Park Zoo'
  title: 'Urban Wildlife'
  summary: 'Discover the wildlife in your neighborhood!'
  description: 'We\'re looking at camera traps set up around Chicago to learn...'

  organizations: [
    {name: 'Lincoln Park Zoo', location: 'Chicago, IL', description: '', url: ''}
    {name: 'Adler Planetarium', location: 'Chicago, IL', description: '', url: ''}
  ]

  scientists: [
    {name: 'John Doe', location: 'Chicago, IL', description: '', url: ''}
  ]

  developers: [
    {name: 'Brian Carstensen'}
  ]

#   classifier: new IdentificationClassifier
#     options: [
#       {value: 'wolf', label: 'Wolf', image: '//placehold.it/100.png'}
#       {value: 'coyote', label: 'Coyote', image: '//placehold.it/100.png'}
#       {value: 'cat', label: 'Cat', image: '//placehold.it/100.png'}
#       {value: 'squirrel', label: 'Squirrel', image: '//placehold.it/100.png'}
#     ]

#   classifier2: new MarkingClassifier
#     options: [
#       {value: 'wolf', label: 'Wolf', image: '//placehold.it/100.png', tool: 'point'}
#       {value: 'coyote', label: 'Coyote', image: '//placehold.it/100.png', tool: 'circle'}
#       {value: 'cat', label: 'Cat', image: '//placehold.it/100.png', tool: 'ellipse'}
#       {value: 'squirrel', label: 'Squirrel', image: '//placehold.it/100.png', tool: 'rect'}
#     ]

#   classifier3: new DecisionTreeClassifier
#     questions:
#       FIRST:
#         question: 'How many things are there?'
#         answers: [
#           {value: 0, label: 'Zero'}
#           {value: 1, label: 'One', next: 'color'}
#           {value: 'many', label: 'Several', next: 'averageColor'}
#         ]

#       color:
#         question: 'What color is it?'
#         answers: [
#           {value: 'red', label: 'Red', image: '//placehold.it/100.png'}
#           {value: 'green', label: 'Green', image: '//placehold.it/100.png'}
#           {value: 'blue', label: 'Blue', image: '//placehold.it/100.png'}
#         ]

#       averageColor:
#         question: 'What color are they, on average?'
#         answers: [
#           {value: 'red', label: 'Red', image: '//placehold.it/100.png'}
#           {value: 'green', label: 'Green', image: '//placehold.it/100.png'}
#           {value: 'blue', label: 'Blue', image: '//placehold.it/100.png'}
#         ]
