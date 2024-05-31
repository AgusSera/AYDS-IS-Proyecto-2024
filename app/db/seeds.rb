require_relative '../models/user'
require_relative '../models/option'
require_relative '../models/question'
require_relative '../models/lesson'
require_relative '../models/progress'

lessons_data = [
  {
    name: 'Lesson 1: Variables, Data Types, and Basic Operators',
    content: 'In this lesson, we will learn about variables, data types, and basic operators. These concepts are fundamental to start your programming journey. Each concept will be explained using Python.
    <hr>
    ### Variables
    A variable is a space in memory used to store data that can change during the execution of the program. In Python, it is not necessary to declare the type of a variable before using it. You simply assign a value to a variable using the equal sign (=).
    ```# Example of variable declaration
    name = "John"
    age = 25
    is_student = True```
    In the example above, we have declared three variables: name, age, and is_student, and assigned values of different types to them.
    <hr>
    ### Data Types
    Python has several built-in data types that can be used for different purposes. Some of the most common data types are:
    • Integers (int): Whole numbers, like 10, -3, 0.
    • Floating-point numbers (float): Numbers with decimals, like 3.14, -2.5, 0.0.
    • Strings (str): Sequences of characters, like "Hello", "Python".
    • Booleans (bool): Truth values, like True or False.
    ```# Examples of different data types
    integer_number = 10
    floating_number = 3.14
    string = "Hello, world"
    boolean_value = True```
    <hr>
    ### Basic Operators
    Operators are used to perform operations on variables and values. Some of the basic operators in Python are:
    • Arithmetic Operators
    • Addition (+): Adds two values.
    • Subtraction (-): Subtracts the second value from the first.
    • Multiplication (*): Multiplies two values.
    • Division (/): Divides the first value by the second.
    • Modulus (%): Returns the remainder of the division.
    ```# Examples of arithmetic operators
    sum = 5 + 3          # Result: 8
    difference = 10 - 4  # Result: 6
    product = 2 * 3      # Result: 6
    quotient = 8 / 2     # Result: 4.0
    remainder = 7 % 3    # Result: 1```
    <hr>
    ### Comparison Operators
    Operators are used to perform operations on variables and values. Some of the basic operators in Python are:
    • Equal to (==): Returns True if the values are equal.
    • Not equal to (!=): Returns True if the values are different.
    • Greater than (>): Returns True if the first value is greater than the second.
    • Less than (<): Returns True if the first value is less than the second.
    • Greater than or equal to (>=): Returns True if the first value is greater than or equal to the second.
    • Less than or equal to (<=): Returns True if the first value is less than or equal to the second.
    ```# Examples of comparison operators
    is_equal = (5 == 5)          # Result: True
    is_not_equal = (5 != 3)      # Result: True
    is_greater = (7 > 3)         # Result: True
    is_less = (4 < 6)            # Result: True
    is_greater_or_equal = (5 >= 5)  # Result: True
    is_less_or_equal = (3 <= 5)  # Result: True```
    <hr>
    ### Logical Operators
    Operators are used to perform operations on variables and values. Some of the basic operators in Python are:
    • Logical AND (and): Returns True if both operands are True.
    • Logical OR (or): Returns True if at least one of the operands is True.
    • Logical NOT (not): Inverts the logical value of the operand.
    ```# Examples of logical operators
    result_and = (True and False)  # Result: False
    result_or = (True or False)    # Result: True
    result_not = not True          # Result: False```',
    questions: [
      {
        description: 'What is the correct way to assing a value to a variable in Python?',
        options: [
          { description: 'variable name = value', value: true },
          { description: 'value = variable name', value: false },
          { description: 'variable = value', value: false },
          { description: 'variable: value', value: false }
        ]
      },
      {
        description: 'How can you assing a value to a variable in Python?',
        options: [
          { description: 'Using the "==" operator', value: false },
          { description: 'Using "[ ]"', value: false },
          { description: 'Using the "=" operator', value: true },
          { description: 'Using the "+" operator', value: false }
        ]
      },
      {
        description: 'What do Boolean values represent in Python?',
        options: [
          { description: 'Integers', value: false },
          { description: 'True or False', value: true },
          { description: 'Strings', value: false },
          { description: 'Negative integers', value: false }
        ]
      },
      {
        description: 'What is the value of the following expression in Python? result = (4 > 5) and (3 < 8)',
        options: [
          { description: 'True', value: false },
          { description: 'False', value: true },
          { description: '0', value: false },
          { description: '1', value: false }
        ]
      },
      {
        description: 'What is the value of the following expression in Python? result = 7 - 4 * 2',
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
    name: 'Lesson 2: Control Structures and Loops',
    content: 'In this lesson, we will learn about control structures and loops in Python. Control structures allow us to control the flow of execution of a program, while loops allow us to repeat certain actions.
    <hr>
    ## Control Structures
    #### If-Else
    The most basic control structure is the if-else statement, which allows us to make decisions based on conditions.
    ```# Example of if-else statement
    age = 18
    
    if age >= 18:
        print("You are an adult")
    else:
        print("You are a minor")```
    <br>
    #### Elif
    The elif keyword allows us to evaluate multiple conditions in a single if statement.
    ```# Example of if-elif-else statement
    grade = 75
    
    if grade >= 90:
        print("Passed with an A")
    elif grade >= 80:
        print("Passed with a B")
    elif grade >= 70:
        print("Passed with a C")
    else:
        print("Failed")```
    <hr>
    
    ## Loops
    #### For Loop
    The for loop is used to iterate over a sequence (such as a list, tuple, or range) and execute a block of code for each element in the sequence.
    ```# Example of if-elif-else statement
    grade = 75
    
    if grade >= 90:
        print("Passed with an A")
    elif grade >= 80:
        print("Passed with a B")
    elif grade >= 70:
        print("Passed with a C")
    else:
        print("Failed")```
    <br>
    #### While Loop
    The while loop is used to execute a block of code while a specified condition is true.
    ```# Example of while loop
    counter = 0
    
    while counter < 5:
        print("Counter:", counter)
        counter += 1```
    <hr>
    
    With these control structures and loops, you can control the flow of execution of your program and perform repetitive tasks efficiently in Python. Practice writing and executing code to familiarize yourself with these fundamental programming concepts!',
    questions: [
      {
        description: 'What is the correct structure for an if contidional in Python?',
        options: [
          { description: 'if (condition):', value: true },
          { description: 'if condition then:', value: false },
          { description: 'if condition {', value: false },
          { description: 'if: condition', value: false }
        ]
      },
      {
        description: 'What is the output for this piece of code? for i in range(3): print(i)',
        options: [
          { description: '0 1 2', value: true },
          { description: '1 2 3', value: false },
          { description: '0 1 2 3', value: false },
          { description: '1 2', value: false }
        ]
      },
      {
        description: 'What is the reserved keyword in Python to get out of a loop?',
        options: [
          { description: 'exit', value: false },
          { description: 'quit', value: false },
          { description: 'break', value: true },
          { description: 'stop', value: false }
        ]
      },
      {
        description: 'What does the reserved keyword "else" do in an if condition in Python?',
        options: [
          { description: 'Specifies a code block which will be executed if the if condition is false.', value: true },
          { description: 'Indicates an alternative condition to if.', value: false },
          { description: 'It is used to inicialize a new conditional inside that if condition', value: false },
          { description: 'It has no use inside an if conditional.', value: false }
        ]
      },
      {
        description: 'What is the main difference between a "while" and a "for" loop in Python?',
        options: [
          { description: '"while" is used to iterate for as long as the condition holds true, while "for" is utilized to iterate over a sequence of elements.', value: true },
          { description: '"while" y "for" are synonyms and both can be used indistinctively.', value: false },
          { description: '"for" is utilized for infinite loops and "while" is utilized for loops with a finite number of iterations.', value: false },
          { description: '"for" is only used to iterate over the elements of a list, meanwhile a "while" structure is utilized for other kinds of data structures.', value: false }
        ]
      }
    ]
  },
  {
    name: 'Lesson 3: Functions and Modules',
    content: 'In this lesson, we will delve into the concepts of functions and modules in Python. Functions allow us to encapsulate a set of instructions into a reusable block of code, while modules enable us to organize related functions and variables into separate files for better code organization and reusability.
    <hr>
    ## Functions
    #### Defining Functions
    A function in Python is defined using the def keyword, followed by the function name and parentheses containing any parameters the function requires. The function body is then indented.
    ```# Example of defining a function
    def greet(name):
        """This function greets the user."""
        print("Hello, " + name + "!")```
    <br>
    #### Calling Functions
    To call a function, simply use its name followed by parentheses and any required arguments.
    ```# Example of calling a function
    greet("Alice")```
    <br>
    #### Returning Values
    Functions can also return values using the return statement.
    ```# Example of a function with return value
    def add(x, y):
        """This function adds two numbers."""
        return x + y```
    <hr>
    ## Modules
    #### Creating Modules
    A module is a file containing Python code. It can define functions, classes, and variables. To create a module, simply save your Python code in a file with a .py extension.
    ```# Example of a module saved as mymodule.py
    
    def greet(name):
        """This function greets the user."""
        print("Hello, " + name + "!")```
    <br>
    #### Importing Modules
    To use functions or variables defined in a module, you need to import the module using the import keyword.
    ```# Example of importing a module
    import mymodule
    
    mymodule.greet("Bob")```
    <br>
    #### Importing Specific Functions
    You can also import specific functions or variables from a module using the from keyword.
    ```# Example of importing a specific function from a module
    from mymodule import greet
    
    greet("Charlie")```
    <br>
    #### Renaming Modules
    If the name of a module is long or conflicts with an existing name, you can rename it using the as keyword.
    ```# Example of renaming a module
    import mymodule as m
    
    m.greet("Dave")```
    <hr>
    With functions and modules, you can write organized and reusable code in Python. Practice defining functions, creating modules, and importing them to understand these fundamental concepts better!',
    questions: [
      {
        description: 'How can we define a function in Python?',
        options: [
          { description: 'function my_func():', value: false },
          { description: 'def my_func():', value: true },
          { description: 'define my_func():', value: false },
          { description: 'func my_func():', value: false }
        ]
      },
      {
        description: 'How can we import a module in Python?',
        options: [
          { description: 'import module', value: true },
          { description: 'include module', value: false },
          { description: 'using module', value: false },
          { description: 'require module', value: false }
        ]
      },
      {
        description: 'What keyword is reserved to indicate the output of a function in Python?',
        options: [
          { description: 'send', value: false },
          { description: 'return', value: true },
          { description: 'give back', value: false },
          { description: 'output', value: false }
        ]
      },
      {
        description: 'What is the main purpose of a function in Python?',
        options: [
          { description: 'Reutilize blocks of code for specific tasks.', value: true },
          { description: 'Modify directly the global variables.', value: false },
          { description: 'Create local variables to use inside the function.', value: false },
          { description: 'Do complex mathematical operations.', value: false }
        ]
      },
      {
        description: 'What is a parameter in a Python function?',
        options: [
          { description: 'A variable which holds the output of a function.', value: false },
          { description: 'A value passed to a function to be used inside that function.', value: true },
          { description: 'A condition that has to be met to execute a function.', value: false },
          { description: 'A kind of data structure in Python.', value: false }
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
