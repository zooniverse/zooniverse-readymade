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
    first: 'buttons'

    buttons: {
      question: 'Choose a button'
      choices: [
        {type: 'button', value: 'default', label: 'Default',}
        {type: 'button', value: 'specific', label: 'Specific', next: 'checkboxes'}
        {type: 'button', value: 'random', label: 'Random', next: -> if Math.random() < 0.5 then 'radios' else 'checkboxes'}
      ]
      next: 'radios'
    }

    radios: {
      question: 'You picked "default". Now pick a radio button.'
      choices: [
        {type: 'radio', value: 'foo', label: 'Foo'}
        {type: 'radio', value: 'bar', label: 'Bar'}
        {type: 'radio', value: 'lol', label: 'LOL'}
      ]
      next: 'drawing'
    }

    checkboxes: {
      question: 'You picked "specific". Now pick some checkboxes.'
      choices: [
        {type: 'checkbox', value: 'foo', label: 'Foo'}
        {type: 'checkbox', value: 'bar', label: 'Bar'}
        {type: 'checkbox', value: 'lol', label: 'LOL'}
      ]
      next: 'drawing'
    }

    drawing: {
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
      ]
    }
   }
