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

  classification: {
    ###
      questionName: {
        question: 'Mark the creatures in this image.'
        choices: [
          {
            type: 'answer' # This is the default type.
            value: 'nothing'
            label: 'Nothing to mark'
            next: '' # Answer-specific "next" value
          }

          {
            type: 'point'
            value: 'deer'
            label: 'Deer'
            image: './images/animals/deer.jpg'
            color: 'red'
            # Per-marking details, rendered in tool controls:
            details: [
              {type: 'checkbox', value: 'eating', label: 'Eating'}
            ]
          }
        ]

        # Whole-image details, rendered below choices:
        details: [
          {value: 'distorted', label: 'This image is distorted' type: 'checkbox'}
        ]

        # Default "next" value:
        next: ''
      }
    ###
   }
