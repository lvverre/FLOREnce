#lang brag
start: LEFT "main:" INTEGER RIGHT
@model: ( "model:"  model-def+ )
@model-def: ("def:" VAR model-expr)
@model-expr: INTEGER | STRING | VAR | (VAR model-expr+ )
;string: STRING
;symbol: SYMBOL
;var: VAR

;reactor-exp: "(" "reactor:" symbol "(""in:" symbol+ ")" number "(""OUT:" symbol+")"")" 