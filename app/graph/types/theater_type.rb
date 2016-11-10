TheaterType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'TheaterType'

  # `id` exposes the UUID
  global_id_field :id

  field :name, types.String
  field :cinema_id, types.Int
  field :address, types.String
  field :active, types.Boolean
  field :functions, types[QlFunctionType] do
    argument :date, types.String, default_value: Date.current
    argument :aditional_days, types.Int, default_value: 0
    resolve ->(obj, args, ctx) {
      obj.functions.where(date: args[:date].to_date + args[:aditional_days])
    }
  end
end
