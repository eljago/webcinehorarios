FunctionType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'FunctionType'

  # `id` exposes the UUID
  global_id_field :id

  field :date, types.String
  field :showtimes, types.String
end
