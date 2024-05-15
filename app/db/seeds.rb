# db/seeds.rb
require_relative '../models/user'
require_relative '../models/question'
require_relative '../models/option'
require_relative '../models/progress'

users = [
  { username: 'jondoe', email: 'jon@doe.com', password: 'abc' },
  { username: 'janedoe', email: 'jane@doe.com', password: 'abc' },
  { username: 'babydoe', email: 'baby@doe.com', password: 'abc' },
]

questions = [
  { id: 1, description: 'Pregunta 1' },
  { id: 2, description: 'Pregunta 2' }
]

# Falta relacionarlo con atributo del usuario
progresses = [
    { numberOfCorrectAnswers: 20, numberOfAchivements: 5, progressLevel: 'Capo' },
    { numberOfCorrectAnswers: 1, numberOfAchivements: 0, progressLevel: 'Malardo' }
]

options = [
  { id: 11, description: 'Opcion 1', correct: true},
  { id: 12, description: 'Opcion 2', correct: false},
  { id: 13, description: 'Opcion 3', correct: false},
  { id: 14, description: 'Opcion 4', correct: false},
]

# Crear usuarios
users.each do |u|
  unless User.exists?(u[:email])
    User.create(u)
  end
end

#HACER: modificar para que verifique existencia
progresses.each do |p|
    Progress.create(p)
end

# Crear preguntas
questions.each do |q|
  unless Question.exists?(q[:id])
    Question.create(q)
  end
end

options.each do |o|
  unless Option.exists?(o[:id])
    Option.create(o)
  end
end
