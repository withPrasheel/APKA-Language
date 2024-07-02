% Author - Anjali, Kushagra
% Purpose - This file contains the evaluator for the parser
% Version - 3.0
% Date - 04-29-2024


:-table statement_list/3, expression/3, term/3, factor/3, condition/3.

program(t_program(StatementList)) -->
    ['{'], 
    statement_list(StatementList), 
    ['}'].


statement_list(t_statement_list(StatementList, Statement)) --> 
    statement_list(StatementList), 
    statement(Statement).
statement_list(t_single_statement(Statement)) --> statement(Statement).


statement(t_while_stmt(X)) --> while_loop(X).
statement(t_for_stmt(X)) --> for_loop(X).
statement(t_for_range_stmt(X)) --> for_range(X).
statement(t_if_stmt(X)) --> if_statement(X).
statement(t_decl_stmt(X)) --> declaration(X), [;].
statement(t_assign_stmt(X)) --> assignment(X), [;].
statement(t_print_stmt(X)) --> print_statement(X), [;].

%================
%---WHILE LOOP---
%================
while_loop(t_while(Condition, StatementList)) --> 
    [jabtak], 
    ['('], 
    condition(Condition),
    [')'], 
    ['{'], 
    statement_list(StatementList), 
    ['}'].
%================

%==============
%---FOR LOOP---
%==============
for_loop(t_for_loop(Assignment1, Condition, Assignment2, StatementList)) --> 
    [tabtak], 
    ['('], assignment(Assignment1), [;], condition(Condition), [;], assignment(Assignment2), [')'], 
    ['{'], 
    statement_list(StatementList), 
    ['}'].
%==============

%====================
%---FOR RANGE LOOP---
%====================
for_range(t_for_range(Variable, From, To, StatementList)) --> 
    [tabtak], identifier(Variable), [se], [range], 
    ['('], for_integer(From), [';'], for_integer(To), [')'], 
    ['{'], 
    statement_list(StatementList),
    ['}'].
%====================

%==========================
%---VARIABLE DECLARATION---
%==========================
declaration(t_declare_var(DataType, Variable)) --> 
    data_type(DataType), variable(Variable).
%==========================

%============================
%---ASSIGNMENT DECLARATION---
%============================
assignment(t_assign_expr(Variable, Expression)) --> 
    identifier(Variable), [=], expression(Expression).
assignment(t_assign_str(Variable, String)) --> 
    identifier(Variable), [=], string(String).
assignment(t_assign_ternary(Variable, Ternary)) --> 
    identifier(Variable), [=], ternary(Ternary).
assignment(t_assign_increment(Variable)) --> 
    increment_operator(_), identifier(Variable).
assignment(t_assign_decrement(Variable)) --> 
    decrement_operator(_), identifier(Variable).

%==================
%---IF STATEMENT---
%==================
if_statement(t_if_parent(Condition, StatementList, IfStatement1)) --> 
    [jab], 
    ['('], 
    condition(Condition), 
    [')'], 
    ['{'], 
    statement_list(StatementList), 
    ['}'], 
    if_statement_(IfStatement1).
if_statement_(t_if()) --> [].


if_statement_(t_else_if(IfStatement)) --> 
    [nahito], 
    if_statement(IfStatement).

if_statement_(t_else(StatementList)) --> 
    [nahito], 
    ['{'], 
    statement_list(StatementList), 
    ['}'].
%==================

%=====================
%---PRINT STATEMENT---
%=====================
print_statement(t_print_statement(PrintValues)) --> 
    [chaap], ['('], print_values(PrintValues), [')'].
print_values(t_print_int(Integer)) --> integer(Integer).
print_values(t_print_string(String)) --> string(String).
print_values(t_print_identifier(Variable)) --> identifier(Variable).
%=====================

%================
%---EXPRESSION---
%================
ternary(t_ternary(Condition, Expression1, Expression2)) --> 
    condition(Condition), [?], expression(Expression1), [:], expression(Expression2).


expression(t_add(Expression, Term)) --> expression(Expression), [+], term(Term).
expression(t_sub(Expression, Term)) --> expression(Expression), [-], term(Term).
expression(Term) --> term(Term).

term(t_mul(Term, Factor)) --> term(Term), [*], factor(Factor).
term(t_div(Term, Factor)) --> term(Term), [/], factor(Factor).
term(Factor) --> factor(Factor).

factor(Integer) --> integer(Integer).
factor(Boolean) --> boolean(Boolean).
factor(Variable) --> identifier(Variable).
factor(t_par('(', Expression, ')')) --> ['('], expression(Expression), [')'].

%===============
%---CONDITION---
%===============
condition(t_cond_expr(Expression1, RelationOp, Expression2)) --> 
    expression(Expression1), relation_op(RelationOp), expression(Expression2).
condition(t_cond_cond(Condition1, LogicalOp, Condition2)) --> 
    condition(Condition1), logical_op(LogicalOp), condition(Condition2).
condition(t_cond_bool(Boolean)) --> 
    boolean(Boolean).
condition(t_cond_negate(Condition)) --> 
    [!], condition(Condition).
%===============

relation_op(Head, [Head | T], T) :-
    member(Head, [<, >, <=, >=, ==, '!=']).

logical_op(Head, [Head | T], T) :-
    member(Head, ['&&', '||']).

for_integer(t_for_int(Integer)) --> integer(Integer).
for_integer(t_for_id(Variable)) --> identifier(Variable).

data_type(Head, [Head | T], T) :- member(Head, [chotu, nirnaya, vakya]).

increment_operator(t_increment_operator) --> [++].
decrement_operator(t_decrement_operator) --> [--].
variable(t_var_id(Variable)) --> identifier(Variable).
identifier(t_identifier(X)) --> [X], {atom(X)}.

integer(t_integer(N)) --> [N], {integer(N)}.
string(t_string(S)) --> ['"'], [S], ['"'], {atom(S)}.
boolean(t_boolean(sach)) --> [sach].
boolean(t_boolean(jhoot)) --> [jhoot].

