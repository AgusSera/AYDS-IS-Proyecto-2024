# db/seeds.rb
require_relative '../models/user'
require_relative '../models/question'

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
require_relative '../models/progress'
progresses = [
    { numberOfCorrectAnswers: 20, numberOfAchivements: 5, progressLevel: 'Capo' },
    { numberOfCorrectAnswers: 1, numberOfAchivements: 0, progressLevel: 'Malardo' }
]

progresses.each do |p|
    Progress.create(p)
end

users.each do |u|
  User.create(u)
end

questions.each do |q|
  Question.create(q)
end
