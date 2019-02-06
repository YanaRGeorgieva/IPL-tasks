# Code Refactoring Tool for Prolog written in Prolog

## Can answer questions like:

1. Where is X defined (first encountering in clause for variable)? returns list of "line number, predicate name".
2. Where is X defined (all encounterings of clause in program for predicate where it is the head of a clause)? returns list of "line number".
3. Where is X used (all encounterings of variable in clauses)? returns list of "line number, predicate name".
4. Where is X used (all encounterings of clause in program for predicate where it is in the body of a clause)? returns list of "line number, predicate name".

## Lets you refactor the code a bit:

5. Can rename variable identifier in a given program and predicate identifier.
6. Can rename predicate identifier in a given program.
7. Extract predicate from longer clause. Creates a new predicate whose name will be \$predicate_name (user defined) and will be situated at the end of the file.
