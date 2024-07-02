# # Author: Prasheel Nandwana
# # Created: 04-21-2024
# # Purpose: Lexer class for tokenizing the input source code into tokens
# # Version: 3.0

import os.path
import re
from path import ROOT_DIR

tokens = [
    ('INT', r'\bchotu\b'),
    ('STRING', r'\bvakya\b'),
    ('IF', r'\bjab\b'),
    ('ELSE', r'\bnahito\b'),
    ('WHILE', r'\bjabtak\b'),
    ('FOR', r'\btabtak\b'),
    ('IN', r'\bse\b'),
    ('RANGE', r'\brange\b'),
    ('PRINTEXP', r'print\s*\(\s*("[^"]*"|\'[^\']*\'|[^\)]*)\s*\)'),
    ('PRINT', r'\bchaap\b'),
    ('EQ', r'=='),
    ('LE', r'<='),
    ('GE', r'>='),
    ('NE', r'!='),
    ('AND', r'&&'),
    ('OR', r'\|\|'),
    ('ASSIGN', r'='),
    ('LT', r'<'),
    ('GT', r'>'),
    ('N', r'!'),
    ('QUESTION', r'\?'),
    ('COLON', r':'),
    ('SEMICOLON', r';'),
    ('LBRACE', r'{'),
    ('RBRACE', r'}'),
    ('LPAREN', r'\('),
    ('RPAREN', r'\)'),
    ('ID', r'[a-zA-Z_]\w*'),
    ('NUM', r'\d+'),
    ('INC', r'\++'),
    ('DEC', r'\--'),
    ('PLUS', r'\+'),
    ('MINUS', r'-'),
    ('MUL', r'\*'),
    ('DIV', r'/'),
    ('MOD', r'%'),
    ('COMMA', r','),
    ('FORLOOP', r'for\s*\('),
    ('RANGELOOP', r'range\s*\('),
    ('WHITESPACE', r'\s+'),
    ('PRINT_TEXT', r'("[^"]*"|\'[^\']*\'|[^\)]*)')
]

tokenized_output = []

def tokenize(source_file, target_dir):
    with open(source_file, 'r') as file:
        program = file.read()
    os.chdir(f"{target_dir}")     
    text_file = open("tokens.apka", "w")
    pattern = '|'.join('(?P<%s>%s)' % pair for pair in tokens)
    for match in re.finditer(pattern, program):
        token_type = match.lastgroup
        token_value = match.group()
        if token_type == 'WHITESPACE':
            continue
        elif token_type == 'PRINTEXP':
            print_value = token_value[6:len(token_value) - 1].split(',')
            tokenized_output.append("print" + '\n' + "(" + '\n')
            for value in print_value:
                tokenized_output.append( value.strip() + '\n')
                tokenized_output.append(","+"\n")
            tokenized_output.pop()    
            tokenized_output.append( ")" + '\n')
            continue
        tokenized_output.append(token_value + '\n')
    i = 0    
    while i < len(tokenized_output):
        if tokenized_output[i][0] == '"' and tokenized_output[i][-2] == '"':
            var = tokenized_output[i][1:-2]
            tokenized_output.insert(i, '"' + '\n')
            tokenized_output.insert(i+1, var + '\n')
            tokenized_output.insert(i+2, '"' + '\n')
            tokenized_output.pop(i+3)
            i+=2
        i+=1
    tokenized_output.pop()
    text_file.write(''.join(tokenized_output))
    return tokenized_output
