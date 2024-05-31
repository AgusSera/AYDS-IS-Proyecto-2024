require_relative '../models/user'
require_relative '../models/option'
require_relative '../models/question'
require_relative '../models/lesson'
require_relative '../models/progress'

lessons_data = [
  {
    name: 'Lección 1: Variables, Tipos de datos y Operadores básicos',
    content: 'Las variables son contenedores que pueden almacenar diferentes tipos de datos en Python. Podemos asignarles valores utilizando el operador de asignación "=".
    Además de asignarles valores directamente utilizando el operador de asignación "=", también podemos asignar a una variable el valor de otra variable. Esto se hace simplemente escribiendo el nombre de la variable deseada a la izquierda del operador de asignación y el nombre de la variable de origen a la derecha.
    Tipos de datos:
Un tipo de dato es una clasificación que se le asigna a un valor en programación para indicar qué tipo de información representa y cómo se puede manipular. Los tipos de datos definen qué operaciones se pueden realizar con esos valores y cómo se almacenan en la memoria de la computadora.
Python admite varios tipos de datos, incluyendo enteros, números de coma flotante, cadenas de texto y valores booleanos.
Es importante tener en cuenta que Python es un lenguaje de programación de tipado dinámico, lo que significa que no es necesario declarar explícitamente el tipo de una variable antes de asignarle un valor.',
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
    content: 'En esta lección, exploraremos las estructuras de control y los bucles en Python, elementos fundamentales para controlar el flujo de ejecución de un programa y realizar operaciones repetitivas.

Estructuras de Control:
Las estructuras de control, como if, else, y elif, permiten tomar decisiones en función de condiciones específicas. Aprenderemos cómo usar estas estructuras para ejecutar diferentes bloques de código según sea necesario, lo que nos permite crear programas más dinámicos y adaptativos.

Bucles (Loops):
Los bucles, como while y for, nos permiten ejecutar un bloque de código repetidamente. Con while, podemos repetir la ejecución de un bloque de código mientras se cumpla una condición. Con for, podemos iterar sobre una secuencia de elementos, como una lista o un rango de números. Exploraremos cómo usar estos bucles para automatizar tareas y procesar datos de manera eficiente.

Palabra Clave "break" y "continue":
Además de las estructuras de control y los bucles, también aprenderemos sobre las palabras clave break y continue. break se utiliza para salir de un bucle prematuramente si se cumple una condición específica, mientras que continue se utiliza para omitir la ejecución del resto del bloque de código actual y pasar a la siguiente iteración del bucle.',
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
      },
      {
        description: '¿Cuál es la función de la palabra clave "else" en un condicional if en Python?',
        options: [
          { description: 'Especifica un bloque de código que se ejecuta si la condición del if es falsa.', value: true },
          { description: 'Indica una condición alternativa al if.', value: false },
          { description: 'Se utiliza para iniciar un nuevo condicional dentro del if.', value: false },
          { description: 'No tiene ninguna función en un condicional if.', value: false }
        ]
      },
      {
        description: '¿Cuál es la diferencia principal entre "while" y "for" en Python?',
        options: [
          { description: '"while" se utiliza para iterar mientras una condición sea verdadera, mientras que "for" se utiliza para iterar sobre una secuencia de elementos.', value: true },
          { description: '"while" y "for" son sinónimos y se pueden utilizar indistintamente.', value: false },
          { description: '"for" se utiliza para bucles infinitos, mientras que "while" se utiliza para bucles con un número específico de iteraciones.', value: false },
          { description: '"for" se utiliza solo para iterar sobre listas, mientras que "while" se utiliza para otros tipos de estructuras de datos.', value: false }
        ]
      }
    ]
  },
  {
    name: 'Lección 3: Funciones y Módulos',
    content: 'Lección 3: Funciones y Módulos
        En esta lección, exploraremos dos aspectos fundamentales de la programación en Python: las funciones y los módulos.

        Definición de Funciones:
        Las funciones son bloques de código reutilizables que realizan una tarea específica. Permiten organizar el código de manera más limpia y modular, lo que facilita su mantenimiento y reutilización. En Python, las funciones se definen utilizando la palabra clave def, seguida del nombre de la función y los parámetros, si los hay. Aprenderemos cómo definir funciones y cómo utilizar argumentos para personalizar su comportamiento.

        Uso de Argumentos:
        Los argumentos son valores que se pasan a una función para que esta los utilice durante su ejecución. En Python, existen varios tipos de argumentos, como los argumentos posicionales, los argumentos de palabra clave y los argumentos predeterminados. Aprenderemos cómo utilizar estos diferentes tipos de argumentos para hacer nuestras funciones más flexibles y versátiles.

        Trabajo con Módulos:
        Los módulos son archivos que contienen funciones, variables y clases relacionadas entre sí. Python incluye una amplia variedad de módulos estándar que proporcionan funcionalidades adicionales listas para usar. Además, podemos crear nuestros propios módulos para organizar y reutilizar nuestro propio código. Aprenderemos cómo importar módulos en Python y cómo utilizar las funciones y variables que contienen..',
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
      },
      {
        description: '¿Cuál es el propósito principal de una función en Python?',
        options: [
          { description: 'Reutilizar un bloque de código para realizar una tarea específica.', value: true },
          { description: 'Modificar directamente las variables globales.', value: false },
          { description: 'Crear variables locales para el uso dentro de la función.', value: false },
          { description: 'Realizar operaciones matemáticas complejas.', value: false }
        ]
      },
      {
        description: '¿Qué es un parámetro en una función de Python?',
        options: [
          { description: 'Una variable que almacena el resultado de una función.', value: false },
          { description: 'Un valor que se pasa a una función para ser utilizado dentro de ella.', value: true },
          { description: 'Una condición que debe cumplirse para ejecutar una función.', value: false },
          { description: 'Un tipo de estructura de control en Python.', value: false }
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
