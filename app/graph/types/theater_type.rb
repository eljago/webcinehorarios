TheaterType = GraphQL::ObjectType.define do
  # Hack to support root queries
  name 'TheaterType'

  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id

  field :theater_id, types.Int do
    resolve ->(obj, args, ctx) {
      obj.id
    }
  end
  field :name, types.String
  field :cinema_id, types.Int
  field :address, types.String
  field :active, types.Boolean
end
