TheaterType = GraphQL::ObjectType.define do
  name "Theater"
  description "A Theater"

  interfaces [NodeIdentification.interface]

  # `id` exposes the UUID
  global_id_field :id
  field :cinema, -> {CinemaType}
  field :active, types.Boolean, "Is the Theater Active?"
  field :name, types.String, "Name of the Theater"
  field :address, types.String, "Address of the Theater"
end