QlFunctionType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'QlFunction'

  field :function_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :date, types.String
  field :showtimes, types.String
  field :function_types, types.String do
    resolve ->(obj, args, ctx) {
      obj.function_types.map { |ft| ft.name }.join(', ')
    }
  end
end
