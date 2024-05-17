# db/seeds.rb

require_relative '../models/user'
require_relative '../models/option'
require_relative '../models/question'

users = [
  { username: 'jondoe', email: 'jon@doe.com', password: 'abc', remaining_life_points: 100 },
  { username: 'janedoe', email: 'jane@doe.com', password: 'abc', remaining_life_points: 100 },
  { username: 'babydoe', email: 'baby@doe.com', password: 'abc', remaining_life_points: 100 }
]

users.each do |u|
  User.create(u)
end


questions_data = [
  {
    description: '¿Cuál es la forma correcta de asignar un valor a una variable en Python?',
    options: [
      { description: 'nombre de la variable = valor', value: true },
      { description: 'valor = nombre de la variable', value: false },
      { description: 'variable = valor', value: false },
      { description: 'variable: valor', value: false }
    ]
  },
  {
    description: '¿Cómo se asigna un valor a una variable en Python?',
    options: [
      { description: 'Con el operador "=="', value: false },
      { description: 'Utilizando corchetes "[ ]"', value: false },
      { description: 'Utilizando el operador "="', value: true },
      { description: 'Con el operador "+"', value: false }
    ]
  },
  {
    description: '¿Qué representan los valores booleanos en Python?',
    options: [
      { description: 'Números enteros', value: false },
      { description: 'Verdadero o falso', value: true },
      { description: 'Cadenas de texto', value: false },
      { description: 'Valores negativos', value: false }
    ]
  },
  {
    description: '¿Cuál es el resultado de la siguiente operación en Python? resultado = (4 > 5) and (3 < 8)',
    options: [
      { description: 'True', value: false },
      { description: 'False', value: true },
      { description: '0', value: false },
      { description: '1', value: false }
    ]
  },
  {
    description: '¿Cuál es el resultado de la siguiente operación en Python? resultado = 7 - 4 * 2',
    options: [
      { description: '14', value: false },
      { description: '6', value: false },
      { description: '-1', value: true },
      { description: '0', value: false }
    ]
  }
]



questions_data.each do |question_data|
  question = Question.create(description: question_data[:description])

  question_data[:options].each do |option_data|
    Option.create(description: option_data[:description], value: option_data[:value], question_id: question.id)
  end
end
