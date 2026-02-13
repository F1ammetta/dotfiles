(function_definition
  name: (_) @function.name
  body: (_) @function.body)

(local_function_definition
  name: (_) @function.name
  body: (_) @function.body)

(assignment
  left: (variable_expression
    name: (_) @function.name)
  right: (function_definition
    body: (_) @function.body))