QlFunctionsField = GraphQL::Field.define do
  name('functions')
  argument :date, types.String, default_value: Date.current
  argument :theater_id, types.Int, default_value: 1

  type types[QlFunctionType]
  
end
