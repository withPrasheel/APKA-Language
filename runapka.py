# Author - Asad Seikh, Prasheel Nandwana
# Purpose - Shell Script to run the APKA compiler
# Version - 1.0
# Date - 04-21-2024
import os
import sys
from path import ROOT_DIR;
from src.tokenize.lexer import tokenize
import subprocess

def main():
    try:
        filename = sys.argv[1]
        os.chdir(f"{ROOT_DIR}/data")
        tokenize(filename,f"{ROOT_DIR}/target")
        tokenized_keyword_file = "../../target/tokens.apka"
        os.chdir(f"{ROOT_DIR}/src/compiler")     
        response = subprocess.run(['swipl', 
                                 '-f', 
                                 'tokenize.pl', 
                                 '-g', 
                                 f'convert("{tokenized_keyword_file}"),halt.'], 
                                 capture_output=True, 
                                 text=True)
        print(response.stdout)

    except KeyboardInterrupt:
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)


main()