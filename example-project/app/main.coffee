Project = require '../../src/project'

new Project
  id: 'asteroid'

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
    first: 'substrate'
    substrate: {
      question: 'Mark all substrates visible in this image'
      choices: [
        {type: 'checkbox', value: 'sand', label: 'Sand'}
        {type: 'checkbox', value: 'gravel', label: 'Gravel'}
        {type: 'checkbox', value: 'rocks', label: 'Rocks'}
      ]
      next: 'testRadios'
    }

    testRadios: {
      question: 'Pick one.'
      choices: [
        {type: 'radio', value: 'foo', label: 'Foo'}
        {type: 'radio', value: 'bar', label: 'Bar'}
      ]

      next: 'animals'
    }

    animals: {
      question: 'Mark the animals in this image.'
      choices: [
        {
          type: 'point'
          value: 'fish'
          label: 'Fish'
          color: 'red'
          details: [
            {type: 'checkbox', value: 'eating', label: 'Eating'}
          ]
        }
        {
          type: 'point'
          value: 'lobster'
          label: 'Lobster'
          color: 'green'
        }
        {
          type: 'answer'
          value: 'done'
          label: 'Done'
        }
      ]
    }
   }
