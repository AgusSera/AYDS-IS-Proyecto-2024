require_relative '../models/user'
require_relative '../models/option'
require_relative '../models/question'
require_relative '../models/lesson'
require_relative '../models/progress'

lessons_data = [
  {
    name: 'Lección 1: Variables, Tipos de datos y Operadores básicos',
    content: 'Las variables son contenedores que pueden almacenar diferentes tipos de datos en Python. Podemos asignarles valores utilizando el operador de asignación "=".',
    questions: [
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
  },
  {
    name: 'Lección 2: Estructuras de Control y Bucles',
    content: 'En esta lección aprenderás sobre las estructuras de control como if, else, while y for en Python.',
    questions: [
      {
        description: '¿Cuál es la estructura correcta de un condicional if en Python?',
        options: [
          { description: 'if (condición):', value: true },
          { description: 'if condición entonces:', value: false },
          { description: 'if condición {', value: false },
          { description: 'if: condición', value: false }
        ]
      },
      {
        description: '¿Cuál es la salida del siguiente código? for i in range(3): print(i)',
        options: [
          { description: '0 1 2', value: true },
          { description: '1 2 3', value: false },
          { description: '0 1 2 3', value: false },
          { description: '1 2', value: false }
        ]
      },
      {
        description: '¿Qué palabra clave se usa para salir de un bucle en Python?',
        options: [
          { description: 'exit', value: false },
          { description: 'quit', value: false },
          { description: 'break', value: true },
          { description: 'stop', value: false }
        ]
      }
    ]
  },
  {
    name: 'Lección 3: Funciones y Módulos',
    content: 'En esta lección aprenderás sobre cómo definir funciones, usar argumentos y trabajar con módulos en Python.',
    questions: [
      {
        description: '¿Cómo defines una función en Python?',
        options: [
          { description: 'function mi_funcion():', value: false },
          { description: 'def mi_funcion():', value: true },
          { description: 'define mi_funcion():', value: false },
          { description: 'func mi_funcion():', value: false }
        ]
      },
      {
        description: '¿Cómo importas un módulo en Python?',
        options: [
          { description: 'import modulo', value: true },
          { description: 'include modulo', value: false },
          { description: 'using modulo', value: false },
          { description: 'require modulo', value: false }
        ]
      },
      {
        description: '¿Qué se utiliza para devolver un valor desde una función?',
        options: [
          { description: 'send', value: false },
          { description: 'return', value: true },
          { description: 'give back', value: false },
          { description: 'output', value: false }
        ]
      }
    ]
  }
]

# Crear lecciones, preguntas y opciones
lessons_data.each do |lesson_data|
  lesson = Lesson.create(name: lesson_data[:name], content: lesson_data[:content])
  lesson_data[:questions].each do |question_data|
    question = Question.create(description: question_data[:description], lesson_id: lesson.id)
    question_data[:options].each do |option_data|
      Option.create(description: option_data[:description], value: option_data[:value], question_id: question.id)
    end
  end
end


# Crear progreso de usuario
progress = Progress.create(current_lesson: 1)

# Crear usuario de ejemplo
user = User.create(username: 'usuario', password: 'password', email: 'usuario@example.com', remaining_life_points: 3, progress_id: progress.id)
