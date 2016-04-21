TheaterType = GraphQL::ObjectType.define do
  name "Theater"
  description "A Theater"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  
  field :theater_id, types.Int do
  	resolve -> (theater, args, ctx) {
  		theater.id
  	}
  end
  field :cinema_id, types.Int, "Cinema ID"
  field :active, types.Boolean, "Is the Theater Active?"
  field :name, types.String, "Name of the Theater"
  field :address, types.String, "Address of the Theater"
end