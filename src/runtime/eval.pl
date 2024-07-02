% Author - Kushagra, Prasheel
% Purpose - This file contains the evaluator for the parser
% Version - 3.0
% Date - 04-29-2024

lookup(V, [(_DataType, V, Val) | _], Val).
lookup(V, [(_DataType, V1, _) | T], Val) :-
    V1 \= V,
    lookup(V, T, Val).
lookup(V, [], _) :-
%    print("Variable Not Found"),
    fail.

update(DataType, V, NewVal, [], [(DataType, V, NewVal)]).
update(DataType, V, NewVal, [(DataType, V, _) | TEnv], [(DataType, V, NewVal) | TEnv]).
update(DataType, V, NewVal, [HEnv | TEnv], [HEnv | TNewEnv]) :-
    (DataType, V, _) \= HEnv,
    update(DataType, V, NewVal, TEnv, TNewEnv).

check_in_env(V, [(_, V, _) | _]).
check_in_env(V, [(_, V1, _) | T]) :-
    V1 \= V,
    check_in_env(V, T).

% Program Evaluator
eval_program(t_program(StatementList), Env, NEnv) :-
    eval_statement_list(StatementList, Env, NEnv).

% StatementList Evaluator
eval_statement_list(t_single_statement(Statement), Env, NEnv) :- eval_statement(Statement, Env, NEnv).
eval_statement_list(t_statement_list(StatementList, Statement), Env, NEnv) :-
    eval_statement_list(StatementList, Env, Env1),
    eval_statement(Statement, Env1, NEnv).

% Statement Evaluator
eval_statement(t_decl_stmt(Declaration), Env, NEnv) :- eval_declaration(Declaration, Env, NEnv).
eval_statement(t_assign_stmt(Assignment), Env, NEnv) :- eval_assign(Assignment, Env, NEnv).
eval_statement(t_print_stmt(PrintStatement), Env, Env) :- eval_print_statement(PrintStatement, Env).
eval_statement(t_if_stmt(IfStatement), Env, NEnv) :- eval_if_statement(IfStatement, Env, NEnv).
eval_statement(t_while_stmt(WhileLoop), Env, NEnv) :- eval_while(WhileLoop, Env, NEnv).
eval_statement(t_for_stmt(ForLoop), Env, NEnv) :- eval_for_loop(ForLoop, Env, NEnv).
eval_statement(t_for_range_stmt(ForRange), Env, NEnv) :- eval_for_range(ForRange, Env, NEnv).

%================
%--IF EVALUATOR--
%================ 

eval_if_statement(t_if_parent(Condition, StatementList, _), Env, NEnv) :-
    eval_condition(Condition, Env, sach),
    eval_statement_list(StatementList, Env, NEnv).

eval_if_statement(t_if_parent(Condition, _, IfStatement1), Env, NEnv) :-
    eval_condition(Condition, Env, false),
    eval_if_statement_(IfStatement1, Env, NEnv).

eval_if_statement_(t_if(), Env, Env).

eval_if_statement_(t_else(StatementList), Env, NEnv) :-
    eval_statement_list(StatementList, Env, NEnv).

eval_if_statement_(t_else_if(IfStatement), Env, NEnv) :-
    eval_if_statement(IfStatement, Env, NEnv).

eval_condition(t_cond_negate(Condition), Env, sach) :-
    eval_condition(Condition, Env, false).

eval_condition(t_cond_negate(Condition), Env, false) :-
    eval_condition(Condition, Env, sach).

% While Evaluator
eval_while(t_while(Condition, _), Env, Env) :-
    eval_condition(Condition, Env, false).

eval_while(t_while(Condition, StatementList), Env, NEnv) :-
    eval_condition(Condition, Env, sach),
    eval_statement_list(StatementList, Env, Env1),
    eval_while(t_while(Condition, StatementList), Env1, NEnv).

%==================
% FOR LOOP OPERATOR 
%==================

eval_for_loop(t_for_loop(Assignment1, Condition, _Assignment2, _Block), Env, NEnv) :-
    eval_assign(Assignment1, Env, NEnv),
    eval_condition(Condition, NEnv, false).

eval_for_loop(t_for_loop(Assignment1, Condition, Assignment2, StatementList), Env, NEnv) :-
    eval_assign(Assignment1, Env, Env1),
    eval_condition(Condition, Env1, sach),
    eval_statement_list(StatementList, Env1, Env2),
    eval_loop(Condition, Assignment2, StatementList, Env2, NEnv).

eval_loop(Condition, Assignment, _Block, Env, NEnv) :-
    eval_assign(Assignment, Env, NEnv),
    eval_condition(Condition, NEnv, false).

eval_loop(Condition, Assignment, StatementList, Env, NEnv) :-
    eval_assign(Assignment, Env, Env1),
    eval_condition(Condition, Env1, sach),
    eval_statement_list(StatementList, Env1, Env2),
    eval_loop(Condition, Assignment, StatementList, Env2, NEnv).


%====================
% FOR RANGE EVALUATOR
%====================

eval_for_range(t_for_range(Variable, ForInteger1, ForInteger2, _Block), Env, NEnv) :-
    get_identifier(Variable, I),
    eval_for_integer(ForInteger1, Env, Start),
    update(chotu, I, Start, Env, NEnv),
    eval_for_integer(ForInteger2, NEnv, End),
    Start >= End.

eval_for_range(t_for_range(Variable, ForInteger1, ForInteger2, StatementList), Env, NEnv) :-
    get_identifier(Variable, I),
    eval_for_integer(ForInteger1, Env, Start),
    update(chotu, I, Start, Env, Env1),
    eval_for_integer(ForInteger2, Env1, End),
    Start < End,
    eval_statement_list(StatementList, Env1, Env2),
    eval_range_loop(I, Start, End, StatementList, Env2, NEnv).

eval_range_loop(I, Start, End, _Block, Env, NEnv) :-
    Start1 is Start + 1,
    update(chotu, I, Start1, Env, NEnv),
    Start1 >= End.

eval_range_loop(I, Start, End, StatementList, Env, NEnv) :-
    Start1 is Start + 1,
    update(chotu, I, Start1, Env, Env1),
    Start1 < End,
    eval_statement_list(StatementList, Env1, Env2),
    eval_range_loop(I, Start1, End, StatementList, Env2, NEnv).


eval_for_integer(t_for_int(Integer), _, N) :- eval_integer(Integer, N).
eval_for_integer(t_for_id(Variable), Env, N) :- eval_identifier(Variable, Env, N).


% Declaration Evaluator
eval_declaration(t_declare_var(Type, Variable), Env, NEnv) :-
    eval_variable(Variable, Type, Env, NEnv).

% Variable Evaluator
eval_variable(t_var_id(Variable), chotu, Env, NEnv) :-
    get_identifier( Variable, I),
    update(chotu, I, 0, Env, NEnv).

eval_variable(t_var_id(Variable), vakya, Env, NEnv) :-
    get_identifier( Variable, I),
    update(vakya, I, '', Env, NEnv).

eval_variable(t_var_id(Variable), nirnaya, Env, NEnv) :-
    get_identifier( Variable, I),
    update(nirnaya, I, false, Env, NEnv).

%===================
%--PRINT EVALUATOR--
%===================
eval_print_statement(t_print_statement(PrintValues), Env) :- eval_print_values(PrintValues, Env), nl.
eval_print_values(t_print_values(t_print_int(t_integer(N)), PrintValues), Env) :-
    write(N),
    write(" "),
    eval_print_values(PrintValues , Env).
eval_print_values(t_print_values(t_print_string(t_string(S)), PrintValues), Env) :-
    write(S),
    write(" "),
    eval_print_values(PrintValues , Env).
eval_print_values(t_print_values(t_print_bool(t_boolean(B)), PrintValues), Env) :-
    write(B),
    write(" "),
    eval_print_values(PrintValues , Env).

eval_print_values(t_print_int(t_integer(N)), _) :- write(N).
eval_print_values(t_print_string(t_string(S)), _) :- write(S).
eval_print_values(t_print_bool(t_boolean(B)), _) :- write(B).
eval_print_values(t_print_identifier(I), Env) :- eval_identifier(I, Env, IVal), write(IVal).


% Assignment Evaluator
eval_assign(t_assign_expr(Variable, Expression), Env, NewEnv) :-
    get_identifier(Variable, I),
    eval_expr(Expression, Env, Val),
    ((check_in_env(I, Env), update(_, I, Val, Env, NewEnv));
    (\+ check_in_env(I, Env) , write("Variable doesn't exist!!"), fail)).

eval_assign(t_assign_str(Variable, String), Env, NewEnv) :-
    get_identifier(Variable, I),
    eval_string(String, Val),
    ((check_in_env(I, Env), update(_, I, Val, Env, NewEnv));
    (\+ check_in_env(I, Env) , write("Variable doesn't exist!!"), fail)).

eval_assign(t_assign_ternary(Variable, Ternary), Env, NewEnv) :-
    get_identifier(Variable, I),
    eval_ternary(Ternary, Env, Val),
    ((check_in_env(I, Env), update(_, I, Val, Env, NewEnv));
    (\+ check_in_env(I, Env) , write("Variable doesn't exist!!"), fail)).

eval_assign(t_assign_increment(Variable), Env, NewEnv) :-
    get_identifier(Variable, I),
    ((check_in_env(I, Env), eval_identifier(Variable, Env, Val), NewVal is Val + 1, update(_, I, NewVal, Env, NewEnv));
    (\+ check_in_env(I, Env) , write("Variable doesn't exist!!"), fail)).

eval_assign(t_assign_decrement(Variable), Env, NewEnv) :-
    get_identifier(Variable, I),
    ((check_in_env(I, Env), eval_identifier(Variable, Env, Val), NewVal is Val - 1, update(_, I, NewVal, Env, NewEnv));
    (\+ check_in_env(I, Env) , write("Variable doesn't exist!!"), fail)).

%=========================
%--- VARIABLE EVALUATOR---
%=========================
eval_identifier(t_identifier(I), Env, Val) :- lookup(I, Env, Val).
get_identifier(t_identifier(I), I).

eval_integer(t_integer(N), N).
eval_string(t_string(S), S).
eval_bool(t_boolean(B), B).

%=========================
%---TERNARY OPERATOR---
%=========================

eval_ternary(t_ternary(Condition, Expression1, _), Env, ReturnVal) :-
    eval_condition(Condition, Env, sach),
    eval_expr(Expression1, Env, ReturnVal).

eval_ternary(t_ternary(Condition, _, Expression2), Env, ReturnVal) :-
    eval_condition(Condition, Env, false),
    eval_expr(Expression2, Env, ReturnVal).

% Expression Evaluator
eval_expr(t_add(Expression, Term), Env, Val) :-
    eval_expr(Expression, Env, Val_expr),
    eval_term(Term, Env, Val_term),
    Val is Val_expr + Val_term.

eval_expr(t_sub(Expression, Term), Env, Val) :-
    eval_expr(Expression, Env, Val_expr),
    eval_term(Term, Env, Val_term),
    Val is Val_expr - Val_term.

eval_expr(Term, Env, Val) :- eval_term(Term, Env, Val).

eval_term(t_mul(Term, Factor), Env, Val) :-
    eval_term(Term, Env, Val_term),
    eval_factor(Factor, Env, Val_fact),
    Val is Val_term * Val_fact.

eval_term(t_div(Term, Factor), Env, _) :-
    eval_term(Term, Env, _),
    eval_factor(Factor, Env, Val_fact),
    Val_fact = 0,
    write("Invalid: Division by 0!!"),
    fail.

eval_term(t_div(Term, Factor), Env, Val) :-
    eval_term(Term, Env, Val_term),
    eval_factor(Factor, Env, Val_fact),
    Val_fact \= 0,
    Val is Val_term / Val_fact.

eval_term(Factor, Env, Val) :- eval_factor(Factor, Env, Val).

eval_factor(t_integer(N), _, N) :- eval_integer(t_integer(N), N).
eval_factor(t_boolean(N), _, N) :- eval_bool(t_boolean(N), N).
eval_factor(Variable, Env, Val) :- eval_identifier(Variable, Env, Val).
eval_factor(t_par('(', Expression, ')'), Env, Val) :- eval_expr(Expression, Env, Val).

%====================
% CONDITION EVALUATOR
%====================

eval_condition(t_cond_cond(Condition1, '&&', Condition2), Env, false) :-
    eval_condition(Condition1, Env, false);
    eval_condition(Condition2, Env, false).

eval_condition(t_cond_cond(Condition1, '&&', Condition2), Env, sach) :-
    eval_condition(Condition1, Env, sach),
    eval_condition(Condition2, Env, sach).

eval_condition(t_cond_cond(Condition1, '||', Condition2), Env, false) :-
    eval_condition(Condition1, Env, false),
    eval_condition(Condition2, Env, false).

eval_condition(t_cond_cond(Condition1, '||', Condition2), Env, sach) :-
    eval_condition(Condition1, Env, sach);
    eval_condition(Condition2, Env, sach).

eval_condition(t_cond_expr(Expression1, <, Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 < Value2, Value = sach);( \+(Value1 < Value2), Value = false)).

eval_condition(t_cond_expr(Expression1, >, Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 > Value2, Value = sach);( \+(Value1 > Value2), Value = false)).

eval_condition(t_cond_expr(Expression1, <=, Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 > Value2, Value = false);( \+(Value1 > Value2), Value = sach)).

eval_condition(t_cond_expr(Expression1, >=, Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 >= Value2, Value = sach);( \+(Value1 >= Value2), Value = false)).

eval_condition(t_cond_expr(Expression1, ==, Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 = Value2, Value = sach);( \+(Value1 = Value2), Value = false)).

eval_condition(t_cond_expr(Expression1, '!=', Expression2), Env, Value) :-
    eval_expr(Expression1, Env, Value1),
    eval_expr(Expression2, Env, Value2),
    (( Value1 = Value2, Value = false);( \+(Value1 = Value2), Value = sach)).

eval_condition(t_cond_bool(Boolean), _, Value) :-
    eval_bool(Boolean, Value).

