Program → Statement_list

Statement_list → Statement 
    | Statement Statement_list

Statement → Assignment 
    	| If_statement 
    	| While_loop 
    	| For_loop 
    	| For_range_loop 
	| Assignment
	| Declaration
    	| Print
Declaration → Data_Type Variable

Data_Type → chotu | nirnaya | vakya


Assignment → Variable = Expression
	|Variable = String
	|Variable = Ternary
	| Variable = Variable
	| ++ Variable
	| -- Variable
 
If_statement → if ( Condition )  { Statement  } else {  Statement_list }

While_loop → jabtak ( Condition ) { Statement_list }

For_loop → tabtak ( Assignment ; Condition ; Assignment ) { Statement_list }

For_range_loop → tabtak( Variable se range(From ; To) 
{ Statement_list }

Print → chaap( “Print_Values“) 
Print_Values → Int | String | Identifier 

Expression → Expression + Term
	| Expression - Term
	| Term
Term → Term * Factor
	| Term / Factor
	| Factor
Factor → Integer | Boolean | String | Variable | ( Expression )
    | String 
    | Bool 
    | Variable 
    | Expression Operator Expression 
    | ( Expression ) 
    | Ternary_operator

Condition → Expression Relational_Op Expression
| Expression Logical_Op Expression
| Boolean
| ! Condition


Ternary_operator → Condition? Expression : Expression

Relational_operator → == 
    | < 
    | > 
    | <= 
    | >= 
    | !=

Int → [0-9]+

Bool → sach
    | jhoot
    

Logical_Op → and 
    | or 

String → [a-zA-Z\S]+
Variable → [a-zA-Z0-9]+
