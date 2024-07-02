# APKA Language

## Introduction:

Welcome to our project! This project is designed to showcase the capabilities of our grammar-based program interpreter. With this interpreter, you can run programs written in our specific grammar format, enabling you to execute various tasks with ease.

![image](https://capture.dropbox.com/cmPfVJLMdekKimaR) 

## Languages Used:
```
Lexer - Python
Parser, Evaluator - Prolog
```

## Components of the Design:
```
.APKA: The APKA source code file serves as the initial input to the pipeline. 
LEXER.PY: The lexer script reads the APKA source code and generates tokenized output.
.APKATOKENS: The tokenized output from the lexer is stored in a file.
PARSER.PL: The parser reads the tokenized output and generates a parse tree.
EVALUATOR.PL: Finally, the evaluator takes the parse tree as input and executes the instructions, producing the desired output.
```

# Commands and Command-List:
- Commands are the fundamental units within a Program. 
- They can be categorized into two types: those without a block and those with a block. 
- A sequence of one or more commands forms a command list. 
- Commands that do not include a block must end with a semicolon (;).

Examples:
Without block: ”chaap” ("Hello World");
With block: Enclosed within {}.

## Block:
A block is a collection of one or more commands enclosed within curly braces {}.
Example:
```
{
  // commands
}
```

## Commands:
- For Loop
- While Loop
- Enhanced For Loop
- If Statement
- If-Elif-Else Statement
- Print Statement
- Variable Declaration
- Variable Assignment

## Commands in Apka
### Variable Types:
- Integer (chotu)
- Boolean (nirnaya)
- String (vakya)

### Operations:
- Arithmetic Operations (+, -, *, /)
- Comparison Operations (==, <, >, <=, >=)
- Boolean Operations (&& ,||, !)
- Ternary Operator (? :)
- Unary Operator (++, --)

### Example code
Sum of N numbers
```
{ 
  chotu sum;
  sum = 0;
  chotu i;
  i = 5;
  jabtak(i >= 1) {
    sum = sum + i;
    --i;
  }
  chaap("Sum of first 5 numbers: ");
  chaap(sum);
}
  ```

---------------------

# Replication Steps

## Getting Started:
To get started with our project, follow these simple steps:

## Clone the Project: 
Clone our project repository to your local machine using this command:
```
git clone https://github.com/anjalibharuka/SER502-APKA-Team20.git
```


or by downloading the ZIP archive from our repository.

## Navigate to the Project Directory: 
Open your terminal or command prompt and navigate to the folder where you have cloned the project.

## Run the Interpreter:
If you already have Python installed:

For Windows
```
python runapka.py <filename>.apka
```
For Mac
```
python3 runapka.py <filename>.apka
```

If you don't have Python installed:

### For Windows:
Download Python 3 from python.org and follow the installation instructions. Then, navigate to the project directory in the command prompt and run the above command.

### For macOS: 
Python usually comes pre-installed on macOS. If not, you can download it from python.org or install it via Homebrew. Then, navigate to the project directory in the terminal and run the above command.

## Note:
Replace <Filename> with the name of the program file you want to execute. The program files should be located in the data folder of our project.

## Sample Program Files:

Sample program files are provided in the data folder of our project. You can use these files to test the interpreter and explore its capabilities. Feel free to create your own program files following our grammar format and place them in the data folder for execution.

