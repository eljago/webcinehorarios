TheaterType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'Theater'

  field :theater_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :parent_theater_id, types.Int
  field :name, types.String
  field :cinema_id, types.Int
  field :address, types.String
  field :active, types.Boolean
  field :functions, types[QlFunctionType]
end
